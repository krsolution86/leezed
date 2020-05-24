import { Component, OnInit } from '@angular/core';
import { CoreDataService } from './../../services/core-data.service';
import { Product } from './../../models/Product';


import { FormControl } from '@angular/forms';
import { Observable, of } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { SharedDataService } from 'src/app/services/shared-data.service';
import { LocationService } from 'src/app/services/location.service';
export interface State {
  flag: string;
  name: string;
  population: string;
}

// import Product from './../product/product.component';
@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss']
})
export class ProductListComponent implements OnInit {
  public productList: Product[] = [];
  searchTerm = '';
  geolocationPosition: Position;
  position: any;

  public currentLoc: {
    ZipCode: any
    City: string,
    State: string,
    Country: string,
    lat: Number,
    lon: Number
  } = {
    ZipCode: "",
      City: "",
      State: "",
      Country: "",
      lat: null,
      lon: null
    };
  constructor(private coreDataService: CoreDataService, private sharedSvc: SharedDataService,private locationService:LocationService) {

  }
public nearText:string="";
  ngOnInit() {
    this.locationService.loction$.subscribe(resp=>{
      if(resp){
         if (resp.enableCurrentLoc ) {
    this.locationService.getIP();
      }
      else{
        if(Object.keys(resp).length>0){
          this.currentLoc=JSON.parse(resp);
          this.getProductList({lat:this.currentLoc.lat,lan:this.currentLoc.lon});
        }
      
      }
       
      }
    })

    // this.sharedSvc.currentLoc$.subscribe(resp => {
    //   if (resp.enableCurrentLoc && resp.zipcode == null) {
    //     this.UseCurrentLoc();
    //   }
    //   else if (resp.zipcode && (!resp.enableCurrentLoc)) {
    //     this.currentLoc.City = resp.city;
    //     this.currentLoc.State = resp.state;
    //     this.currentLoc.ZipCode = resp.zipCode;
    //     this.currentLoc.lat = resp.lat;
    //     this.currentLoc.lon = resp.lan;
    //     console.log(this.currentLoc);
    //     this.getProductList({lat:this.currentLoc.lat,lan:this.currentLoc.lon});
    //     //fetch zipcode lat lang and set that loc for current user session
    //   }
    //   else {
    //     const userLocation=JSON.parse(localStorage.getItem("userLocation"));
    //     if(userLocation){
    //       this.currentLoc.lat = userLocation.lat;
    //     this.currentLoc.lon = userLocation.lan;
    //     this.getProductList({lat:this.currentLoc.lat,lan:this.currentLoc.lon});
    //     }
    //        }
    // });

//     var userLocation = JSON.parse(localStorage.getItem('userLocation'));
//     if (userLocation) {
//       this.position={coords:{}};
//       this.position.coords.longitude=parseFloat(userLocation.lan);
//       this.position.coords.latitude=parseFloat(userLocation.lat);
// this.getProductList(userLocation);

//     }

  }

  getProductList(userLocation){
    
    this.coreDataService.GetProductList("", parseFloat(userLocation.lan), parseFloat(userLocation.lat)).subscribe((response: any) => {
      if (response) {
        console.log(response);
        this.productList = response.products;
        this.products = this.productList;


        this.filteredProducts = this.stateCtrl.valueChanges
          .pipe(
            startWith(''),
            map(state => state ? this._filterProducts(state) : this.products.slice())
          );
        console.log(this.filteredProducts);
      }
    }, err => {
      console.log(err);
    });
  }


  stateCtrl = new FormControl();
  filteredProducts: Observable<Product[]>;
  products: Product[] = [];
  private _filterProducts(value: string): Product[] {
    const filterValue = value.toLowerCase();

    return this.products.filter(state => state.name.toLowerCase().indexOf(filterValue) >= 0);
  }

  UseCurrentLoc() {
    if (window.navigator && window.navigator.geolocation) {
      window.navigator.geolocation.getCurrentPosition(
        position => {
          this.geolocationPosition = position,
            console.log(position);
          this.position = position;
          localStorage.setItem("userLocation", JSON.stringify({ lat: this.position.coords.latitude, lan: this.position.coords.longitude }));
          this.getProductList({ lat: this.position.coords.latitude, lan: this.position.coords.longitude });
        },
        error => {
          switch (error.code) {
            case 1:
              console.log('Permission Denied');
              break;
            case 2:
              console.log('Position Unavailable');
              break;
            case 3:
              console.log('Timeout');
              break;
          }
        }
      );
    };

  }

  zipCode: string;

  getZipDetails() {

    this.coreDataService.getZipAddress(this.zipCode).subscribe(
      (response: any) => {
        if (!response.message) {


          //this.sharedDataService.zipDetails$.next({ State: this.State, City: this.City, ZipCode: this.mySignUpForm.controls.zip.value });
        }
        else {
          // this.message = response.message;
        }

      }
      , err => { this.sharedSvc.showError("an error occured while fetching zip address!"); })

  }

}
