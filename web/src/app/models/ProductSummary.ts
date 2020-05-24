export class ProductSummary {
    productID: Number;
    thumbnailImg:string;
    productName: string;
    productDesc: string;
    categoryID: Number;
    imageUrls: string;
    categoryName: string;
    ownerID: Number;
    ownerName: string;
    rentPrice: Number;
    durationUnit: string;
    durationUnitDesc: string;
    minRental: Number;
    city: string;
    state: string;
    zipCode: Number;
    geo_loc:{location:Number[]}={location:[]}
    location: string;
    officialurl: string;

    pickupInstructions: string = "";
    availableFromDate: Date;
    availableToDate: Date;
    activationDate: Date;

    activeInd: Number;
    createdAt: Date = new Date();
    updatedAt: Date = new Date();



}