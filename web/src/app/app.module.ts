import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { SocialLoginModule, AuthServiceConfig } from 'angular-6-social-login';
import { getAuthServiceConfigs } from './social-login-config';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ProductComponent } from './components/product/product.component';
import { ProductListComponent } from './components/product-list/product-list.component';
import { AppMaterialModules } from './app.meterial/app.meterial.module';
import { LayoutModule } from '@angular/cdk/layout';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthComponent } from './components/auth/auth.component';
import { AuthInterceptorService } from './services/auth-interceptor.service';
import { ToastrModule } from 'ngx-toastr';
import { LoaderComponent } from './components/shared/loader/loader.component';
import { LoaderInterceptor } from './services/loader-interceptor.service';
import { ProductEditComponent, AddProductDialog } from './components/product-edit/product-edit.component';
import { FlexLayoutModule } from '@angular/flex-layout';

import { ConfirmationDialogComponent } from './components/shared/confirmation-dialog/confirmation-dialog.component';
import { UploadComponent } from './components/upload/upload.component';
// import { DragDropDirective } from './directives/drag-drop.directive';
import { NgxMaskModule, IConfig } from 'ngx-mask';

import { MyordersComponent, ApproveDialogComponent } from './components/myorders/myorders.component';

import { RentProductComponent } from './components/rent-product/rent-product.component';
import { OwlDateTimeModule, OwlNativeDateTimeModule, OWL_DATE_TIME_FORMATS } from 'ng-pick-datetime';
import { RatingModule } from 'ng-starrating';
import { MyitemsComponent } from './components/myitems/myitems.component';
import { AddProductSummaryComponent } from './components/add-product-summary/add-product-summary.component';
import { ServiceWorkerModule } from '@angular/service-worker';
import { environment } from '../environments/environment';
import { PasswordStrengthBar } from './components/auth/passwordStrengthBar.component';
import { MatCarouselModule } from '@ngmodule/material-carousel';
import { SatPopoverModule } from '@ncstate/sat-popover';
import { PendingApprovalsComponent } from './components/pending-approvals/pending-approvals.component';
import { PrivacyPolicyComponent } from './components/privacy-policy/privacy-policy.component';
import { TermsOfUseComponent } from './components/terms-of-use/terms-of-use.component';
import { ChatComponent } from './components/chat/chat.component';
import { LocationChangeComponent } from './components/location-change/location-change.component';
import { ProfileComponent } from './components/profile/profile.component';
import { WelcomeComponent } from './components/welcome/welcome.component';
import { HowitworksComponent } from './components/howitworks/howitworks.component';
import { ForgetPwdComponent } from './components/forget-pwd/forget-pwd.component';
import { VerificationComponent } from './components/verification/verification.component';
 
export const options: Partial<IConfig> | (() => Partial<IConfig>) = {};
@NgModule({
  declarations: [
    AppComponent,
    VerificationComponent,
    PasswordStrengthBar,
    ForgetPwdComponent,
    ProductComponent,
    ProductListComponent,
    AuthComponent,
    LoaderComponent,
    ProductEditComponent,
    ConfirmationDialogComponent,
    UploadComponent,
    ApproveDialogComponent,
    MyordersComponent,
    RentProductComponent,
    MyitemsComponent,
    AddProductSummaryComponent,
    AddProductDialog,
    PendingApprovalsComponent,
    PrivacyPolicyComponent,
    TermsOfUseComponent,
    ChatComponent,
    LocationChangeComponent,
    ProfileComponent,
    WelcomeComponent,
    HowitworksComponent


  ],
  entryComponents: [ConfirmationDialogComponent,ApproveDialogComponent,AddProductDialog,PrivacyPolicyComponent,TermsOfUseComponent],
  imports: [
    RatingModule,
    BrowserAnimationsModule ,

    ReactiveFormsModule,
    AppMaterialModules,
    SatPopoverModule,
    SocialLoginModule,
    FormsModule,
    BrowserModule,
    MatCarouselModule.forRoot(),
    OwlDateTimeModule,
    OwlNativeDateTimeModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    LayoutModule,
    HttpClientModule,
    FlexLayoutModule,
    ToastrModule.forRoot({
      timeOut: 5000,
      positionClass: 'toast-top-right',
      preventDuplicates: true,
    }),
    
    NgxMaskModule.forRoot(options),
    
    ServiceWorkerModule.register('ngsw-worker.js', { enabled: environment.production }),   

  ],

  providers: [

    { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptorService, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: LoaderInterceptor, multi: true },
    { provide: AuthServiceConfig, useFactory: getAuthServiceConfigs },
    {
      provide: OWL_DATE_TIME_FORMATS, useValue: {

        datePickerInput: { year: 'numeric', month: 'numeric', day: 'numeric' },
        timePickerInput: { hour: 'numeric', minute: 'numeric' }
      }
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
