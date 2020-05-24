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
export class LocationService {



  currentLoc: any={};

  loction$ = new BehaviorSubject<any>(this.currentLoc);
 

 
  constructor(private router: Router,
    private coreDataSvc:CoreDataService,
    @Inject(PLATFORM_ID) private platformId: any,
    // tslint:disable-next-line:align
    private coreDataService: CoreDataService,
    // tslint:disable-next-line:align
    private sharedDataService: SharedDataService) {
    // If authenticated, set local profile property and update login status subject
    if (this.currentLocation) {
      this.loction$.next(this.currentLocation);
     // this.setLoggedIn(true);
    }
  }

  getIP()  {
   this.coreDataSvc.getIP().subscribe((resp:any)=>{
console.log(resp);
// ip: "47.31.90.98"
//  city: "Delhi"
//  region: "Delhi"
//  country: "IN"
//  loc: "28.6519,77.2315"
//  postal: "110001"
this.currentLoc.City=resp.city;
this.currentLoc.State=resp.region;
this.currentLoc.ZipCode=resp.postal;
if(resp.loc){
  var location=resp.loc.split(",");
  this.currentLoc.lat=location[0];
  this.currentLoc.lon=location[1];
}
if(this.currentLoc){
  this.setLocation(this.currentLoc);
  this.loction$.next(JSON.stringify({lat:this.currentLoc.lat,lon:this.currentLoc.lon,State:this.currentLoc.State,City:this.currentLoc.City,ZipCode:this.currentLoc.ZipCode}));

}
   },err=>{
     console.log(err);
   })
    
}

  setLocation(value: any) {
    this.currentLoc=value;
    localStorage.setItem("userLocation",JSON.stringify({lat:this.currentLoc.lat,lon:this.currentLoc.lon,State:this.currentLoc.State,City:this.currentLoc.City,ZipCode:this.currentLoc.ZipCode}));
    this.loction$.next(JSON.stringify({lat:this.currentLoc.lat,lon:this.currentLoc.lon,State:this.currentLoc.State,City:this.currentLoc.City,ZipCode:this.currentLoc.ZipCode}));
  }



  public getLocation(): string {

    return localStorage.getItem('userLocation');
  }



  get currentLocation() {
    // Check if there's an unexpired access token

    return this.getLocation() ? this.getLocation() : null;
  }


}
