import { Component, OnInit, Optional, Host } from '@angular/core';
import { SharedDataService } from 'src/app/services/shared-data.service';
import { SatPopover } from '@ncstate/sat-popover';
import { CoreDataService } from 'src/app/services/core-data.service';
import { LocationService } from 'src/app/services/location.service';

@Component({
  selector: 'app-location-change',
  templateUrl: './location-change.component.html',
  styleUrls: ['./location-change.component.scss']
})
export class LocationChangeComponent implements OnInit {

  public userZipCode:string="";
  constructor(@Optional() @Host() public popover: SatPopover,
  private sharedSvc:SharedDataService,
  private locationService:LocationService,
  private coreDataService:CoreDataService) { }

  ngOnInit() {
  }

  useCurrentLoc(){
    console.log("Using browser location");

    //fetch location from IP Service
   this.locationService.loction$.next({enableCurrentLoc:true,zipcode:null});
    if (this.popover) {
      this.popover.close();
    }
  }
  public currentLoc:{ZipCode: any
  City: string,
  State: string,
  Country:string,
  lat: Number,
  lon:Number};
  getZipDetails() {
  
    this.coreDataService.getZipAddress(this.userZipCode).subscribe(
      (response: any) => {
        if (response) {
          console.log(response);
          this.currentLoc=response;
          this.locationService.setLocation(this.currentLoc);
          // localStorage.setItem("userLocation",JSON.stringify({lat:this.currentLoc.lat,lon:this.currentLoc.lon,State:this.currentLoc.State,City:this.currentLoc.City,ZipCode:this.currentLoc.ZipCode}));
         //  this.sharedSvc.currentLoc$.next({useCurrentLoc:false,zipcode:this.userZipCode,city:this.currentLoc.City,state:this.currentLoc.State,lat:this.currentLoc.lat,lan:this.currentLoc.lon})
           if (this.popover) {
             this.popover.close();
           }
          //this.sharedDataService.zipDetails$.next({ State: this.State, City: this.City, ZipCode: this.mySignUpForm.controls.zip.value });
        }
        else {
     
        }

      }
      , err => { this.sharedSvc.showError("an error occured while fetching zip address!"); })
  
}

SetAsCurrentLoc(){
  if(this.currentLoc){
    localStorage.removeItem("userLocation");
    this.locationService.setLocation(this.currentLoc);
   // localStorage.setItem("userLocation",JSON.stringify({lat:this.currentLoc.lat,lon:this.currentLoc.lon,State:this.currentLoc.State,City:this.currentLoc.City,ZipCode:this.currentLoc.ZipCode}));
  //  this.sharedSvc.currentLoc$.next({useCurrentLoc:false,zipcode:this.userZipCode,city:this.currentLoc.City,state:this.currentLoc.State,lat:this.currentLoc.lat,lan:this.currentLoc.lon})
    if (this.popover) {
      this.popover.close();
    }
  }
}

CancelLocationSetup(){
  if (this.popover) {
    this.popover.close();
  }
}

}
