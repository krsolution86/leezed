import { Injectable, PLATFORM_ID, Inject } from '@angular/core';
import { Router } from '@angular/router';
import { JwtHelperService } from '@auth0/angular-jwt';
import { BehaviorSubject } from 'rxjs';
import { CoreDataService } from './core-data.service';
import { SharedDataService } from './shared-data.service';
import { isPlatformBrowser } from '@angular/common';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  currentUser: any;
  public loggedIn: boolean;
  loggedIn$ = new BehaviorSubject<boolean>(this.loggedIn);
  public user: any = {};
  user$ = new BehaviorSubject<any>(this.user);

  helper = new JwtHelperService();
  constructor(private router: Router,
    @Inject(PLATFORM_ID) private platformId: any,
    // tslint:disable-next-line:align
    private coreDataService: CoreDataService,
    // tslint:disable-next-line:align
    private sharedDataService: SharedDataService) {
    // If authenticated, set local profile property and update login status subject
    if (this.authenticated) {
      this.setLoggedIn(true);
    }
  }

  setLoggedIn(value: boolean) {
    this.user$.next(this.getUser);
    // Update login status subject
    this.loggedIn$.next(value);
    this.loggedIn = value;
  }


  public _setSession(authResult, loggedInDefaultUrl: string = "") {
    // Save session data and update login status subject
    localStorage.setItem('token', authResult.authToken);
    //this.useJwtHelper(authResult.authToken);
    this.setLoggedIn(true);
    //navigate to provided default page
    this.router.navigate([loggedInDefaultUrl]);
  }

  public getToken(): string {

    return localStorage.getItem('token');
  }



  useJwtHelper(myRawToken) {
    const decodedToken = this.helper.decodeToken(myRawToken);
    // Other functions
    const expirationDate = this.helper.getTokenExpirationDate(myRawToken);
    const isExpired = this.helper.isTokenExpired(myRawToken);
    // console.log(decodedToken);
    // console.log(expirationDate);
  }

  logout() {
    // Remove tokens and profile and update login status subject
    localStorage.removeItem("token");
    this.loggedIn$.next(false);
    this.router.navigate(['']);
  }

  get authenticated() {
    // Check if there's an unexpired access token

    return this.getToken() ? (!this.helper.isTokenExpired(this.getToken())) : false;
  }

  get getUser() {
    // Check if there's an unexpired access token


    const user = this.getToken() ? (this.helper.decodeToken(this.getToken()).sub) : {};
    // console.log(user);
    return user;
  }
}
