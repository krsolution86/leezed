import { Component, OnInit, Input, OnChanges } from '@angular/core';
import { CoreDataService } from 'src/app/services/core-data.service';
import { AuthService } from 'src/app/services/auth.service';
import * as _ from "lodash";
@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.scss']
})
export class ChatComponent implements OnInit ,OnChanges{

  public chatHistory: any[] = [];
  @Input() order: any;
  messageObj: { orderID: Number, productID: Number, message: String, fromUserID: Number, toUserID: Number };
  user: any;
  public message:string="";
  constructor(private coreSvc: CoreDataService,private authSvc:AuthService) { }

  ngOnInit() {
    if (this.order) {
      this.fetchChatHistory();

    }
    this.authSvc.user$.subscribe(resp=>{
      this.user=resp;
    })
  }

  ngOnChanges(){
    if (this.order) {
      this.fetchChatHistory();

    }
  }

  fetchChatHistory() {
    this.coreSvc.fetchChatHistory(this.order.orderID).subscribe((resp: any) => {


        this.chatHistory = Object.assign({},resp.chatHistory);
        this.chatHistory= _.sortBy(this.chatHistory, function(value) {return new Date(value.createdAt);}).reverse();
//         if(this.order){
//           const rentedFromUserID=this.order.rentedFromUserID;
// const renterUserID=this.order.userID;
// const rentedFrom=this.order.ownerName;
// const rentedBy=this.order.requestedBy;
// this.chatHistory.map(obj=> ({ ...obj, rentedFrom:rentedFrom,rentedBy:rentedBy }));

// console.log(this.chatHistory);
//         }
     //   _.orderBy( this.chatHistory, ['createdAt'],['asc']);
     

    }, err => console.log(err));
  }

  sendMessage() {
    if (this.order != null && this.order != undefined && this.user) {
      var toUserID=0;
      if(this.user.userID==this.order.rentedFromUserID){
        toUserID=this.order.userID;
      }
      else{
toUserID=this.order.rentedFromUserID;
      }
      var messageObject={fromUserID:this.user.userID,orderID:this.order.orderID,productID:this.order.productID,toUserID:toUserID,message:this.message}
   console.log(messageObject);
    
      this.coreSvc.sendMessage(messageObject).subscribe(resp => {
        console.log(resp);
this.chatHistory.push(messageObject);
this.message="";
      }, err => { console.log(err); })
    }
  }

}
