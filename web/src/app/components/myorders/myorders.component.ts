import { AfterViewInit, Component, OnInit, ViewChild, Inject } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTable } from '@angular/material/table';
import { Order } from 'src/app/models/Order';
import { CoreDataService } from 'src/app/services/core-data.service';
import { SharedDataService } from 'src/app/services/shared-data.service';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { ConfirmationDialogComponent } from '../shared/confirmation-dialog/confirmation-dialog.component';
import { AuthService } from 'src/app/services/auth.service';


@Component({
  selector: 'app-myorders',
  templateUrl: './myorders.component.html',
  styleUrls: ['./myorders.component.scss']
})
export class MyordersComponent implements AfterViewInit, OnInit {
  // @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  // @ViewChild(MatSort, {static: false}) sort: MatSort;
  // @ViewChild(MatTable, {static: false}) table: MatTable<MyordersItem>;
 public myOrders: Order[];
 public messageObj:any;

 public selectedOrder:any;

  public user: any;
constructor(private sharedDataService: SharedDataService,
  public authService: AuthService,
  private dialog: MatDialog,

  private coreDataService: CoreDataService){}

  ngOnInit() {
    this.coreDataService.getMyOrders().subscribe((resp:any)=>{
      console.log(resp);
      if(resp){
        this.myOrders=resp.myOrders.filter(x=>x.isApproved>0);

      }
    },err=>{
      console.log(err)
    })


    
this.authService.user$.subscribe(resp=>{
  this.user=resp;
})
  }

  ngAfterViewInit() {
  
  }

  approveOrder(order:any){
    order.isApproved=true;
   
    this.coreDataService.processRentRequests(order).subscribe(resp=>{
    console.log(order);
    order.status="APPROVED";
    },err=>{
  console.log(err);
    });
  }

  declineOrder(order){
    console.log(order);
    order.isApproved=false;
    order.approvalComments="declined";
    this.coreDataService.processRentRequests(order).subscribe(resp=>{
      console.log(order);

      },err=>{
    console.log(err);
      });
  }
  setStep(ord:any){
    console.log(ord);
    this.selectedOrder=ord;
  
  }
  openApproveDialog(order): void {
    console.log(order);
    const dialogRef = this.dialog.open(ApproveDialogComponent, {
      width: '350px',
      data: {productID: order.productID, orderID:order.orderID,approvalComments:'',isApproved:false}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
     console.log(result);
     this.approveOrder(result);
    });
  }
}


@Component({
  selector: 'dialog-overview-example-dialog',
  template: `<h1 mat-dialog-title>Approval Order</h1>
  <div mat-dialog-content>
    <p>Please give approval comments below, if any:</p>

    <textarea class="textarea" placeholder="Approval comments"  [(ngModel)]="data.approvalComments"></textarea>
     

  </div>
  <div mat-dialog-actions>
    <button mat-button (click)="onNoClick(data)">Close</button>
    <button mat-button [mat-dialog-close]="data" cdkFocusInitial>Ok</button>
  </div>`,
})
export class ApproveDialogComponent {

  constructor(
    public dialogRef: MatDialogRef<ApproveDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) {}

  onNoClick(data): void {
    this.dialogRef.close();
  }

}
