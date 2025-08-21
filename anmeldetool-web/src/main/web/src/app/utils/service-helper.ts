import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";

@Injectable()
export abstract class ServiceHelper {
  handleError(
    operation = "operation",
    error: any,
    result?: any,
    emptyObject?: any
  ) {
    if (error.status === 404) {
      return of(emptyObject);
    }
    console.error(
      "Error in: ",
      operation,
      ", message: ",
      error,
      ", result: ",
      result
    );
    throw error;
    //};
  }
}
