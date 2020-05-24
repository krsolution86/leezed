import { Component, OnInit, Inject } from '@angular/core';
import { Order } from 'src/app/models/Order';
import { SharedDataService } from 'src/app/services/shared-data.service';

import { CoreDataService } from 'src/app/services/core-data.service';
import { AuthService } from 'src/app/services/auth.service';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material';
import { ApproveDialogComponent } from '../myorders/myorders.component';

@Component({
  selector: 'app-pending-approvals',
  templateUrl: './pending-approvals.component.html',
  styleUrls: ['./pending-approvals.component.scss']
})
export class PendingApprovalsComponent implements OnInit {

  public myOrders: Order[];
  public user: any;
constructor(private sharedDataService: SharedDataService,
  public authService: AuthService,  private coreDataService: CoreDataService,
  

  private dialog: MatDialog

  ){}

  ngOnInit() {
    this.getMyOrders();


    
this.authService.user$.subscribe(resp=>{
  this.user=resp;
});
  }

  private getMyOrders() {
    this.coreDataService.getMyOrders().subscribe((resp: any) => {
      console.log(resp);
      if (resp) {
        this.myOrders = resp.myOrders.filter(x => x.isApproved <= 0);
      }
    }, err => {
      console.log(err);
    });
  }

  ngAfterViewInit() {
  
  }


  approveOrder(order:any){
    order.isApproved=true;   
    this.coreDataService.processRentRequests(order).subscribe(resp=>{
    console.log(order);
    order.status="APPROVED";
this.getMyOrders();
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
      this.getMyOrders();

      },err=>{
    console.log(err);
      });
  }
public selectedOrder:any;
setStep(ord:any){
  console.log(ord);
  this.selectedOrder=ord;

}
  openApproveDialog(order): void {
    console.log(order);
    this.selectedOrder=order;
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

