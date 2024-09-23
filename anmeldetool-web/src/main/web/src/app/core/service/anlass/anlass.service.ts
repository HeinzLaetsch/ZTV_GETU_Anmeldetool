import { HttpClient, HttpHeaders, HttpResponse } from "@angular/common/http";
import { Injectable } from "@angular/core";
import * as FileSaver from "file-saver";
import { Observable, of, Subject } from "rxjs";
import { catchError, map } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { AbteilungEnum } from "../../model/AbteilungEnum";
import { AnlageEnum } from "../../model/AnlageEnum";
import { GeraeteEnum } from "../../model/GeraeteEnum";
import { IAnlass } from "../../model/IAnlass";
import { IAnlassLink } from "../../model/IAnlassLink";
import { IAnlassSummary } from "../../model/IAnlassSummary";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";
import { IPersonAnlassLink } from "../../model/IPersonAnlassLink";
import { ITeilnahmeStatistic } from "../../model/ITeilnahmeStatistic";
import { ITeilnehmerStart } from "../../model/ITeilnehmerStart";
import { IUser } from "../../model/IUser";
import { IWertungsrichterEinsatz } from "../../model/IWertungsrichterEinsatz";
import { KategorieEnum } from "../../model/KategorieEnum";
import { ITeilnahmen } from "../../model/ITeilnahmen";
import { IOrganisationTeilnahmenStatistik } from "../../model/IOrganisationTeilnahmenStatistik";

@Injectable({
  providedIn: "root",
})
export class AnlassService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/anlaesse";

  private url2: string = this.apiHost + "/admin/teilnahmen";

  constructor(private http: HttpClient) {}

  getAnlaesse(onlyAktiv: boolean): Observable<IAnlass[]> {
    console.log("getAnlaesse called: " + this.apiHost);
    let finalUrl = this.url;
    if (!onlyAktiv) {
      finalUrl = finalUrl + "?onlyAktiv=" + onlyAktiv;
    }

    return this.http.get<IAnlass[]>(finalUrl).pipe(
      map((anlaesse) => {
        return anlaesse.map((value) => {
          // Check wieso Copy
          // const tmp: IAnlass = Object.assign(new IAnlass(), value);
          const tmp: IAnlass = new IAnlass(value);
          return tmp;
        });
      }),
      catchError(this.handleError<IAnlass[]>("getAnlaesse", []))
    );
  }

  getAnlassOrganisationSummary(
    anlass: IAnlass,
    verein: IVerein
  ): Observable<IAnlassSummary> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/summary";
    if (!anlass) {
      return of(undefined);
    }
    return this.http.get<IAnlassSummary>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(undefined);
        }
        this.handleError<IAnlassSummary>("getAnlassOrganisationSummary");
      })
    );
  }

  getVerfuegbareWertungsrichter(
    anlass: IAnlass,
    verein: IVerein,
    brevet: number
  ): Observable<IUser[]> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      brevet +
      "/" +
      "verfuegbar";
    // console.log("getVerfuegbareWertungsrichter called: ", combinedUrl);
    if (!anlass) {
      return of(undefined);
    }
    return this.http.get<IUser[]>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(undefined);
        }
        this.handleError<boolean>("getVerfuegbareWertungsrichter");
      })
    );
  }

  getEingeteilteWertungsrichter(
    anlass: IAnlass,
    verein: IVerein,
    brevet: number
  ): Observable<IPersonAnlassLink[]> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      brevet +
      "/" +
      "eingeteilt";
    // console.log("getEingeteilteWertungsrichter called: ", combinedUrl);
    if (!anlass) {
      return of(undefined);
    }
    return this.http.get<IPersonAnlassLink[]>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(undefined);
        }
        this.handleError<boolean>("getEingeteilteWertungsrichter");
      })
    );
  }

  getWrEinsatz(
    anlass: IAnlass,
    verein: IVerein,
    wertungsrichter: IUser
  ): Observable<IPersonAnlassLink> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      wertungsrichter?.id +
      "/" +
      "einsaetze";

    if (!anlass) {
      return of(undefined);
    }
    return this.http.get<IPersonAnlassLink>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(undefined);
        }
        this.handleError<IPersonAnlassLink>("getWrEinsatz");
      })
    );
  }

  updateWrEinsatz(
    verein: IVerein,
    anlassLink: IPersonAnlassLink,
    einsatz: IWertungsrichterEinsatz
  ): Observable<IWertungsrichterEinsatz> {
    const combinedUrl =
      this.url +
      "/" +
      anlassLink?.anlassId +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      anlassLink?.personId +
      "/" +
      "einsaetze";

    return this.http.post<IWertungsrichterEinsatz>(combinedUrl, einsatz).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(undefined);
        }
        this.handleError<IWertungsrichterEinsatz>("getWrEinsatz");
      })
    );
  }

  addWertungsrichterToAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IPersonAnlassLink> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      user?.id;
    // console.log("addWertungsrichterToAnlass called: ", combinedUrl);
    if (!anlass) {
      return of(undefined);
    }
    return this.http.post<IPersonAnlassLink>(combinedUrl, {}).pipe(
      catchError((error) => {
        this.handleError<boolean>("addWertungsrichterToAnlass");
        return of(undefined);
      })
    );
  }

  updateAnlassLink(
    pal: IPersonAnlassLink,
    verein: IVerein
  ): Observable<IPersonAnlassLink> {
    const combinedUrl =
      this.url +
      "/" +
      pal.anlassId +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/" +
      "wertungsrichter" +
      "/" +
      pal.personId;
    return this.http.post<IPersonAnlassLink>(combinedUrl, pal).pipe(
      catchError((error) => {
        this.handleError<boolean>("updateAnlassLink");
        return of(undefined);
      })
    );
  }

  deleteWertungsrichterFromAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IPersonAnlassLink> {
    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/" +
      "wertungsrichter" +
      "/" +
      user?.id;
    console.log("deleteWertungsrichterFromAnlass called: ", combinedUrl);
    if (!anlass) {
      return of(undefined);
    }
    return this.http.delete<IPersonAnlassLink>(combinedUrl).pipe(
      catchError((error) => {
        this.handleError<boolean>("deleteWertungsrichterFromAnlass");
        return of(undefined);
      })
    );
  }

  getVereinStart(
    anlass: IAnlass,
    verein: IVerein
  ): Observable<IOrganisationAnlassLink> {
    const empty = {
      anlassId: anlass?.id,
      organisationsId: verein?.id,
      startet: false,
      verlaengerungsDate: undefined,
    };
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "organisationen" + "/" + verein?.id;
    if (!anlass) {
      return of(empty);
    }
    return this.http.get<IOrganisationAnlassLink>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(empty);
        }
        this.handleError<IOrganisationAnlassLink>("getVereinStart");
      })
    );
  }

  getVereinsStarts(anlass: IAnlass): Observable<IVerein[]> {
    const combinedUrl = this.url + "/" + anlass.id + "/" + "organisationen";
    console.log("getVereinsStarts called");
    return this.http
      .get<IVerein[]>(combinedUrl)
      .pipe(catchError(this.handleError<IVerein[]>("getVereinsStarts", [])));
  }

  updateVereinsStart(
    orgAnlassLink: IOrganisationAnlassLink
  ): Observable<IOrganisationAnlassLink> {
    const combinedUrl =
      this.url +
      "/" +
      orgAnlassLink.anlassId +
      "/" +
      "organisationen" +
      "/" +
      orgAnlassLink.organisationsId;
    console.log(
      "updateVereinsStart called: ",
      combinedUrl,
      ", Body: ",
      orgAnlassLink
    );
    return this.http
      .patch<IOrganisationAnlassLink>(combinedUrl, orgAnlassLink)
      .pipe(
        catchError(
          this.handleError<IOrganisationAnlassLink>("updateVereinsStart")
        )
      );
  }

  updateAnlass(anlass: IAnlass): Observable<IAnlass> {
    const combinedUrl = this.url + "/" + anlass.id;
    return this.http
      .put<IAnlass>(combinedUrl, anlass)
      .pipe(catchError(this.handleError<IAnlass>("updateAnlass")));
  }

  // updateTeilnahme
  //saveTeilnahme(verein: IVerein, anlassLink: IAnlassLink): Observable<boolean> {
  saveTeilnahme(
    verein: IVerein,
    teilnahmen: ITeilnahmen
  ): Observable<ITeilnahmen> {
    console.log("Service save Teilnahme: ", teilnahmen);

    const combinedUrl =
      this.url2 +
      "/" +
      teilnahmen.jahr +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/teilnahmen/" +
      teilnahmen.teilnehmer.id;

    return this.http
      .put<ITeilnahmen>(combinedUrl, teilnahmen)
      .pipe(catchError(this.handleError<ITeilnahmen>("saveTeilnahme")));
  }

  // /anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/
  getTeilnehmer(anlass: IAnlass, verein: IVerein): Observable<IAnlassLink[]> {
    const combinedUrl =
      this.url +
      "/" +
      anlass.id +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/teilnehmer/";
    // console.log("getTeilnehmer called: ", combinedUrl);
    return this.http
      .get<IAnlassLink[]>(combinedUrl)
      .pipe(catchError(this.handleError<IAnlassLink[]>("getTeilnehmer", [])));
  }

  // "/{jahr}/organisationen/{orgId}/teilnahmen/";
  getTeilnahmen(verein: IVerein, jahr: number): Observable<ITeilnahmen[]> {
    const combinedUrl =
      this.url2 +
      "/" +
      jahr +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/teilnahmen/";
    // console.log("getTeilnehmer called: ", combinedUrl);
    return this.http
      .get<ITeilnahmen[]>(combinedUrl)
      .pipe(
        catchError(this.handleError<ITeilnahmen[]>("getTeilnahmen", undefined))
      );
  }

  getOrganisationTeilnahmenStatistik(
    verein: IVerein,
    jahr: number
  ): Observable<IOrganisationTeilnahmenStatistik[]> {
    const combinedUrl =
      this.url2 + "/" + jahr + "/" + "organisationen" + "/" + verein.id;
    return this.http
      .get<IOrganisationTeilnahmenStatistik[]>(combinedUrl)
      .pipe(
        catchError(
          this.handleError<IOrganisationTeilnahmenStatistik[]>(
            "getOrganisationTeilnahmenStatistik",
            undefined
          )
        )
      );
  }

  /*
  updateTeilnahme(anlassLink: IAnlassLink): Observable<IAnlassLink> {
    const combinedUrl =
      this.url + "/" + anlassLink.anlassId + "/" + anlassLink.teilnehmerId;
    return this.http.post<IAnlassLink>(combinedUrl, anlassLink).pipe(
      catchError((error) => {
        this.handleError<boolean>("updateTeilnahme");
        return of(undefined);
      })
    );
  }*/

  updateTeilnehmerStart(
    anlass: IAnlass,
    teilnehmerStart: ITeilnehmerStart
  ): Observable<boolean> {
    let combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/";
    return this.http
      .put<boolean>(combinedUrl, teilnehmerStart)
      .pipe(catchError(this.handleError<boolean>("updateStartgeraet")));
  }

  getByStartgeraet(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
    anlage: AnlageEnum,
    geraet: GeraeteEnum,
    search: string
  ): Observable<ITeilnehmerStart[]> {
    let combinedUrl =
      this.url +
      "/" +
      anlass.id +
      "/teilnehmer/" +
      kategorie +
      "/" +
      abteilung +
      "/" +
      anlage +
      "/" +
      geraet?.toLocaleUpperCase();
    if (search) {
      combinedUrl += "?search=" + search;
    }

    return this.http
      .get<ITeilnehmerStart[]>(combinedUrl)
      .pipe(
        catchError(this.handleError<ITeilnehmerStart[]>("getByStartgeraet"))
      );
  }

  getTeilnahmeStatistic(
    anlass: IAnlass,
    kategorie: KategorieEnum,
    abteilung: AbteilungEnum,
    anlage: AnlageEnum,
    geraet: GeraeteEnum,
    search: string
  ): Observable<ITeilnahmeStatistic> {
    let combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/statistic";
    if (kategorie) {
      combinedUrl = combinedUrl + "/" + kategorie;
      if (abteilung) {
        combinedUrl = combinedUrl + "/" + abteilung;
        if (anlage) {
          combinedUrl = combinedUrl + "/" + anlage;
          if (geraet) {
            combinedUrl = combinedUrl + "/" + geraet?.toLocaleUpperCase();
          }
        }
      }
    }
    if (search) {
      combinedUrl += "?search=" + search;
    }
    // console.log("getTeilnehmer called: ", combinedUrl);
    return this.http
      .get<ITeilnahmeStatistic>(combinedUrl)
      .pipe(
        catchError(
          this.handleError<ITeilnahmeStatistic>("getTeilnahmeStatistic")
        )
      );
  }

  // /anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/
  getTeilnehmerForAnlassCsv(anlass: IAnlass): void {
    const combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/";
    // console.log("getTeilnehmer called: ", combinedUrl);
    this.http
      .get(combinedUrl, { observe: "response", responseType: "text" })
      .pipe(catchError(this.handleError<string>("getTeilnehmerForAnlass")))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(
          result.body,
          parts[1].replace("%", ""),
          "text/csv; charset=UTF-8"
        );
      });
  }

  getMutationenForAnlassCsv(anlass: IAnlass): void {
    const combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/mutationen";
    // console.log("getTeilnehmer called: ", combinedUrl);
    this.http
      .get(combinedUrl, { observe: "response", responseType: "text" })
      .pipe(catchError(this.handleError<string>("getMutationenForAnlassCsv")))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(
          result.body,
          parts[1].replace("%", ""),
          "text/csv; charset=UTF-8"
        );
      });
  }

  getBenutzerForAnlassCsv(anlass: IAnlass): void {
    const combinedUrl = this.url + "/" + anlass.id + "/benutzer/";
    // console.log("getTeilnehmer called: ", combinedUrl);
    this.http
      .get(combinedUrl, { observe: "response", responseType: "text" })
      .pipe(catchError(this.handleError<string>("getBenutzerForAnlassCsv")))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(
          result.body,
          parts[1].replace("%", ""),
          "text/csv; charset=UTF-8"
        );
      });
  }

  getWertungsrichterForAnlassCsv(anlass: IAnlass): void {
    const combinedUrl = this.url + "/" + anlass.id + "/wertungsrichter/";
    // console.log("getTeilnehmer called: ", combinedUrl);
    this.http
      .get(combinedUrl, { observe: "response", responseType: "text" })
      .pipe(
        catchError(this.handleError<string>("getWertungsrichterForAnlassCsv"))
      )
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(
          result.body,
          parts[1].replace("%", ""),
          "text/csv; charset=UTF-8"
        );
      });
  }

  public importTeilnehmerForAnlassCsv(
    anlass: IAnlass,
    formData: FormData
  ): Observable<any> {
    const combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/";
    return this.http.post<any>(combinedUrl, formData);
  }

  public importContestTeilnehmerForAnlassCsv(
    anlass: IAnlass,
    formData: FormData
  ): Observable<any> {
    const combinedUrl = this.url + "/" + anlass.id + "/teilnehmer/contest";
    console.log("importContestTeilnehmerForAnlassCsv called: ", combinedUrl);
    return this.http.post<any>(combinedUrl, formData);
  }

  getAnmeldeKontrolleCsv(anlass: IAnlass): void {
    const combinedUrl = this.url + "/" + anlass.id;
    this.http
      .get(combinedUrl, { observe: "response", responseType: "text" })
      .pipe(catchError(this.handleError<string>("getAnmeldeKontrolleCsv")))
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(
          result.body,
          parts[1].replace("%", ""),
          "text/csv; charset=UTF-8"
        );
      });
  }

  getVereinAnmeldeKontrollePdf(
    anlass: IAnlass,
    verein: IVerein
  ): Observable<string> {
    const statusResponse = new Subject<string>();

    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/anmeldekontrolle/";

    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "application/pdf");
    this.http
      .get(combinedUrl, {
        observe: "response",
        responseType: "blob",
        headers,
      })
      .pipe(
        catchError(
          this.handleError<any>("getVereinAnmeldeKontrollePdf", statusResponse)
        )
      )
      .subscribe((result: HttpResponse<string>) => {
        const header = result.headers.get("Content-Disposition");
        const parts = header.split("filename=");
        this.saveAsFile(result.body, parts[1], "application/pdf");
        statusResponse.next("Success");
      });
    return statusResponse.asObservable();
  }

  getVereinWertungsrichterKontrollePdf(
    anlass: IAnlass,
    verein: IVerein
  ): Observable<string> {
    const statusResponse = new Subject<string>();

    const combinedUrl =
      this.url +
      "/" +
      anlass?.id +
      "/" +
      "organisationen" +
      "/" +
      verein?.id +
      "/wertungsrichterkontrolle/";

    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append("Accept", "application/pdf");
    this.http
      .get(combinedUrl, {
        observe: "response",
        responseType: "blob",
        headers,
      })
      .pipe(
        catchError(
          this.handleError<any>(
            "getVereinWertungsrichterKontrollePdf",
            statusResponse
          )
        )
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
  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error("HandleError: ", operation, " , Error: ", error);
      return of(result as T);
    };
  }
}
