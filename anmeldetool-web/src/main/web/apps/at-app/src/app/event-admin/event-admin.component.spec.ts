import { HttpErrorResponse } from '@angular/common/http';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, provideRouter, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { type Observable, of, Subject, throwError } from 'rxjs';
import { vi } from 'vitest';
import { IAnlass } from '../core/model/IAnlass';
import { KategorieEnum } from '../core/model/KategorieEnum';
import { TiTuEnum } from '../core/model/TiTuEnum';
import { AnlassActions } from '../core/redux/anlass/anlass.actions';
import { AnlassService } from '../core/service/anlass/anlass.service';
import { AuthService } from '../core/service/auth/auth.service';
import { RanglistenService } from '../core/service/rangliste/ranglisten.service';
import { EventAdminComponent } from './event-admin.component';

describe('EventAdminComponent deletion', () => {
  let fixture: ComponentFixture<EventAdminComponent>;
  let confirmation: Subject<boolean>;
  let isAdministrator: boolean;
  const openDialog = vi.fn();
  const deleteAnlass = vi.fn();
  const dispatch = vi.fn();
  const event = new IAnlass({
    id: 'event-id',
    anlassBezeichnung: 'Testanlass',
    ort: 'Zürich',
    tiTu: TiTuEnum.Alle,
    tiefsteKategorie: KategorieEnum.K1,
    hoechsteKategorie: KategorieEnum.K7,
  });

  beforeEach(async () => {
    vi.clearAllMocks();
    isAdministrator = true;
    confirmation = new Subject<boolean>();
    openDialog.mockReturnValue({ afterClosed: () => confirmation.asObservable() });
    deleteAnlass.mockReturnValue(of(undefined));
    await TestBed.configureTestingModule({
      imports: [EventAdminComponent],
      providers: [
        provideRouter([]),
        { provide: MatDialog, useValue: { open: openDialog } },
        { provide: ActivatedRoute, useValue: { snapshot: { params: { id: event.id } } } },
        { provide: Store, useValue: { pipe: (): Observable<IAnlass> => of(event), dispatch } },
        {
          provide: AnlassService,
          useValue: { deleteAnlass, getTeilnahmeStatistic: (): Observable<Record<string, never>> => of({}) },
        },
        {
          provide: AuthService,
          useValue: { isAdministratorSig: (): boolean => isAdministrator, isSekretariat: (): boolean => false },
        },
        { provide: RanglistenService, useValue: {} },
      ],
    })
      .overrideComponent(EventAdminComponent, {
        set: { imports: [], template: '<ng-template #deleteDialog>Delete confirmation</ng-template>' },
      })
      .compileComponents();
    vi.spyOn(TestBed.inject(Router), 'navigate').mockResolvedValue(true);
    fixture = TestBed.createComponent(EventAdminComponent);
    fixture.detectChanges();
  });

  afterEach(() => {
    fixture.destroy();
    vi.restoreAllMocks();
  });

  it('does not delete when confirmation is cancelled', () => {
    fixture.componentInstance.onDeleteAnlass();
    confirmation.next(false);
    confirmation.complete();
    expect(deleteAnlass).not.toHaveBeenCalled();
    expect(fixture.componentInstance.isDeleting()).toBe(false);
    expect(dispatch).not.toHaveBeenCalled();
  });

  it('deletes only after confirmation and refreshes the event list', () => {
    fixture.componentInstance.onDeleteAnlass();
    expect(deleteAnlass).not.toHaveBeenCalled();
    confirmation.next(true);
    confirmation.complete();
    expect(deleteAnlass).toHaveBeenCalledExactlyOnceWith(event.id);
    expect(dispatch).toHaveBeenCalledWith(AnlassActions.loadAllAnlaesseInvoked());
    expect(TestBed.inject(Router).navigate).toHaveBeenCalledWith(['/anlaesse']);
    expect(fixture.componentInstance.isDeleting()).toBe(false);
  });

  it('prevents duplicate confirmations and requests while deleting', () => {
    const pending = new Subject<void>();
    deleteAnlass.mockReturnValue(pending.asObservable());
    fixture.componentInstance.onDeleteAnlass();
    fixture.componentInstance.onDeleteAnlass();
    expect(openDialog).toHaveBeenCalledOnce();
    confirmation.next(true);
    confirmation.complete();
    fixture.componentInstance.onDeleteAnlass();
    expect(deleteAnlass).toHaveBeenCalledOnce();
    expect(fixture.componentInstance.isDeleting()).toBe(true);
    pending.next();
    pending.complete();
    expect(fixture.componentInstance.isDeleting()).toBe(false);
  });

  it('keeps the event open and explains when linked data prevents deletion', () => {
    deleteAnlass.mockReturnValue(throwError(() => new HttpErrorResponse({ status: 409 })));
    fixture.componentInstance.onDeleteAnlass();
    confirmation.next(true);
    confirmation.complete();
    expect(fixture.componentInstance.deleteError()).toContain('weitere Daten');
    expect(fixture.componentInstance.isDeleting()).toBe(false);
    expect(dispatch).not.toHaveBeenCalled();
    expect(TestBed.inject(Router).navigate).not.toHaveBeenCalled();
  });

  it('does not offer deletion without the required role', () => {
    isAdministrator = false;
    fixture.componentInstance.onDeleteAnlass();
    expect(openDialog).not.toHaveBeenCalled();
    expect(deleteAnlass).not.toHaveBeenCalled();
  });
});
