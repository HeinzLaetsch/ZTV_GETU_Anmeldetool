import { HttpClient, HttpHeaders, HttpResponse } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, Subject, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { ISmQuali } from "../../model/ISmQuali";
import { KategorieEnum } from "../../model/KategorieEnum";
import * as FileSaver from "file-saver";

@Injectable({
  providedIn: "root",
})
export class SmQualiService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/smquali";

  vereine = {};

  constructor(private http: HttpClient) {}

  getSmAuswertungJson(
    jahr: number,
    titu: string,
    kategorie: KategorieEnum,
    onlyQuali: boolean
  ): Observable<ISmQuali[]> {
    let combinedUrl = this.url + "/" + jahr + "/" + titu + "/" + kategorie;
    if (!onlyQuali) {
      combinedUrl += "?onlyQuali=" + onlyQuali;
    }
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "application/json");

    return this.http
      .get<ISmQuali[]>(combinedUrl, {
        headers,
      })
      .pipe(catchError(this.handleError<ISmQuali[]>("getSmAuswertung", [])));
  }

  getSmAuswertungCsv(
    jahr: number,
    titu: string,
    kategorie: KategorieEnum,
    onlyQuali: boolean
  ): Observable<string> {
    const statusResponse = new Subject<string>();
    let combinedUrl = this.url + "/" + jahr + "/" + titu + "/" + kategorie;
    if (!onlyQuali) {
      combinedUrl += "?onlyQuali=" + onlyQuali;
    }
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "text/csv;charset=UTF-8");

    this.http
      .get(combinedUrl, {
        observe: "response",
        responseType: "blob",
        headers,
      })
      .pipe(catchError(this.handleError<any>("getSmAuswertungCsv", [])))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(result.body, parts[1], "text/csv");
        statusResponse.next("Success");
      });
    return statusResponse.asObservable();
  }
  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }

  private saveAsFile(buffer: any, fileName: string, fileType: string): void {
    const asArray = [buffer];
    const data: Blob = new Blob(asArray, { type: fileType });
    FileSaver.saveAs(data, fileName);
  }
}
