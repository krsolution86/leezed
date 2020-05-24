import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators, FormGroup, FormGroupDirective, NgForm, FormControl } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { User } from './../../models/User';
import {
  AuthService as SocialAuthService,
  FacebookLoginProvider,
  GoogleLoginProvider
} from 'angular-6-social-login';
import { AuthService } from './../../services/auth.service';
import { SharedDataService } from './../../services/shared-data.service';
import { CoreDataService } from './../../services/core-data.service';
import { ErrorStateMatcher, MatDialog } from '@angular/material';
import { TermsOfUseComponent } from '../terms-of-use/terms-of-use.component';
import { PrivacyPolicyComponent } from '../privacy-policy/privacy-policy.component';

// declare var FB: any;
@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.scss']
})
export class AuthComponent implements OnInit {
  user: any;
  mySignUpForm: FormGroup;
  mySignInForm: FormGroup;
  message: String;
  State: any;
  City: any;
  showLogin: boolean = false;
public matcher = new MyErrorStateMatcher();
public barLabel: string = "Password strength:";
  ngOnInit() {
    
    if (this.authService.authenticated) {
      this.router.navigate(['']);
    }
    this.user = {};

    this.route.params.subscribe(params => {
      console.log(params["type"]);
      if (params["type"] === "signup") {
        this.mySignUpForm = this.fb.group({
          // username: [this.user.username, Validators.compose([Validators.required])],
          name: [this.user.name,Validators.compose([Validators.required])],
          email: [this.user.email, Validators.compose([
            Validators.required, Validators.email])],
          password: [this.user.password,Validators.compose([Validators.required])],
          confirmPassword:[this.user.confirmPassword,Validators.compose([Validators.required])],
          screenName: [this.user.screenName,Validators.compose([Validators.required])],
        

          phone: [this.user.phone, Validators.compose([
            Validators.required,
            Validators.maxLength(10)])
          ],
       
          disclaimerStatus: [this.user.disclaimerAccepted, Validators.compose([
            Validators.required])]
        },{validator: this.checkPasswords });

        this.showLogin = false;
      }
      else {
        this.mySignInForm = this.fb.group({

          email: [this.user.email, Validators.compose([
            Validators.required, Validators.email])],

          password: [this.user.password, Validators.compose([
            Validators.required])],
            remember: [this.user.remember]
         
        });
        this.showLogin = true;

      }
    });


    // (window as any).fbAsyncInit = function () {
    //   FB.init({
    //     appId: '2334958963382261',
    //     cookie: true,
    //     xfbml: true,
    //     version: 'v3.1'
    //   });
    //   FB.AppEvents.logPageView();
    // };

    // (function (d, s, id) {
    //   var js, fjs = d.getElementsByTagName(s)[0];
    //   if (d.getElementById(id)) { return; }
    //   js = d.createElement(s); js.id = id;
    //   js.src = "https://connect.facebook.net/en_US/sdk.js";
    //   fjs.parentNode.insertBefore(js, fjs);
    // }(document, 'script', 'facebook-jssdk'));

  }




  constructor(private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
    public dialog: MatDialog,
    private coreDataService: CoreDataService,
    private sharedDataService: SharedDataService,
   // private socialAuthService: SocialAuthService,
  ) { }




  onSubmit() {
    alert('Thanks!');
  }

  signUp() {
    if (!this.mySignUpForm.controls["disclaimerStatus"].value) {
      this.sharedDataService.showWarning("You need to accept terms of Use & Privacy Policy to create an account!");
      return;
    }
  

    if (this.mySignUpForm.valid) {

      this.register(this.mySignUpForm.value);
    }
    else {
      this.sharedDataService.showWarning("Invalid Information, Please fill correct info!");
    }


  }



  register(credentials) {

    this.coreDataService.registerUser(credentials)
      .subscribe(
        data => {
          if (data.authToken != null || data.authToken==='VRF') {
            this.sharedDataService.showSuccess("User Registered Successfully!");
            console.log(credentials);
if(data.authToken!=='VRF')
        {    var emailObj = { name: "", email: "", phone: "", zip: "" };
            emailObj.name = credentials.name;
            
            emailObj.email = credentials.email;
            emailObj.phone = credentials.phone;
            emailObj.zip = credentials.zip;

         
            this.authService._setSession(data, 'home');
          }
          else{
            this.router.navigate(["/welcome"]);
          }
          }
          else {
            this.sharedDataService.showError("User sign up failed!");
          }
        },
        error => {
          console.log(error);
          this.sharedDataService.showError(error);
        });
  }

  signIn() {
    if (this.mySignInForm.valid) {
      var credentials = this.mySignInForm.value;
      this.coreDataService.loginUser(credentials.email, credentials.password)
        .subscribe(
          data => {
            if (data.authToken != null) {
              this.authService._setSession(data, 'home');

            }
            else {
              this.sharedDataService.showError("User sign in failed!");
            }
          },
          error => {
            console.log(error);
            this.sharedDataService.showError(error);
          });
    }
  }


  checkPasswords(group: FormGroup) { // here we have the 'passwords' group
  let pass = group.get('password').value;
  let confirmPass = group.get('confirmPassword').value;

  return pass === confirmPass ? null : { notSame: true }     
}


  
showDialog(type) {
  if (type == 'TOU') {

    const dialogRef = this.dialog.open(TermsOfUseComponent);

    dialogRef.afterClosed().subscribe((confirmed: boolean) => {

    });
  }
  else {
    const dialogRef = this.dialog.open(PrivacyPolicyComponent);

    dialogRef.afterClosed().subscribe((confirmed: boolean) => {

    });

  }


}

// public facebookLogin() {
//   let socialPlatformProvider = FacebookLoginProvider.PROVIDER_ID;
//   this.socialAuthService.signIn(socialPlatformProvider).then(
//     (userData) => {
//       //this will return user data from facebook. What you need is a user token which you will send it to the server
//       this.localFacebookLogin(userData.token);
//     }
//   );
// }

// localFacebookLogin(token: string): void {
//   this.coreDataService.facebookLogin(token).subscribe((data: any) => {
//     if (data.authToken != null) {
//       this.authService._setSession(data, 'lawnCarePlan');

//     }
//     else {
//       this.sharedDataService.showError("User sign in failed!");
//     }



//     //login was successful
//     //save the token that you got from your REST API in your preferred location i.e. as a Cookie or LocalStorage as you do with normal login
//   }, error => {
//     //login was unsuccessful
//     //show an error message
//     console.log(error);
//     this.sharedDataService.showError(error);

//   }
//   );
// }


// public googleLogin() {
//   let socialPlatformProvider = GoogleLoginProvider.PROVIDER_ID;
//   this.socialAuthService.signIn(socialPlatformProvider).then(
//     (userData) => {
//       //this will return user data from facebook. What you need is a user token which you will send it to the server
//       this.localGoogleLogin(userData.token);
//     }
//   );
// }

// localGoogleLogin(token: string): void {
//   this.coreDataService.googleLogin(token).subscribe((data: any) => {
//     if (data.authToken != null) {
//       this.authService._setSession(data, '');
//     }
//     else {
//       this.sharedDataService.showError("User sign in failed!");
//     }



//     //login was successful
//     //save the token that you got from your REST API in your preferred location i.e. as a Cookie or LocalStorage as you do with normal login
//   }, error => {
//     //login was unsuccessful
//     //show an error message
//     console.log(error);
//     this.sharedDataService.showError(error);

//   }
//   );
// }

// public fbLogoutUser() {
//   this.socialAuthService.signOut().then((resp) => {
//     console.log(resp);

//   }).catch(err => {
//     console.log(err);
//   })

// }

}

export class MyErrorStateMatcher implements ErrorStateMatcher {
  isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
    const invalidCtrl = !!(control && control.invalid && control.parent.dirty);
    const invalidParent = !!(control && control.parent && control.parent.invalid && control.parent.dirty);

    return (invalidCtrl || invalidParent);
  }
}
