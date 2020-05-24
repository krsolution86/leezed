import { Component, OnInit, QueryList, ViewChildren } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CoreDataService } from 'src/app/services/core-data.service';
import { SharedDataService } from 'src/app/services/shared-data.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Product } from 'src/app/models/Product';
import { Order } from 'src/app/models/Order';
import { AuthService } from 'src/app/services/auth.service';
import { StarRatingComponent } from 'ng-starrating';
import { MatDialog, ThemePalette } from '@angular/material';
import { ConfirmationDialogComponent } from '../shared/confirmation-dialog/confirmation-dialog.component';
import { MatCarousel, MatCarouselComponent, Orientation, MatCarouselSlideComponent } from '@ngmodule/material-carousel';

@Component({
  selector: 'app-rent-product',
  templateUrl: './rent-product.component.html',
  styleUrls: ['./rent-product.component.scss']
})
export class RentProductComponent implements OnInit {

  public slidesList = new Array<never>(5);
  public showContent = false;

  public timings = '250ms ease-in';
  public autoplay = true;
  public interval = 5000;
  public loop = true;
  public hideArrows = false;
  public hideIndicators = false;
  public color: ThemePalette = 'accent';
  public maxWidth = 'auto';
  public proportion = 25;
  public slides = this.slidesList.length;
  public overlayColor = '#00000040';
  public hideOverlay = false;
  public useKeyboard = true;
  public useMouseWheel = false;
  public orientation: Orientation = 'ltr';
  public log: string[] = [];

  @ViewChildren(MatCarouselSlideComponent) public carouselSlides: QueryList<
    MatCarouselSlideComponent
  >;
  public darkMode = false;
  public user: any;
  public onChange(index: number) {
    this.log.push(`MatCarousel#change emitted with index ${index}`);
  }





  ////end  of carasoul
  product: any;
  isLoggedIn: boolean = false;

  rentForm: FormGroup;
  rentNow: boolean = false;
  days: any[] = [];
  totalCost = 0;
  minDate = new Date(2000, 0, 1);
  maxDate = new Date().setFullYear(new Date().getFullYear() + 1);
  constructor(private fb: FormBuilder,
    private authSvc: AuthService,
    private sharedDataService: SharedDataService,
    private coreDataService: CoreDataService,
    public dialog: MatDialog,
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
          this.minDate = this.product.availableFromDate;
          this.maxDate = this.product.availableToDate;
          this.GetProductImages(this.product.productID);
        }
      });
      this.authSvc.user$.subscribe(resp => {
        if (resp) {
          this.user = resp;
        }
      })

    this.authSvc.loggedIn$.subscribe(resp => {
      if (resp) {
        this.isLoggedIn = resp;
      }
    })

    this.rentForm = this.fb.group({

      rentPrice: [this.product.rentPrice, Validators.required],
      minRental: [this.product.minRental, Validators.required],
      durationUnit: [this.product.durationUnit, Validators.required],
      availableFromDate: [this.product.availableFromDate],
      availableToDate: [this.product.availableToDate]
    });
  }


  goToLogin(){
    this.router.navigate(['auth', 'signin']);
  }
  rentProduct() {
    if (!this.isLoggedIn) {
      this.sharedDataService.showWarning("Please login to rent product!");
      this.router.navigate(['auth', 'signin']);
      return;
    }
    let order: Order = new Order();
    order.productID = this.product.productID;
    order.rentalStartDate = this.rentFrom;
    order.rentalEndDate = this.rentTill;
    order.rentPrice = this.totalCost;
    order.rentUnit = this.product.durationUnit;
    order.rentUnitCount = Number(this.totalCost/parseFloat(this.product.rentPrice));
    order.unitCost = this.product.rentPrice;

    if (order.productID != undefined && order.productID > 0) {
      this.coreDataService.placeRentRequest(order).subscribe((resp: any) => {
        console.log(resp);
        if (resp.orderID != null && resp.orderID != undefined) {
          this.openDialog();
        //  this.sharedDataService.showSuccess("Order placed successfully! Order ID:" + resp.orderID);
        }
        else {
          this.sharedDataService.showSuccess("Order not placed, please contact support!");
        }

      },

        err => {
          console.log(err);
          this.sharedDataService.showError("An error occurred placing new order!please contact support.")
        })
    }
  }

  //utility func
  numDaysBetween(d1, d2) {
    var diff = Math.abs(d1.getTime() - d2.getTime());
    return diff / (1000 * 60 * 60 * 24);
  };
  public rentFrom:Date;
  public rentTill:Date;
  calculateRent(fromDate, tillDate) {

    if (fromDate != undefined && tillDate != undefined && fromDate != "" && tillDate != "") {
      if (new Date(fromDate) > new Date(tillDate)) {
        this.sharedDataService.showError("End date can not be a date before start date!");
        return;
      }
      var days = this.numDaysBetween(new Date(fromDate), new Date(tillDate))+1;
      console.log(days);
      if (days < this.product.minRental) {
        this.sharedDataService.showInfo("Please select a duration of more that minimum " + this.product.minRental + " " + this.product.durationUnit);
      }
      else {
        this.totalCost = days * this.product.rentPrice;
        this.rentFrom=new Date(fromDate);
        this.rentTill=new Date(tillDate);
      }
    }

  }

  onRate($event: { oldValue: number, newValue: number, starRating: StarRatingComponent }) {
    alert(`Old Value:${$event.oldValue}, 
    New Value: ${$event.newValue}, 
    Checked Color: ${$event.starRating.checkedcolor}, 
    Unchecked Color: ${$event.starRating.uncheckedcolor}`);
  }

  onSubmit() {
    alert("Hello");
  }


  RentUnits: any[] = [];



  GetProductImages(productID) {
    if (productID != null && productID != undefined) {
      this.coreDataService.GetProductImages(productID).subscribe((resp: any) => {
        if (resp != undefined && resp != null) {
          var images = resp.Images.map(x=>x.Url);
          if (images.length > 0) {
            this.product.images=images;
            this.product.thumbnailUrl = images[0];
          }
          else {
            this.product.thumbnailUrl = "./../../../assets/images/noimage.jpg";
            this.product.images=[ this.product.thumbnailUrl];
          }
        }
      }, err => {
        this.sharedDataService.showError("Error occured while fetching product images...");
        this.product.thumbnailUrl = "./../../../assets/images/noimage.jpg";
        this.product.images=[ this.product.thumbnailUrl];
      })
    }
  }
 
  openDialog(): void {
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {

      height: '200px',
      width: '400px',
      data: { buttonText:{ok:"Close",cancel:""}, 
      message: "Order placed successfully,We will get back to you soon with confirmation!" }
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      this.router.navigate(['/myorders'])
      // this.animal = result;
    });
  }

}
