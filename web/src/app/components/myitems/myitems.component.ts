import { Component, OnInit } from '@angular/core';
import { CoreDataService } from 'src/app/services/core-data.service';
import { SharedDataService } from 'src/app/services/shared-data.service';

@Component({
  selector: 'app-myitems',
  templateUrl: './myitems.component.html',
  styleUrls: ['./myitems.component.scss']
})
export class MyitemsComponent implements OnInit {

  public myItems: any[];
constructor(private sharedDataService: SharedDataService,
  private coreDataService: CoreDataService){}

  ngOnInit() {
    this.coreDataService.getMyItems().subscribe((resp:any)=>{
      console.log(resp);
      if(resp){
        this.myItems=resp.myItems;

      }
    },err=>{
      console.log(err)
    })
  }

  ngAfterViewInit() {
    
  }

}
