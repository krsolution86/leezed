import { Injectable } from '@angular/core';
import { CoreDataService } from './core-data.service';
import { Router, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable, of, EMPTY } from 'rxjs';
import { take, mergeMap } from 'rxjs/operators';
@Injectable({
  providedIn: 'root'
})
export class ProductResolveService {

  constructor(private coreDataService: CoreDataService, private router: Router) { }
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> | Observable<never> {
    let id = route.paramMap.get('id');

    return this.coreDataService.GetProductByID(id).pipe(
      take(1),
      mergeMap((lawndetail:any) => {
        if (lawndetail) {
          return of(lawndetail.product);
        } else { // id not found
         // this.router.navigate(['']);
          return EMPTY;
        }
      })
    );
  }
}
