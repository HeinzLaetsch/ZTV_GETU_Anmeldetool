import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideStore } from '@ngrx/store';
import { ActivatedRoute } from '@angular/router';
import { appReducers } from 'src/app/core/redux/app.reducer';

import { EventsDetailComponent } from './events-detail.component';

describe('EventsDetailComponent', () => {
  let component: EventsDetailComponent;
  let fixture: ComponentFixture<EventsDetailComponent>;

  beforeEach(async (): Promise<void> => {
    TestBed.configureTestingModule({
      imports: [EventsDetailComponent],
      providers: [
        provideHttpClient(),
        provideStore(appReducers),
        {
          provide: ActivatedRoute,
          useValue: {
            snapshot: {
              params: { id: 'test-id' },
              paramMap: { get: (): string => 'test-id' },
            },
            params: {},
          },
        },
      ],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EventsDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
