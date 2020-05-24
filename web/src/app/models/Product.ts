export class Product{
    productID:Number;
    name:string;
    categoryID:Number;
    categoryName:string;
    rentPrice:Number;
    durationUnit:string;
    durationUnitDesc:string;
    currency:string="$";
    minRental:Number;
   city:string;
   state:string;
    zipCode:string;
    description:string;
    officalUrl:string;
    thumbnailUrl:string;
    images:string[];
    cost:string;
    itemValue:any;
    category:string;
    location:  string  ;
    pickupInstructions:string="";
    availableFromDate:Date;
    availableToDate:Date;
    costManagerID:Number;
    activeInd:Number
}