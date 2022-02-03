import { HttpClient, HttpHeaders, HttpResponse } from "@angular/common/http";
import { Injectable } from "@angular/core";
import * as FileSaver from "file-saver";
import { Observable, of, Subject, Subscription } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { AbteilungEnum } from "../../model/AbteilungEnum";
import { AnlageEnum } from "../../model/AnlageEnum";
import { AnzeigeStatusEnum } from "../../model/AnzeigeStatusEnum";
import { IAnlass } from "../../model/IAnlass";
import { KategorieEnum } from "../../model/KategorieEnum";

@Injectable({
  providedIn: "root",
})
export class RanglistenService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/anlaesse";

  constructor(private http: HttpClient) {}

  getLauflistenPdf(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
    anlage: AnlageEnum
  ): Observable<string> {
    const statusResponse = new Subject<string>();

    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "lauflisten" +
      "/" +
      kategorie +
      "/" +
      abteilung +
      "/" +
      anlage;
    // console.log("getTeilnehmer called: ", combinedUrl);
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "application/pdf");
    this.http
      .get(combinedUrl, {
        observe: "response",
        responseType: "blob",
        headers,
      })
      .pipe(
        catchError(this.handleError<any>("getLauflistenPdf", statusResponse))
      )
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(result.body, parts[1], "application/pdf");
        statusResponse.next("Success");
      });
    return statusResponse.asObservable();
  }
  private saveAsFile(buffer: any, fileName: string, fileType: string): void {
    const asArray = [buffer];
    const data: Blob = new Blob(asArray, { type: fileType });
    FileSaver.saveAs(data, fileName);
  }

  getAbteilungenForAnlass(
    anlass: IAnlass,
    kategorie: KategorieEnum
  ): Observable<AbteilungEnum[]> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten" + "/" + kategorie;
    return this.http.get<AbteilungEnum[]>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<AbteilungEnum[]>("getAbteilungenForAnlass");
        return of(undefined);
      })
    );
  }

  getAnlagenForAnlass(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
  ): Observable<AnlageEnum[]> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten" + "/" + kategorie + "/" + abteilung;
    return this.http.get<AnlageEnum[]>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<AnlageEnum[]>("getAnlagenForAnlass");
        return of(undefined);
      })
    );
  }

  deleteLauflistenForAnlassAndKategorie(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
    anlage: AnlageEnum
  ): Observable<string> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "lauflisten" +
      "/" +
      kategorie +
      "/" +
      abteilung +
      "/" +
      anlage;
    console.log("deleteLauflistenForAnlassAndKategorie called: ", combinedUrl);
    if (!anlass) {
      return of("failed");
    }
    return this.http.delete<string>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<boolean>("deleteLauflistenForAnlassAndKategorie");
        return of("failed");
      })
    );
  }

  private handleError<T>(
    operation = "operation",
    statusResponse?: Subject<string>,
    result?: T
  ) {
    return (error: any): Observable<T> => {
      console.error(error);
      statusResponse?.next(error);
      return of(result as T);
    };
  }
}
