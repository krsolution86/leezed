import { Component, OnInit, Input, Output,EventEmitter, OnChanges, SimpleChanges } from '@angular/core';
import { ProductSummary } from  './../../models/ProductSummary';
import { ComponentCanDeactivate } from 'src/app/services/pending-changes-gaurd.service';
import { SharedDataService } from 'src/app/services/shared-data.service';

@Component({
  selector: 'app-add-product-summary',
  templateUrl: './add-product-summary.component.html',
  styleUrls: ['./add-product-summary.component.scss']
})
export class AddProductSummaryComponent implements OnInit,OnChanges  {
  today:Date=new Date();
  @Output() makeLive=new EventEmitter();
  @Output() goBack=new EventEmitter();
public productSummary:ProductSummary;
  constructor(private sharedDataSvc:SharedDataService) { }

  ngOnInit() {

this.sharedDataSvc.productSummary$.subscribe(prod=>{
  this.productSummary=prod;
})
  }
  ngOnChanges(changes: SimpleChanges){
console.log(changes.currentValue);
  }
  addToLiveList(){
    this.makeLive.emit(true);
  }
  goBackStep(){
    this.goBack.emit(true);
  }

}
