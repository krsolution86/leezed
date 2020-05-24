import { Injectable } from '@angular/core';
import { CoreDataService } from './core-data.service';
import { Router, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable, of, EMPTY } from 'rxjs';
import { take, mergeMap } from 'rxjs/operators';
@Injectable({
  providedIn: 'root'
})
export class ProductViewResolveService {

  constructor(private coreDataService: CoreDataService, private router: Router) { }
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> | Observable<never> {
    let id = route.paramMap.get('id');

    return this.coreDataService.GetProductViewModel(id).pipe(
      take(1),
      mergeMap((products:any) => {
        if (products ) {

          return of(products.product[0]);
        } else { // id not found
         // this.router.navigate(['']);
          return EMPTY;
        }
      })
    );
  }
}
