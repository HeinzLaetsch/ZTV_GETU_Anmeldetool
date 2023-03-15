import { AppState } from "../../../redux/core.state";

export interface LoadingState {
  isLoading: boolean;
}

export const initialState: LoadingState = {
  isLoading: false,
};

export interface State extends AppState {
  loading: LoadingState;
}
