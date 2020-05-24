import { Component, OnInit, ViewChild, HostListener, Inject } from '@angular/core';
import { FormBuilder, Validators, NgForm, FormGroup, FormControl } from '@angular/forms';
import { SharedDataService } from './../../services/shared-data.service';
import { Product } from './../../models/Product';
import { CoreDataService } from './../../services/core-data.service';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { ConfirmationDialogComponent } from '../shared/confirmation-dialog/confirmation-dialog.component';
import { MatDialog, MatStepper, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';

import { ProductSummary } from './../../models/ProductSummary';
import { Observable } from 'rxjs';
import { ComponentCanDeactivate } from 'src/app/services/pending-changes-gaurd.service';
import { ESPayload } from 'src/app/models/ESPayload';
@Component({
  selector: 'app-product-details',
  templateUrl: './product-edit.component.html',
  styleUrls: ['./product-edit.component.scss']
})
export class ProductEditComponent implements OnInit, ComponentCanDeactivate {
  @ViewChild('stepper', { static: false }) private myStepper: MatStepper;
  product: Product;
  productForm: FormGroup;
  productSummary: ProductSummary = new ProductSummary();
  days: any[] = [];
  startAtForAvailable = new Date();
  startAtForEndDate = new Date((new Date()).getTime() + (1000 * 60 * 60 * 24));
  //mat tab related objs
  //selected = new FormControl(0);
  isLinear = false;
  minDate = new Date(2000, 0, 1);
  maxDate = new Date().setFullYear(new Date().getFullYear() + 1);


  message: string;
  productImages: any[] = [];


  constructor(private fb: FormBuilder,
    private sharedDataService: SharedDataService,
    private coreDataService: CoreDataService,
    private dialog: MatDialog,

    private route: ActivatedRoute,
    private router: Router,
  ) {


  }
  ngOnInit() {
    this.product = new Product();
    this.route.data
      .subscribe((data: { product: any }) => {
        if (data != undefined && data.product != undefined) {
          console.log(data);
          this.product = data.product;
          if (this.product.productID) {
            this.GetProductImages(this.product.productID);
            this.displayNextStep(true);
          }
        }
      });



    this.getSharedData();
    this.getCategories();
    this.productForm = this.fb.group({
      name: [this.product.name, Validators.compose([Validators.required, Validators.minLength(1)])],
      description: [this.product.description, Validators.required],
      categoryID: [this.product.categoryID, Validators.required],
      rentPrice: [this.product.rentPrice, Validators.required],
      minRental: [this.product.minRental, Validators.required],
      durationUnit: [this.product.durationUnit, Validators.required],
      location: [this.product.location, Validators.required],
      // city: [this.product.city, Validators.required],
      // state: [this.product.state, Validators.required],
      zipCode: [this.product.zipCode, Validators.compose([Validators.required, Validators.minLength(5), Validators.maxLength(5)])],
      pickupInstructions: [this.product.pickupInstructions],
      availableFromDate: [this.product.availableFromDate],
      availableToDate: [this.product.availableToDate],
      // costManagerID: [this.product.costManagerID],
      activeInd: [this.product.activeInd]


    });
  }



  onSubmit() {
    if (this.productForm.touched && this.productForm.dirty && this.productForm.valid) { this.confirmEdit(); }
    else {
      this.myStepper.next();
      this.displayNextStep(true);
    }
  }
  preloadImages: boolean = false;
  saveProduct() {
    if (this.productForm.valid && (!this.productForm.pristine)) {
      //update exisiting product as productID exists
      if (this.product.productID != undefined && this.product.productID > 0) {
        var obj = { ... this.product, ... this.productForm.value }

        //assign desc of category and durationUnit for later use in indexing
        this.product.categoryName = this.Categories.find(x => x.categoryID == this.product.categoryID).name;

        this.product.durationUnitDesc = this.RentUnits.find(x => x.Code == this.product.durationUnit).Description;
        console.log(obj);
        this.coreDataService.updateProduct(obj).subscribe(resp => {
          console.log(resp);
          this.product = { ...obj };
          this.updateLiveListings();
          this.product.categoryName = this.Categories.find(x => x.categoryID == this.product.categoryID).name;

          this.product.durationUnitDesc = this.RentUnits.find(x => x.Code == this.product.durationUnit).Description;
          this.displayNextStep(true);
          this.myStepper.next();
          // this.router.navigate(['']);
        },
          error => {
            console.log(error);
          });
      }
      else {


        this.coreDataService.addProduct(this.productForm.value).subscribe((resp: any) => {
          console.log(resp);

          this.product = { ...this.productForm.value }
          this.product.productID = resp.productID;
          //assign desc of category and durationUnit for later use in indexing
          this.product.categoryName = this.Categories.find(x => x.categoryID == this.product.categoryID).name;

          this.product.durationUnitDesc = this.RentUnits.find(x => x.Code == this.product.durationUnit).Description;
          this.myStepper.next();
        },
          error => {
            console.log(error);
          });
      }
    }

  }

  imageUploaded: boolean = false;
  productIsLive: boolean = false;
  displayNextStep(val) {
    this.imageUploaded = val;
    console.log(val);
    if (val) {
      this.productSummary = new ProductSummary();
      this.productSummary.productID = this.product.productID;
      this.productSummary.categoryName = this.product.category;
      this.productSummary.productName = this.product.name;
      this.productSummary.productDesc = this.product.description;
      this.productSummary.minRental = this.product.minRental;
      this.productSummary.durationUnitDesc = this.product.durationUnitDesc;
      if (this.productImages.length < 1) {
        this.GetProductImages(this.productSummary.productID);
      }
      else {
        if (this.productImages.length > 0) {
          var imgUrls = this.productImages.map(x => x.Url);

          if (imgUrls.length > 0) {
            this.productSummary.thumbnailImg = imgUrls[0];
            this.productSummary.imageUrls = imgUrls.join();
            console.log(this.productSummary);
            this.sharedDataService.productSummary$.next(this.productSummary);
          }

        }
        this.sharedDataService.productSummary$.next(this.productSummary);
      }


    }
  }

  //get product images

  GetProductImages(productID) {
    if (productID != null && productID != undefined) {
      this.coreDataService.GetProductImages(productID).subscribe((resp: any) => {
        if (resp != undefined && resp != null) {
          var images = resp.Images;
          this.productImages = images;
          console.log(images);
          this.sharedDataService.productImages$.next(images);
          if (images.length > 0) {
            var imgUrls = images.map(x => x.Url);

            if (imgUrls.length > 0) {
              this.productSummary.thumbnailImg = imgUrls[0];
              this.productSummary.imageUrls = imgUrls.join();
              this.sharedDataService.productSummary$.next(this.productSummary);
            }

          }
          else {
            this.productSummary.thumbnailImg = "./../../../assets/images/noimage.jpg";
            this.productSummary.imageUrls = "./../../../assets/images/noimage.jpg";
            this.sharedDataService.productSummary$.next(this.productSummary);
            this.myStepper.next();
          }
        }
      }, err => {
        this.sharedDataService.showError("Error occured while fetching product images...");
        this.productSummary.thumbnailImg = "./../../../assets/images/noimage.jpg";
        this.productSummary.imageUrls = "./../../../assets/images/noimage.jpg";
        this.sharedDataService.productSummary$.next(this.productSummary);
        this.myStepper.next();
      })
    }
  }



  addProductToLiveListings(val) {

    if (val) {
      if (this.productSummary.productID != null && this.productSummary.productID != undefined) {
        if (this.productSummary.imageUrls != "") {
          this.coreDataService.addProductToLiveListings({ productID: this.productSummary.productID, imageUrls: this.productSummary.imageUrls })
            .subscribe((resp: any) => {
              if (resp.productID) {

                //write to index

                this.writeProductToESIndex(this.productSummary);
                this.openDialog();

                this.productIsLive = val;
              }
            },
              err => {
                console.log(err);
                this.productIsLive = false;
                this.sharedDataService.showError("Error adding product to live listings,Please contact support...");
              }
            )
        }
      }
    }

  }
  /////update index

  updateLiveListings() {


    if (this.product.productID != null && this.product.productID != undefined) {

      var imageUrls = [];
      var urlString = '';
      if (this.productImages.length > 0) {
        imageUrls = this.productImages.map(x => x.Url);

        if (imageUrls.length > 0) {
          urlString = imageUrls.join();
        }
      }
      this.coreDataService.addProductToLiveListings({ productID: this.product.productID, imageUrls: urlString })
        .subscribe((resp: any) => {
          if (resp.productID) {
            console.log(resp.productID);
            this.writeProductToESIndex(this.productSummary);
            this.displayNextStep(true);
          }
        },
          err => {
            console.log(err);
            this.sharedDataService.showError("Error adding product to live listings,Please contact support...");
          }
        )
    }
  }

  writeProductToESIndex(prodSummary: ProductSummary) {

    var images = prodSummary.imageUrls.split(",");

    let prod: any = {};

    //elastci search write object
    prod.productID = prodSummary.productID;
    prod.name = prodSummary.productName;
    prod.description = prodSummary.productDesc;
    prod.officalUrl = "";
    prod.thumbnailUrl = images[images.length - 1];
    prod.categoryID = this.product.categoryID;
    prod.category = this.product.categoryName;
    prod.rentPrice = this.product.rentPrice;
    prod.minRental = this.product.minRental;
    prod.durationUnitDesc = prodSummary.durationUnitDesc;
    prod.durationUnit = this.product.durationUnit;
    prod.durationUnitDesc = this.product.durationUnitDesc;
    prod.location = this.product.location;
    if(this.product.location.split(",").length>0){
      prod.city=this.product.location.split(",")[0];
      prod.state=this.product.location.split(",")[1];
    }
  
    if (this.currentLoc && this.currentLoc.lat && this.currentLoc.lon) {
      this.productSummary.geo_loc.location = [this.currentLoc.lon,this.currentLoc.lat ];
    }
    else {
      var userLocation = JSON.parse(localStorage.getItem("userLocation"));
      prodSummary.geo_loc.location.push(parseFloat(userLocation.lon),parseFloat(userLocation.lat) );
    }

    prod.zipCode = this.product.zipCode;
    prod.geo_loc = prodSummary.geo_loc;
    prod.availableFromDate = this.product.availableFromDate;
    prod.availableToDate = this.product.availableToDate;    // prod.images = images;
    prod.activeInd = true;
    let payload = new ESPayload();
    payload._id = prodSummary.productID;
    payload.index_name = "products";
    payload.type = "_doc";
    payload.payload = JSON.stringify(prod)
    console.log(payload);
    this.coreDataService.writeToESIndex(payload).subscribe(resp => {
      console.log(resp);
    }, err => {
      console.log(err);
    })
  }

  goBackOneStep(val) {
    if (val) {
      this.myStepper.previous();
    }
  }

  //utility func
  numDaysBetween(d1, d2) {
    var diff = Math.abs(d1.getTime() - d2.getTime());
    return diff / (1000 * 60 * 60 * 24);
  };
  isValidDateRange(fromDate, tillDate) {
    if (!this.productForm.controls["minRental"].value) {
      this.sharedDataService.showWarning("Please fill minimum rental field before selecting dates!");
    }
    if (fromDate != undefined && tillDate != undefined && fromDate != "" && tillDate != "") {
      if (new Date(fromDate) > new Date(tillDate)) {
        this.sharedDataService.showError("End date can not be a date before start date!");
        return;
      }
      var days = this.numDaysBetween(new Date(fromDate), new Date(tillDate));
      if (days < this.product.minRental) {
        this.sharedDataService.showInfo("Please select a duration of more that minimum rental days!");
      }
      else {

      }
    }

  }
  confirmEdit() {
    if (this.product.productID) {

      const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
        data: {
          message: 'Changing Product Details, Proceed?',
          buttonText: {
            ok: 'Yes',
            cancel: 'No'
          }
        }
      });

      dialogRef.afterClosed().subscribe((confirmed: boolean) => {
        if (confirmed) {
          //[routerLink]="['/lawn-detail',element.ID]"
          this.saveProduct();
        }
      });
    }
    else {
      this.saveProduct();
    }

  }

  Categories: any[] = [];
  getCategories() {
    this.coreDataService.getCategories().subscribe((resp: any) => {
      if (resp.categories.length > 0) {
        this.Categories = resp.categories;
        // this.areas = resp.sharedData.filter(x => x.CodeType === "LAWN_SIZE");
        // this.conditions = resp.sharedData.filter(x => x.CodeType === "LAWN_CONDITION");

      }
    }, error => {

      console.log("error loading shared data,contact support!");
    });

  }
  RentUnits: any[] = [];
  getSharedData() {
    this.coreDataService.getSharedData().subscribe((resp: any) => {
      if (resp.sharedData.length > 0) {
        this.sharedDataService.sharedData$.next(resp.sharedData);
        this.RentUnits = resp.sharedData.filter(x => x.CodeType === "RENT_DAY_UNIT");
        this.productForm.controls["durationUnit"].setValue(this.RentUnits[0].Code);
        // this.areas = resp.sharedData.filter(x => x.CodeType === "LAWN_SIZE");
        // this.conditions = resp.sharedData.filter(x => x.CodeType === "LAWN_CONDITION");

      }
    }, error => {

      console.log("error loading shared data,contact support!");
    });

  }

  public currentLoc: {
    ZipCode: any
    City: string,
    State: string,
    Country: string,
    lat: Number,
    lon: Number
  };
  getZipDetails() {

    this.coreDataService.getZipAddress(this.productForm.controls["zipCode"].value).subscribe(
      (response: any) => {
        if (response) {
          console.log(response);
          this.currentLoc = response;
if(this.currentLoc){
 var locString= this.currentLoc.City+','+this.currentLoc.State;
 this.productForm.controls.location.patchValue(locString);
}

          //this.sharedDataService.zipDetails$.next({ State: this.State, City: this.City, ZipCode: this.mySignUpForm.controls.zip.value });
        }
        else {

        }

      }
      , err => { this.sharedDataService.showError("an error occured while fetching zip address!"); 
    this.productForm.controls.location.setValue("");
    })

  }


  openDialog(): void {
    const dialogRef = this.dialog.open(AddProductDialog, {

      // height: '200px',
      // width: '400px',
      data: { message: "Product is live at Leezed and is available for renting!", }
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      this.router.navigate(['home']);
      // this.animal = result;
    });
  }




  @HostListener('window:beforeunload')
  canDeactivate(): Observable<boolean> | boolean {
    // insert logic to check if there are pending changes here;
    // returning true will navigate without confirmation
    // returning false will show a confirm dialog before navigating away

    return (this.imageUploaded && this.productIsLive);

  }


  //US State list
  states: any[] =
    [
      {
        "name": "Alabama",
        "abbreviation": "AL"
      },
      {
        "name": "Alaska",
        "abbreviation": "AK"
      },
      {
        "name": "American Samoa",
        "abbreviation": "AS"
      },
      {
        "name": "Arizona",
        "abbreviation": "AZ"
      },
      {
        "name": "Arkansas",
        "abbreviation": "AR"
      },
      {
        "name": "California",
        "abbreviation": "CA"
      },
      {
        "name": "Colorado",
        "abbreviation": "CO"
      },
      {
        "name": "Connecticut",
        "abbreviation": "CT"
      },
      {
        "name": "Delaware",
        "abbreviation": "DE"
      },
      {
        "name": "District Of Columbia",
        "abbreviation": "DC"
      },
      {
        "name": "Federated States Of Micronesia",
        "abbreviation": "FM"
      },
      {
        "name": "Florida",
        "abbreviation": "FL"
      },
      {
        "name": "Georgia",
        "abbreviation": "GA"
      },
      {
        "name": "Guam",
        "abbreviation": "GU"
      },
      {
        "name": "Hawaii",
        "abbreviation": "HI"
      },
      {
        "name": "Idaho",
        "abbreviation": "ID"
      },
      {
        "name": "Illinois",
        "abbreviation": "IL"
      },
      {
        "name": "Indiana",
        "abbreviation": "IN"
      },
      {
        "name": "Iowa",
        "abbreviation": "IA"
      },
      {
        "name": "Kansas",
        "abbreviation": "KS"
      },
      {
        "name": "Kentucky",
        "abbreviation": "KY"
      },
      {
        "name": "Louisiana",
        "abbreviation": "LA"
      },
      {
        "name": "Maine",
        "abbreviation": "ME"
      },
      {
        "name": "Marshall Islands",
        "abbreviation": "MH"
      },
      {
        "name": "Maryland",
        "abbreviation": "MD"
      },
      {
        "name": "Massachusetts",
        "abbreviation": "MA"
      },
      {
        "name": "Michigan",
        "abbreviation": "MI"
      },
      {
        "name": "Minnesota",
        "abbreviation": "MN"
      },
      {
        "name": "Mississippi",
        "abbreviation": "MS"
      },
      {
        "name": "Missouri",
        "abbreviation": "MO"
      },
      {
        "name": "Montana",
        "abbreviation": "MT"
      },
      {
        "name": "Nebraska",
        "abbreviation": "NE"
      },
      {
        "name": "Nevada",
        "abbreviation": "NV"
      },
      {
        "name": "New Hampshire",
        "abbreviation": "NH"
      },
      {
        "name": "New Jersey",
        "abbreviation": "NJ"
      },
      {
        "name": "New Mexico",
        "abbreviation": "NM"
      },
      {
        "name": "New York",
        "abbreviation": "NY"
      },
      {
        "name": "North Carolina",
        "abbreviation": "NC"
      },
      {
        "name": "North Dakota",
        "abbreviation": "ND"
      },
      {
        "name": "Northern Mariana Islands",
        "abbreviation": "MP"
      },
      {
        "name": "Ohio",
        "abbreviation": "OH"
      },
      {
        "name": "Oklahoma",
        "abbreviation": "OK"
      },
      {
        "name": "Oregon",
        "abbreviation": "OR"
      },
      {
        "name": "Palau",
        "abbreviation": "PW"
      },
      {
        "name": "Pennsylvania",
        "abbreviation": "PA"
      },
      {
        "name": "Puerto Rico",
        "abbreviation": "PR"
      },
      {
        "name": "Rhode Island",
        "abbreviation": "RI"
      },
      {
        "name": "South Carolina",
        "abbreviation": "SC"
      },
      {
        "name": "South Dakota",
        "abbreviation": "SD"
      },
      {
        "name": "Tennessee",
        "abbreviation": "TN"
      },
      {
        "name": "Texas",
        "abbreviation": "TX"
      },
      {
        "name": "Utah",
        "abbreviation": "UT"
      },
      {
        "name": "Vermont",
        "abbreviation": "VT"
      },
      {
        "name": "Virgin Islands",
        "abbreviation": "VI"
      },
      {
        "name": "Virginia",
        "abbreviation": "VA"
      },
      {
        "name": "Washington",
        "abbreviation": "WA"
      },
      {
        "name": "West Virginia",
        "abbreviation": "WV"
      },
      {
        "name": "Wisconsin",
        "abbreviation": "WI"
      },
      {
        "name": "Wyoming",
        "abbreviation": "WY"
      }
    ]
}



@Component({
  selector: 'dialog-overview-example-dialog',
  template: `
<article class="media">

  <div class="media-content">
    <div class="content" style="    float: left;
    text-align: center;">
    <img src="./../../../assets/images/Success.png" style="max-width:160px" />
      <p>
        <strong>Successful!</strong>
        <br>
        Product is live at Leezed and is available for renting!
      </p>
    </div>
  
  </div>
 
</article>
`,
})
export class AddProductDialog {

  constructor(
    public dialogRef: MatDialogRef<AddProductDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }

  onNoClick(): void {
    this.dialogRef.close();
  }

}
