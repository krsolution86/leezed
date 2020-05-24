import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthComponent } from './components/auth/auth.component';
import { ProductListComponent } from './components/product-list/product-list.component';
import { ProductEditComponent } from './components/product-edit/product-edit.component';
import { UploadComponent } from './components/upload/upload.component';
import { ProductResolveService } from './services/product-resolve.service';
import { MyordersComponent } from './components/myorders/myorders.component';
import { AuthGuard } from './services/auth-gaurd.service';
import { RentProductComponent } from './components/rent-product/rent-product.component';
import { ProductViewResolveService } from './services/productview-resolve.service';
import { MyitemsComponent } from './components/myitems/myitems.component';
import { PendingApprovalsComponent } from './components/pending-approvals/pending-approvals.component';
import { ChatComponent } from './components/chat/chat.component';
import { ProfileComponent } from './components/profile/profile.component';
import { WelcomeComponent } from './components/welcome/welcome.component';
import { HowitworksComponent } from './components/howitworks/howitworks.component';
import { ForgetPwdComponent } from './components/forget-pwd/forget-pwd.component';
import { VerificationComponent } from './components/verification/verification.component';


const routes: Routes = [
  {
    path: 'home', component: ProductListComponent,
    data: { title: "Rent Items" },
  },
  {
    path: 'auth/:type',
    component: AuthComponent,
    data: { title: "Login / Register" },

  },
  { 
    path: 'pendingapprovals',
    component: PendingApprovalsComponent,
    canActivate: [AuthGuard],
    data: { title: "My Pending Approvals" },


  },
  { 
    path: 'welcome',
    component: WelcomeComponent,
    data: { title: "Welcome" },


  },

  {
    path: 'chat',
    component: ChatComponent,
    canActivate: [AuthGuard],
    data: { title: "Chat" },


  },
  {
    path: 'myorders',
    component: MyordersComponent,
    canActivate: [AuthGuard],
    data: { title: "Transactions" },


  },
  {
    path: 'myitems',
    component: MyitemsComponent,
    canActivate: [AuthGuard],
    data: { title: "My Products" },


  },
  {
    
    path:'verification',
    component: VerificationComponent,
   
    data: { title: "Verification" },
  },
  {
    path: 'resetpassword',
    component: ForgetPwdComponent,
   
    data: { title: "Forgot Password" },


  },
  {
    path: 'how-it-works', component: HowitworksComponent,

    data: { title: "How It Works" }
   

  },
  {
    path: 'add-product', component: ProductEditComponent,

    data: { title: "Add Product" }
    , canActivate: [AuthGuard]

  },
  {
    path: 'profile', component: ProfileComponent,

    data: { title: "Profile" }
    , canActivate: [AuthGuard]

  },
  {
    path: 'view-product/:id', component: RentProductComponent,
    data: { title: "View Item" },
    resolve: {
      product: ProductViewResolveService
    }
  },
  {
    path: 'edit-product/:id', component: ProductEditComponent,

    data: { title: "Update Item" },
    resolve: {
      product: ProductResolveService
    },
    canActivate: [AuthGuard]
  },
  {
    path: 'edit-product/upload/:id',
    component: UploadComponent,
    canActivate: [AuthGuard],

  },

  { path: '', redirectTo: 'home', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
