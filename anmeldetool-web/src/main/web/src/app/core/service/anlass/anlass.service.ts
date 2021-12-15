import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError, map } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { IAnlass } from "../../model/IAnlass";
import { IAnlassLink } from "../../model/IAnlassLink";
import { IPersonAnlassLink } from "../../model/IPersonAnlassLink";
import { IUser } from "../../model/IUser";
import { IWertungsrichterEinsatz } from "../../model/IWertungsrichterEinsatz";

@Injectable({
  providedIn: "root",
})
export class AnlassService {
  private url: string = "http://localhost:8088/admin/anlaesse";

  constructor(private http: HttpClient) {}

  getAnlaesse(): Observable<IAnlass[]> {
    console.log("getAnlaesse called");
    return this.http.get<IAnlass[]>(this.url).pipe(
      map((anlaesse) => {
        return anlaesse.map((value) => {
          return Object.assign(new IAnlass(), value);
        });
      }),
      catchError(this.handleError<IAnlass[]>("getAnlaesse", []))
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
    return this.http.get<IUser>(combinedUrl).pipe(
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
      wertungsrichter.id +
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

  getVereinStart(anlass: IAnlass, verein: IVerein): Observable<boolean> {
    const combinedUrl =
      this.url + "/" + anlass?.id + "/" + "organisationen" + "/" + verein?.id;
    // console.log("getVereinStart called: ", combinedUrl);
    if (!anlass) {
      return of(false);
    }
    return this.http.get<boolean>(combinedUrl).pipe(
      catchError((error) => {
        if (error.status === 404) {
          return of(false);
        }
        this.handleError<boolean>("getVereinStart");
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
    anlass: IAnlass,
    verein: IVerein,
    started: boolean
  ): Observable<boolean> {
    const combinedUrl =
      this.url + "/" + anlass.id + "/" + "organisationen" + "/" + verein.id;
    const body = {
      anlassId: anlass.id,
      organisationsId: verein.id,
      started: started,
    };
    console.log(
      "updateVereinsStart called: ",
      combinedUrl,
      " , data: ",
      started,
      ", Body: ",
      body
    );
    return this.http
      .patch<boolean>(combinedUrl, body)
      .pipe(catchError(this.handleError<boolean>("updateVereinsStart")));
  }

  saveTeilnahme(verein: IVerein, anlassLink: IAnlassLink): Observable<boolean> {
    console.log("Service save Teilnahme: ", anlassLink);
    const combinedUrl =
      this.url +
      "/" +
      anlassLink.anlassId +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/teilnehmer/" +
      anlassLink.teilnehmerId;
    return this.http
      .patch<boolean>(combinedUrl, anlassLink)
      .pipe(catchError(this.handleError<boolean>("saveTeilnahme")));
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

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error("HandleError: ", error);
      return of(result as T);
    };
  }
}
