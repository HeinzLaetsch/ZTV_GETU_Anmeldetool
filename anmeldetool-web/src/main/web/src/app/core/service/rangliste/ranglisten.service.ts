import { HttpClient, HttpHeaders, HttpResponse } from "@angular/common/http";
import { Injectable } from "@angular/core";
import * as FileSaver from "file-saver";
import { Observable, of, Subject } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { AbteilungEnum } from "../../model/AbteilungEnum";
import { AnlageEnum } from "../../model/AnlageEnum";
import { IAnlass } from "../../model/IAnlass";
import { ILaufliste } from "../../model/ILaufliste";
import { ILauflistenEintrag } from "../../model/ILauflistenEintrag";
import { IRanglistenConfiguration } from "../../model/IRanglistenConfiguration";
import { IRanglistenEntry } from "../../model/IRanglistenEntry";
import { KategorieEnum } from "../../model/KategorieEnum";

@Injectable({
  providedIn: "root",
})
export class RanglistenService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/anlaesse";

  constructor(private http: HttpClient) {}

  getRanglisteConfiguration(
    anlass: IAnlass,
    tiTu: string,
    kategorie: KategorieEnum
  ): Observable<IRanglistenConfiguration> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "ranglisten" +
      "/" +
      tiTu +
      "/" +
      kategorie +
      "/config";
    return this.http
      .get<IRanglistenConfiguration>(combinedUrl)
      .pipe(catchError(this.handleError<any>("getRanglisteConfiguration")));
  }

  getRangliste(
    anlass: IAnlass,
    tiTu: string,
    kategorie: KategorieEnum,
    maxAuszeichnungen: number
  ): Observable<IRanglistenEntry[]> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "ranglisten" +
      "/" +
      tiTu +
      "/" +
      kategorie +
      "?maxAuszeichnungen=" +
      maxAuszeichnungen;
    return this.http
      .get<IRanglistenEntry[]>(combinedUrl)
      .pipe(catchError(this.handleError<any>("getRangliste")));
  }

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

  getLauflisten(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
    anlage: AnlageEnum
  ): Observable<ILaufliste[]> {
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
    // Accept JSON let headers: HttpHeaders = new HttpHeaders();
    // headers = headers.append("Accept", "application/pdf");
    return this.http.get<ILaufliste[]>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<ILaufliste[]>("getLauflisten");
        return of(undefined);
      })
    );
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
    abteilung: AbteilungEnum
  ): Observable<AnlageEnum[]> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "lauflisten" +
      "/" +
      kategorie +
      "/" +
      abteilung;
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

  searchLauflisteByKey(
    anlass: IAnlass,
    search: string
  ): Observable<ILaufliste> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten?search=" + search;
    return this.http.get<ILaufliste>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<ILaufliste>("searchLauflisteByKey");
        return of(undefined);
      })
    );
  }
  updateLauflistenEintrag(
    anlass: IAnlass,
    eintrag: ILauflistenEintrag
  ): Observable<ILauflistenEintrag> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "lauflisten/" +
      eintrag.laufliste_id +
      "/lauflisteneintraege/" +
      eintrag.id;
    return this.http.put<ILauflistenEintrag>(combinedUrl, eintrag).pipe(
      catchError((error) => {
        this.handleError<ILauflistenEintrag>("updateLauflistenEintrag");
        return of(undefined);
      })
    );
  }

  updateLaufliste(
    anlass: IAnlass,
    laufliste: ILaufliste
  ): Observable<ILaufliste> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "lauflisten/" + laufliste.id;
    return this.http.put<ILaufliste>(combinedUrl, laufliste).pipe(
      catchError((error) => {
        this.handleError<ILaufliste>("updateLaufliste");
        return of(undefined);
      })
    );
  }

  public deleteNotenblatt(
    anlass: IAnlass,
    eintrag: ILauflistenEintrag,
    grund: string
  ): Observable<boolean> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "lauflisten/" +
      eintrag.laufliste_id +
      "/lauflisteneintraege/" +
      eintrag.id +
      "?grund=" +
      grund;
    return this.http.delete<boolean>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<boolean>("deleteNotenblatt");
        return of(false);
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
      9;
      statusResponse?.next(error);
      return of(result as T);
    };
  }
}
