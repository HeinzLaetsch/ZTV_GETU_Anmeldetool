import { Router } from "@angular/router";
import { Action, Selector, State, StateContext } from "@ngxs/store";
import { tap } from "rxjs/operators";
import { ITeilnehmer } from "../model/ITeilnehmer";
import { AuthService } from "../service/auth/auth.service";
import { TeilnehmerService } from "../service/teilnehmer/teilnehmer.service";
import { GetTeilnehmer } from "./teilnehmer.actions";

export class TeilnehmerStateModel {
  teilnehmer: ITeilnehmer[];
  areTeilnehmerLoaded: boolean;
}

@State<TeilnehmerStateModel>({
  name: "teilnehmer",
  defaults: {
    teilnehmer: [],
    areTeilnehmerLoaded: false,
  },
})
export class TeilnehmerState {
  constructor(
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService,
    private router: Router
  ) {}

  @Selector()
  static getTeilnehmerList(state: TeilnehmerStateModel) {
    return state.teilnehmer;
  }

  @Selector()
  static areTeilnehmerLoaded(state: TeilnehmerStateModel) {
    return state.areTeilnehmerLoaded;
  }

  @Action(GetTeilnehmer)
  getTeilnehmer({ getState, setState }: StateContext<TeilnehmerStateModel>) {
    return this.teilnehmerService
      .getTeilnehmer(this.authService.currentVerein)
      .pipe(
        tap((result) => {
          const state = getState();
          setState({
            ...state,
            teilnehmer: result,
            areTeilnehmerLoaded: true,
          });
        })
      );
  }

  /*
  @Action(DeleteCourse)
  deleteCourse(
    { getState, setState }: StateContext<CourseStateModel>,
    { id }: DeleteCourse
  ) {
    return this.courseService.deleteCourse(id).pipe(
      tap((result) => {
        const state = getState();
        const filteredArray = state.courses.filter((item) => item.id !== id);
        setState({
          ...state,
          courses: filteredArray,
        });
      })
    );
  }

  @Action(UpdateCourse)
  updateCourse(
    { getState, setState }: StateContext<CourseStateModel>,
    { payload, id }: UpdateCourse
  ) {
    return this.courseService.updateCourse(id, payload).pipe(
      tap((result) => {
        const state = getState();
        const coursesList = [...state.courses];
        const courseIndex = coursesList.findIndex((item) => item.id === id);
        coursesList[courseIndex] = result;

        setState({
          ...state,
          courses: coursesList,
        });
      })
    );
  }

  @Action(AddCourse)
  addTodo(
    { getState, patchState }: StateContext<CourseStateModel>,
    { payload }: AddCourse
  ) {
    return this.courseService.createCourse(payload).pipe(
      tap((result) => {
        const state = getState();
        patchState({
          courses: [...state.courses, result],
        });
        this.router.navigateByUrl("/courses");
      })
    );
  }
  */
}
