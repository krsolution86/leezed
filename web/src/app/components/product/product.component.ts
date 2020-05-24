import { Component, OnInit, Input } from '@angular/core';
import {Product} from './../../models/Product';
import { Router } from '@angular/router';
@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export  class ProductComponent implements OnInit {
@Input("Product") product:Product;
  constructor(   
    private router: Router,) { }

  ngOnInit() {
  }
  OpenProduct(productID){
this.router.navigate(['view-product',productID]);
  }

}
