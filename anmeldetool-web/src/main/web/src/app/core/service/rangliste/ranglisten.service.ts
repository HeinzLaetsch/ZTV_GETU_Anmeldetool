import { HttpClient, HttpHeaders, HttpResponse } from "@angular/common/http";
import { Injectable } from "@angular/core";
import * as FileSaver from "file-saver";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { IAnlass } from "../../model/IAnlass";
import { KategorieEnum } from "../../model/KategorieEnum";

@Injectable({
  providedIn: "root",
})
export class RanglistenService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/anlaesse";

  constructor(private http: HttpClient) {}

  getLauflistenPdf(anlass: IAnlass, kategorie: KategorieEnum): void {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten" + "/" + kategorie;
    // console.log("getTeilnehmer called: ", combinedUrl);
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "application/pdf");
    this.http
      .get(combinedUrl, {
        observe: "response",
        responseType: "blob",
        headers,
      })
      .pipe(catchError(this.handleError<any>("getLauflistenPdf")))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(result.body, parts[1], "application/pdf");
      });
  }
  private saveAsFile(buffer: any, fileName: string, fileType: string): void {
    const asArray = [buffer];
    const data: Blob = new Blob(asArray, { type: fileType });
    FileSaver.saveAs(data, fileName);
  }

  deleteLauflistenForAnlassAndKategorie(
    anlass: IAnlass,
    kategorie: KategorieEnum
  ): Observable<boolean> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten" + "/" + kategorie;
    console.log("deleteLauflistenForAnlassAndKategorie called: ", combinedUrl);
    if (!anlass) {
      return of(false);
    }
    return this.http.delete<boolean>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<boolean>("deleteLauflistenForAnlassAndKategorie");
        return of(false);
      })
    );
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
