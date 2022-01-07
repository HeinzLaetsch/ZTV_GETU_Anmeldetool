export interface IChangeEvent {
  tabIndex: number;
  rolesChanged: boolean;
  userHasChanged: boolean;
  userValid: boolean;
  wrChanged: boolean;
  hasWr: boolean;
  canceled: boolean;
  saved: boolean;
}
