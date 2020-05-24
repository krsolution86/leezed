import { Component, OnInit, ViewChild, ElementRef, Output, EventEmitter, Input } from '@angular/core';
// import { FileHandle } from './../../directives/drag-drop.directive';
import { CoreDataService } from './../../services/core-data.service';
import { SharedDataService } from './../../services/shared-data.service';
import * as _ from 'lodash';
import { Observable } from 'rxjs';
import { Breakpoints, BreakpointObserver } from '@angular/cdk/layout';
import { shareReplay, map } from 'rxjs/operators';

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.scss']
})
export class UploadComponent implements OnInit {
  @ViewChild('file1', { static: true }) file1;
  @ViewChild('file2', { static: true }) file2;
  @ViewChild('file3', { static: true }) file3;
  @Input() productID;
  public productImages: any[] = [];
  @Output() uploadComplete = new EventEmitter();
  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset)
    .pipe(
      map(result => result.matches),
      shareReplay()
    );
 
  // @ViewChild("fileUploadQueue",{static:true}) fileUploadQueue:ElementRef;
  constructor(private breakpointObserver: BreakpointObserver,private coreDataService: CoreDataService, private sharedDataService: SharedDataService, ) { }

  ngOnInit() {
    if (this.productID != undefined && this.productID != null) {
      this.sharedDataService.productImages$.subscribe(resp => {
        this.productImages = resp;
        console.log(this.productImages);
      })
    }
  }

  name = '';
  files: any[] = [];

  filesDropped(files: any[]): void {
    this.files = files;
  }


  onFilesAdded1() {
    // this.files = files;
    const files: { [key: string]: File } = this.file1.nativeElement.files;
    for (let key in files) {
      if (!isNaN(parseInt(key))) {
        this.files.push(files[key]);
      }
    }
  }
  // onFilesAdded2() {
  //   // this.files = files;
  //   const files: { [key: string]: File } = this.file2.nativeElement.files;
  //   for (let key in files) {
  //     if (!isNaN(parseInt(key))) {
  //       this.files.push(files[key]);
  //     }
  //   }
  // }
  // onFilesAdded3() {
  //   // this.files = files;
  //   const files: { [key: string]: File } = this.file3.nativeElement.files;
  //   for (let key in files) {
  //     if (!isNaN(parseInt(key))) {
  //       this.files.push(files[key]);
  //     }
  //   }
  // }



  openFilePicker() {

  }

  upload(fileIndex): void {
    //get image upload file obj;

    if (this.productID != undefined && this.productID > 0) {
      this.coreDataService.uploadImage(this.productID, [this.files[fileIndex]]).subscribe(resp => {
        console.log(resp);
        this.sharedDataService.showSuccess("Images uploaded");
        
        this.uploadComplete.emit(true);
      }, err => {

        this.sharedDataService.showError("Error uploading images!");
      });

    }
    else {
      console.log("Product ID not found!");
    }
  }
  deleteImgObject: any = {};
  deleteProductImage(imageName) {
    console.log("delete image named :" + imageName);
    if (this.productID != undefined && this.productID != null) {
      this.deleteImgObject.productID = this.productID;
      var imgNameArr = imageName.split('/');
      var length = imgNameArr.length;
      var actualName = imgNameArr[length - 1];
      if (actualName != "" && actualName != null && actualName != undefined) {
        this.deleteImgObject.imageName = actualName;
        this.deleteImgObject.deleteType = true; //false if all image delete
        this.coreDataService.deleteProductImage(this.deleteImgObject).subscribe((resp: any) => {
          console.log(resp);
          if (resp.message) {
            this.productImages = _.reject(this.productImages, function (el) { return el.imageName === imageName; });
          }
        }, err => {
          console.log(err);
        })
      }
    }





  }
}
