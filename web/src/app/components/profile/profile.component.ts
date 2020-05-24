import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { SharedDataService } from 'src/app/services/shared-data.service';
import { AuthService } from 'src/app/services/auth.service';
import { CoreDataService } from 'src/app/services/core-data.service';
import { MyProfile } from 'src/app/models/myProfile';


@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {

  profileForm: FormGroup;
  public myProfile: MyProfile=new MyProfile();
  @Output() switchAuth = new EventEmitter<boolean>();
  user: any;
  constructor(

    public sharedDataService: SharedDataService,
    private fb: FormBuilder,
    public authService: AuthService,
    public coreDataService: CoreDataService,
    public sharedDataSvc: SharedDataService
  ) { }

  ngOnInit() {
    this.profileForm = this.fb.group({

    
   
      email: [this.myProfile.name, Validators.compose([
        Validators.required])],
      screenName:[this.myProfile.screenName, Validators.compose([
        Validators.required])],
      phone:[this.myProfile.phone, Validators.compose([
        Validators.required])],
      
      name: [this.myProfile.name, Validators.compose([
        Validators.required])]



    });

    this.authService.user$.subscribe(resp=>{
      this.user=resp;
      this.getMyProfile(this.user);
    })
        
   
  }
  getMyProfile(user:any){
    if(user)
    this.coreDataService.getMyProfile(user.userID).subscribe((resp: any) => {
      console.log(resp);
      if (resp) {
        this.myProfile = resp;
   

   this.profileForm.patchValue({

    userID:this.myProfile.userID,
    email:this.myProfile.email,
 
    name: this.myProfile.name,
    screenName:this.myProfile.screenName,
    phone: this.myProfile.phone
  
    
  });


      }
      

    }, err => console.log);
  }


  SaveProfile() {
    if (this.profileForm.valid) {
      var credentials = this.profileForm.value;
      this.coreDataService.saveProfile(credentials)
        .subscribe(
         ( data:any) => {
            if (data.profile != null) {

              this.sharedDataService.showSuccess("Profile Completed!");
              this.switchAuth.emit(true);
            }
          },
          error => {
            console.log(error);
            this.sharedDataService.showError(error);
            this.switchAuth.emit(false);
          });
    }
  }



}
