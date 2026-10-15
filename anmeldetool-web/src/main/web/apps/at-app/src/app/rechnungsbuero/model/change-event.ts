export type ChangeEvent<TTopic extends string = string> = {
  topic: TTopic;
  status: boolean;
};
