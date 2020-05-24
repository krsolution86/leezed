import { Component, OnInit } from '@angular/core';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { CoreDataService } from './../../services/core-data.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SharedDataService } from './../../services/shared-data.service';


@Component({
  selector: 'app-forget-pwd',
  templateUrl: './forget-pwd.component.html',
  styleUrls: ['./forget-pwd.component.scss']
})
export class ForgetPwdComponent implements OnInit {
  resetPwdForm: FormGroup;
  token: any;
  public sentMail: boolean = false;

  constructor(private fb: FormBuilder,
    private router: Router,
    private route: ActivatedRoute,
    private sharedDataService: SharedDataService,
    private coreDataService: CoreDataService) { }

  ngOnInit() {

    this.resetPwdForm = this.fb.group({
      email: ['', Validators.compose([Validators.required, Validators.email])],
      newPassword: [''],
      confirmPassword: ['']

    });



    this.route.queryParams.subscribe(params => {
      this.token = params['authVer'];

    });

  }
  sendPwdResetMail() {
    if (this.resetPwdForm.valid) {
      this.coreDataService.sendPwdResetMail(this.resetPwdForm.value).subscribe(resp => {
        console.log(resp);
        this.sentMail = true;
        this.resetPwdForm.reset();
      }, err => {
        console.log(err);
      })
    }

  }

  saveNewPassword() {
    if (this.resetPwdForm.valid && this.token) {
      var obj = { ...this.resetPwdForm.value };
      obj.passwordResetToken = this.token;

      this.coreDataService.saveNewPassword(obj).subscribe((resp: any) => {
        console.log(resp);

        if (resp.statusCode != undefined && resp.statusCode != "" && resp.statusCode != null) {
          if (resp.statusCode === "TOK_EXPIRED") {
            this.sharedDataService.showError("Token Expired (Validity 24 Hours), please use forgot password link to request a new token!");
            return;
          }
        }
        this.sharedDataService.showSuccess("Password reset successful!");
        this.router.navigate(['auth', "signIn"])
      }, err => {
        console.log(err);
      })
    }

  }



}
