import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { TiTuEnum } from "../../model/TiTuEnum";
import { ServiceHelper } from "src/app/utils/service-helper";

@Injectable({
  providedIn: "root",
})
export class TeilnehmerService extends ServiceHelper {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/organisationen/";
  private _anzahlTeilnehmer = 0;
  teilnehmer: ITeilnehmer[] = [];
  // teilnahmen: IAnlassLink[] = [  {id: '1', anlassId: '1', kategorie: 'k1'}, {id: '2', anlassId: '2', kategorie: ''}, {id: '3', anlassId: '3', kategorie: ''}, {id: '4', anlassId: '4', kategorie: ''}];

  constructor(private http: HttpClient) {
    super();
  }

  getTeilnehmer(
    verein: IVerein,
    pageIndex = 0,
    pageSize = 150
  ): Observable<ITeilnehmer[]> {
    // console.log("getTeilnehmer called");
    this.updateCount(verein);
    const combinedUrl =
      this.url +
      verein.id +
      "/teilnehmer?page=" +
      pageIndex +
      "&size=" +
      pageSize;
    return this.http.get<ITeilnehmer[]>(combinedUrl).pipe(
      catchError((err, caught) => {
        return this.handleError("getTeilnehmer", err, caught);
      })
    );
  }

  reset() {
    // this.loadTeilnehmer();
  }
  get anzahlTeilnehmer() {
    return this._anzahlTeilnehmer;
  }
  updateCount(verein: IVerein) {
    const combinedUrl = this.url + verein.id + "/teilnehmer/count";
    this.http
      .get<number>(combinedUrl)
      .pipe(
        catchError((err, caught) => {
          return this.handleError("updateCount", err, caught);
        })
      )
      .subscribe((anzahl) => (this._anzahlTeilnehmer = anzahl));
  }

  add(verein: IVerein, titu: TiTuEnum): Observable<ITeilnehmer> {
    console.log("add Verein called");
    this._anzahlTeilnehmer++;
    const combinedUrl = this.url + verein.id + "/teilnehmer";
    const teilnehmer: ITeilnehmer = {
      // tiTu: titu === TiTuEnum.Ti ? "Ti" : "Tu",
      tiTu: titu,
    };
    return this.addTeilnehmer(verein, teilnehmer);
  }

  addTeilnehmer(
    verein: IVerein,
    teilnehmer: ITeilnehmer
  ): Observable<ITeilnehmer> {
    console.log("add Teilnehmer called");
    this._anzahlTeilnehmer++;
    const combinedUrl = this.url + verein.id + "/teilnehmer";
    return this.http.post<ITeilnehmer>(combinedUrl, teilnehmer).pipe(
      catchError((err, caught) => {
        return this.handleError("addTeilnehmer", err, caught);
      })
    );
  }

  delete(verein: IVerein, teilnehmer: ITeilnehmer): Observable<string> {
    // console.log("Service delete: ", teilnehmer);
    const combinedUrl = this.url + verein.id + "/teilnehmer/" + teilnehmer.id;
    return this.http.delete<string>(combinedUrl).pipe(
      catchError((err, caught) => {
        return this.handleError("delete", err, caught);
      })
    );
  }

  patch(verein: IVerein, teilnehmer: ITeilnehmer): Observable<ITeilnehmer> {
    console.log("Service save: ", teilnehmer);
    const combinedUrl = this.url + verein.id + "/teilnehmer";
    return this.http.patch<ITeilnehmer>(combinedUrl, teilnehmer).pipe(
      catchError((err, caught) => {
        return this.handleError("patch", err, caught);
      })
    );
  }
}
