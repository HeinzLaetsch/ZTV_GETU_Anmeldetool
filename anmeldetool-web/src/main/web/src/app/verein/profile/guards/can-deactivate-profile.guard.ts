import { Injectable } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { CanDeactivate } from "@angular/router";
import { Observable, of, Subject } from "rxjs";
import { map } from "rxjs/operators";
import { ProfileComponent } from "../profile.component";
import { HasChangesComponent } from "./has-changes.component";

@Injectable({
  providedIn: "root",
})
export class CanDeactivateProfileGuard
  implements CanDeactivate<ProfileComponent>
{
  dialogResult: Subject<string>;
  constructor(public dialog: MatDialog) {
    this.dialogResult = new Subject();
  }
  canDeactivate(component: ProfileComponent): Observable<boolean> {
    if (component.disAllowTab()) {
      // this.openDialog().subscribe((result) => {
      return this.openDialog().pipe(
        map((result) => {
          console.log(result);
          if (result === "Cancel") {
            return true;
          } else {
            return false;
          }
        })
      );
    }
    return of(true);
  }

  private openDialog(): Observable<string> {
    const dialogRef = this.dialog.open(HasChangesComponent, {
      data: undefined,
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log(`Dialog result: ${result}`);
      this.dialogResult.next(result);
    });
    return this.dialogResult.asObservable();
  }
}
