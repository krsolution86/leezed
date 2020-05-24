import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, map, tap, retry, shareReplay, zip } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import { throwError } from 'rxjs';
import { Product } from '../models/Product';
// import { FileHandle } from './../directives/drag-drop.directive';
import { Order } from '../models/Order';
import { MyProfile } from '../models/myProfile';
import { Data } from '@angular/router';
@Injectable({
  providedIn: 'root'
})
export class CoreDataService {

  private productBaseUrl = environment.productListUrl;
  private baseUrl = environment.apiUrl;
  private ipInfoToken=environment.ipInfoToken;
  constructor(private http: HttpClient) { }
  //Product Related ops
  addProduct(product: Product) {
    return this.http.post(this.baseUrl + '/products/create', product)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  addProductToLiveListings(product: any) {
    return this.http.post(this.baseUrl + '/products/addProductToLiveListings',product)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }
  updateProduct(product: Product) {
    return this.http.post(this.baseUrl + '/products/update', product)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  //order related ops
  placeRentRequest(order: Order) {
    return this.http.post(this.baseUrl + '/orders/placeRentRequest', order)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  processRentRequests(order: any) {
    return this.http.post(this.baseUrl + '/orders/processRentRequests', order)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }


  //index related urls

  writeToESIndex(payload: any) {
    return this.http.post(this.baseUrl + '/elastic/elastic/add', payload)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }
deleteSingleFromESIndex(payload: any) {
    return this.http.post(this.baseUrl + '/elastic/elastic/add', payload)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  getMyOrders() {
    return this.http.get(this.baseUrl + '/orders/getMyOrders')
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }

  getMyItems() {
    return this.http.get(this.baseUrl + '/products/getMyItems')
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }

  getMyProfile(userID) {
    return this.http.get(this.baseUrl + '/users/getByIdUser',{
      params: {
        userID: userID,
      }
    })
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }

  saveProfile(profile: MyProfile) {
    return this.http.post(this.baseUrl + '/users/updateProfile', profile)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  getIP() {
    return this.http.get('http://ipinfo.io/geo?token='+this.ipInfoToken) 
    .pipe(
      tap(this.extractData),
      catchError(this.handleError));
}

sendPwdResetMail(emailObj) {
  return this.http.post(this.baseUrl + '/users/sendPwdResetEmail', emailObj)
    .pipe(
      tap(this.extractData),
      catchError(this.handleError));
}

saveNewPassword(emailObj) {
  return this.http.post(this.baseUrl + '/users/saveNewPassword', emailObj)
    .pipe(
      tap(this.extractData),
      catchError(this.handleError));
}



verifyUserToken(token) {
  return this.http.post(this.baseUrl + '/users/verifyUser', token)
    .pipe(
      tap(this.extractData),
      catchError(this.handleError));
}






  GetProductByID(id) {
    return this.http.get(this.baseUrl + '/products/getProductDetails', {
      params: {
        id: id,
      }
    })
      .pipe(
        tap(this.extractData),
        retry(1),
        catchError(this.handleError));
  }


  GetProductViewModel(id) {
    return this.http.get(this.baseUrl + '/products/getProductViewModel', {
      params: {
        productID: id,
      }
    })
      .pipe(
        tap(this.extractData),
        retry(1),
        catchError(this.handleError));
  }


  SearchProducts(searchTerms, zipCode) {
    return this.http.get(this.baseUrl + '/products/searchProducts', {
      params: {
        searchTerms: searchTerms,
        zipCode: zipCode
      }
    })
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }


  GetProductImages(productID) {
    return this.http.get(this.baseUrl + '/images/getProductImages', { params: { productID: productID } })
      .pipe(
        tap(this.extractData),

        catchError(this.handleError));
  }

  GetProductList(qTerm,lat,lan) {
    return this.http.get(this.baseUrl+'/products/searchProducts?searchTerms='+qTerm+'&lat='+lat+'&lan='+lan+'')
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }

  getCategories() {
    return this.http.get(this.baseUrl + '/common/getCategories')
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }


  getSharedData() {
    return this.http.get(this.baseUrl + '/common/getSharedData')
      .pipe(
        tap(this.extractData),
        retry(3),
        catchError(this.handleError));
  }
  //upload product Images



  public uploadImage(productID, images: any[]): Observable<Response> {
    const formData = new FormData();
    formData.append('productID', productID);
    for (var i = 0; i < images.length; i++) {
      formData.append('photos', images[i]);
    }

    return this.http.post(this.baseUrl + '/images/upload', formData)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  public deleteProductImage(deleteImageParam): Observable<Response> {
  
//     let httpParams = new HttpParams().set('productID', deleteImageParam.productID);
// httpParams.set('imageName', deleteImageParam.imageName);
// httpParams.set('deleteType', deleteImageParam.deleteType);

// let options = { params: httpParams };
    return this.http.post(this.baseUrl + '/images/delete', deleteImageParam)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }



  //sign in /sign up related ops
  registerUser(user: any): Observable<any> {
    return this.http.post(this.baseUrl + '/users/signup', user)
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));

  }

  loginUser(email: any, password: any): Observable<any> {
    return this.http.post(this.baseUrl + '/users/signin', { email, password })
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }
  getZipAddress(zipCode) {
 
    return this.http.get(this.baseUrl + '/users/fetchZipDetails', {
      params: {
        zipcode: zipCode,
      }
    })
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }


  fetchChatHistory(orderID) {
 
    return this.http.get(this.baseUrl + '/orders/fetchChatHistory', {
      params: {
        orderID: orderID,
      }
    })
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }


  sendMessage(messageObj){
    return this.http.post(this.baseUrl + '/orders/sendMessage', {...messageObj })
    .pipe(
      tap(this.extractData),
      catchError(this.handleError));
  }
  
  facebookLogin(token: any) {
    // return this.http.post("url to facebook login here", { token: token });
    return this.http.post(this.baseUrl + '/api/auth/facebook', { access_token: token })
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }
  googleLogin(token: any) {
    // return this.http.post("url to facebook login here", { token: token });
    return this.http.post(this.baseUrl + '/api/auth/google', { access_token: token })
      .pipe(
        tap(this.extractData),
        catchError(this.handleError));
  }

  // common applicable  operations on http response object
  private extractData(res: Response) {
    const body = res || res.json();
    return body || {};
  }
  private handleError(errorObj: Response | any) {
    //  will use a remote logging infrastructure
    let errMsg: string;
    if (errorObj instanceof Response) {
      const body = errorObj || '';
      const err = body || JSON.stringify(body);
      errMsg = ` ${errorObj.status}-${errorObj.status} - ${errorObj.statusText || ''} ${err}`;
    }
    else if (errorObj.error) {
      errMsg = errorObj.error.errorMsg ? errorObj.error.errorMsg : errorObj.toString();
    }
    else {
      errMsg = errorObj.message ? errorObj.message : errorObj.toString();
    }


    console.error(errMsg);
    return throwError(errMsg || errorObj.message || errorObj);
  }
}
