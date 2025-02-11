import { AppState } from "../../../redux/core.state";

export interface LoadingState {
  isLoading: boolean;
  error: boolean;
  message: string;
}

export const initialState: LoadingState = {
  isLoading: false,
  error: false,
  message: "",
};
/*
export interface State extends AppState {
  loading: LoadingState;
}*/
