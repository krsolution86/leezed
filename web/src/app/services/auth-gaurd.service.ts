import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from './auth.service';
import { SharedDataService } from './shared-data.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private auth: AuthService, private router: Router, private sharedDataService: SharedDataService) { }

  canActivate() {
    if (this.auth.authenticated) {
      return true;
    } else {
      // tslint:disable-next-line:quotemark
      this.sharedDataService.showWarning("Please login to continue!");
      this.auth.setLoggedIn(false);
      this.router.navigateByUrl('');
      return false;
    }
  }
}
