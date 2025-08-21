import { createEntityAdapter, EntityAdapter, EntityState } from "@ngrx/entity";

export const loadingAdapter: EntityAdapter<ILoading> =
  createEntityAdapter<ILoading>({
    sortComparer: sortByCreationDate,
  });

export function sortByCreationDate(a: ILoading, b: ILoading): any {
  return a.creationDate.getTime() - b.creationDate.getTime();
}

export interface LoadingState extends EntityState<ILoading> {}

export const initialState: LoadingState = loadingAdapter.getInitialState();

export interface ILoading {
  id: string; // Name of Action
  creationDate: Date;
  finishedDate: Date;
  isLoading: boolean;
  isFinished: boolean;
  hasError: boolean;
  message: string;
}
