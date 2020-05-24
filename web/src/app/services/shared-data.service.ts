import { Injectable, ViewContainerRef } from '@angular/core';
import { CoreDataService } from './core-data.service';
import { ToastrService } from 'ngx-toastr';

import { Subject, BehaviorSubject } from 'rxjs';
import { ProductSummary } from '../models/ProductSummary';

@Injectable({
  providedIn: 'root'
})
export class SharedDataService {

  constructor(private coreDataService: CoreDataService, public toastr: ToastrService) {
  }


  public selectedState:string;
  public selectedCity:string;
  public selectedzip:string;
  public selectedLat:Number;
  public selectedLon:Number;

  
  public zipDetails: any = { State: '', City: '', ZipCode: '', Adress1: '' };
  zipDetails$ = new BehaviorSubject<any>(this.zipDetails);

  public productImages: any[] = [];
  productImages$ = new BehaviorSubject<any>(this.productImages);

  public currentLoc: {enableCurrentLoc:boolean,zipcode:string,city:string,state:string,lat:any,lan:any} = {enableCurrentLoc:false,zipcode:"",city:"",state:"",lat:"",lan:"" };
  currentLoc$ = new BehaviorSubject<any>(this.currentLoc);


  public productSummary: ProductSummary = new ProductSummary();
  productSummary$ = new BehaviorSubject<ProductSummary>(this.productSummary);


  // public lawnSchedules: any = {};
  // lawnSchedules$ = new BehaviorSubject<any>(this.lawnSchedules);

  // public selectLawn: any;
  // selectLawn$ = new BehaviorSubject<any>(this.selectLawn);


  public sharedData: [] = [];
  sharedData$ = new BehaviorSubject<any>(this.sharedData);




  public showEmptyNavBar: boolean = true;

  errorMessage = '';
  vcr: ViewContainerRef;
  public UserInfo: any = {};




  public isLoggedIn: boolean = false;
  broadcastLoginStatus$ = new BehaviorSubject<any>(this.isLoggedIn);


  //// toaster messages
  showSuccess(message) {
    this.toastr.success(message, 'Success!');
  }

  showError(message) {
    this.toastr.error(message, 'Oops!');
  }

  showWarning(message) {
    this.toastr.warning(message, 'Alert!');
  }

  showInfo(message) {
    this.toastr.info(message);
  }

  // showCustom(template) {
  //   this.toastr.custom(template, null, { enableHTML: true });
  // }

}





