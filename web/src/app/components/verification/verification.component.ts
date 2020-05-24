import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CoreDataService } from './../../services/core-data.service';

@Component({
  selector: 'app-verification',
  templateUrl: './verification.component.html',
  styleUrls: ['./verification.component.scss']
})
export class VerificationComponent implements OnInit {
  token: any;

  constructor(private route: ActivatedRoute, private coreDataService: CoreDataService, ) { }

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.token = params['token'];
      if (this.token != undefined && this.token != "") {

        var toeknObj = { token: this.token };

        this.coreDataService.verifyUserToken(toeknObj).subscribe(resp => {
          if (resp.status === 200) {
            console.log("user verified!");
          }
        }, err => {
          console.log("user email not verified!", err);
        })
      }
    });
  }

}
