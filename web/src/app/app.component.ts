import { Component, OnInit, AfterViewInit, ViewChild  } from '@angular/core';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Observable } from 'rxjs';
import { map, shareReplay } from 'rxjs/operators';
import { AuthService } from './services/auth.service';
import { SidenavService } from './services/side-nav.service';
import { CoreDataService } from './services/core-data.service';
import { Router } from '@angular/router';
import { SharedDataService } from './services/shared-data.service';
import { TitleService } from './services/title.service';
import { MatDialog } from '@angular/material';
import { TermsOfUseComponent } from './components/terms-of-use/terms-of-use.component';
import { PrivacyPolicyComponent } from './components/privacy-policy/privacy-policy.component';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'leezed';
  @ViewChild("drawer",{static:true}) drawer: any;
  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset)
    .pipe(
      map(result => result.matches),
      shareReplay()
    );
  public user: any;



  constructor( private breakpointObserver: BreakpointObserver,private route: Router,
     public authService: AuthService,
     public titleService: TitleService,
     public dialog: MatDialog,
     private router: Router,
     private sidenavService: SidenavService,
    private coreDataService: CoreDataService,
    private sharedDataService: SharedDataService,
  ) {


    this.titleService.init();


    
this.authService.user$.subscribe(resp=>{
  this.user=resp;
})
    
    //close side nav  on navigation
    this.router.events.subscribe(event => {
      // close sidenav on routing
      this.sidenavService.close();
    });

  
   }
  ngAfterViewInit(): void {
    this.sidenavService.setSidenav(this.drawer);
  }

  navigate(type) {
    this.route.navigate(['auth', type]);
  }


  signOut() {
    this.authService.logout();
    this.drawer.close();
   
  }

  goToHome(){
    this.route.navigate([''])
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

}
