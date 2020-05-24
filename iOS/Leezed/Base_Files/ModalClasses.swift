//
//  ModalClasses.swift
//  Leezed
//
//  Created by Neha Gupta on 22/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class Products {
    
    var ProductID = Int()
    var Name = String()
    var Description = String()
    var OfficialUrl = String()
    var ThumbnailUrl = String()
    var Category = String()
    var Location = String()
    var AvailableFromDate = String()
    var AvailableToDate = String()
    var ActiveInd = Int()
    
    var CategoryID = String()
    var RentPrice = Double()
    var MinRental = Double()
    var DurationUnit = String()
    var DurationUnitDesc = String()
    var ZipCode = Int()
    var userID = Int()
    var userName = String()
    var imageURLS = [String]()
    
    convenience init() {
        self.init(productID: 0, name: kEmptyString, description: kEmptyString, officialUrl: kEmptyString, thumbnailUrl: kEmptyString, category: kEmptyString, location: kEmptyString, availableFromDate: kEmptyString, availableToDate: kEmptyString, activeInd: 0, categoryID:kEmptyString, rentPrice:0.0, minRental:0.0, durationUnit:kEmptyString, durationUnitDesc:kEmptyString, zipCode:0, userID: 0, userName :kEmptyString,imageURLS:[String]())
    }
    
    init(productID:Int, name:String, description:String, officialUrl: String, thumbnailUrl: String, category:String, location:String, availableFromDate:String, availableToDate:String, activeInd:Int, categoryID:String, rentPrice:Double, minRental:Double, durationUnit:String, durationUnitDesc:String, zipCode:Int, userID:Int,userName:String,imageURLS:[String])
    {
        self.ProductID = productID
        self.Name = name
        self.Description = description
        self.OfficialUrl = officialUrl
        self.ThumbnailUrl = thumbnailUrl
        self.Category = category
        self.Location = location
        self.AvailableFromDate = availableFromDate
        self.AvailableToDate = availableToDate
        self.ActiveInd = activeInd
        
        self.CategoryID = categoryID
        self.RentPrice = rentPrice
        self.MinRental = minRental
        self.DurationUnit = durationUnit
        self.DurationUnitDesc = durationUnitDesc
        self.ZipCode = zipCode
        self.userID = userID
        self.userName = userName
        self.imageURLS = imageURLS
    }
}

class SignUp {
    
    var UserEmail = String()
    var Password = String()
    var ConfirmPassword = String()
    var UserName = String()
    var ScreenName = String()
    var PhoneNumber = String()
    
    convenience init() {
        self.init(userEmail: kEmptyString, password: kEmptyString, confirmPassword: kEmptyString, userName: kEmptyString, screenName: kEmptyString, phoneNumber: kEmptyString)
    }
    
    init(userEmail:String, password:String, confirmPassword:String, userName: String, screenName: String, phoneNumber: String)
    {
        self.UserEmail = userEmail
        self.Password = password
        self.ConfirmPassword = confirmPassword
        self.UserName = userName
        self.ScreenName = screenName
        self.PhoneNumber = phoneNumber
    }
}

class Categories {
    
    var categoryID = Int()
    var categoryName = String()
    var categoryDescription = String()
    
    convenience init() {
        self.init(categoryID: 0, categoryName: kEmptyString, categoryDescription: kEmptyString)
    }
    
    init(categoryID:Int, categoryName:String, categoryDescription:String)
    {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryDescription = categoryDescription
    }
}

class OrderList {
    
    var OrderID = Int()
    var ProductID = Int()
    var ProductName = String()
    var RentedFrom = String()
    var RentedFromUserID = Int()
    var IsApproved = Int()
    var ApprovalComments = String()
    var UserID = Int()
    var OwnerName = String()
    var RequestedBy = String()
    var RentPrice = Int()
    var Discounts = Int()
    var RentalStartDate = String()
    var RentalEndDate = String()
    var PickupInstructions = String()
    var Location = String()
    
    convenience init() {
        self.init(orderID: 0, productID: 0, productName: kEmptyString, rentedFrom: kEmptyString, rentedFromUserID: 0, isApproved: 0, approvalComments: kEmptyString, userID: 0, ownerName: kEmptyString, requestedBy: kEmptyString, rentPrice: 0, discounts: 0, rentalStartDate: kEmptyString, rentalEndDate: kEmptyString, pickupInstructions: kEmptyString, location: kEmptyString)
    }
    
    init(orderID:Int, productID:Int, productName:String, rentedFrom:String, rentedFromUserID: Int, isApproved: Int, approvalComments:String, userID:Int, ownerName:String, requestedBy:String, rentPrice:Int, discounts:Int, rentalStartDate:String, rentalEndDate:String, pickupInstructions:String, location:String)
    {
        self.OrderID = orderID
        self.ProductID = productID
        self.ProductName = productName
        self.RentedFrom = rentedFrom
        self.RentedFromUserID = rentedFromUserID
        self.IsApproved = isApproved
        self.ApprovalComments = approvalComments
        self.UserID = userID
        self.OwnerName = ownerName
        self.RequestedBy = requestedBy
        self.RentPrice = rentPrice
        
        self.Discounts = discounts
        self.RentalStartDate = rentalStartDate
        self.RentalEndDate = rentalEndDate
        self.PickupInstructions = pickupInstructions
        self.Location = location
    }
}


class MyproductItem {
    
  
    var availableFromDate = ""
    var availableToDate = ""
    var categoryID = 0
    var categoryName = ""
    var durationUnit = ""
    var durationUnitDesc = ""
    var location = ""
    var minRental = 0.0
    var name = ""
    var pickupInstructions = ""
    var productDesc = ""
    var productID = 0
    var rentPrice = 0.0
    var thumbnailUrl = ""
    var username = ""
    var zipCode = ""
    
    init(availableFromDate: String, availableToDate: String, categoryID : Int, categoryName: String, durationUnit: String, durationUnitDesc: String, location: String, minRental: Double, name: String, pickupInstructions: String, productDesc: String, productID: Int, rentPrice: Double, thumbnailUrl: String, username: String, zipCode : String){
        
           self.availableFromDate = availableFromDate
           self.availableToDate = availableToDate
           self.categoryID = categoryID
           self.categoryName = categoryName
           self.durationUnit = durationUnit
           self.durationUnitDesc = durationUnitDesc
           self.location = location
           self.minRental = minRental
           self.name = name
           self.pickupInstructions = pickupInstructions
           self.productDesc = productDesc
           self.productID = productID
           self.rentPrice = rentPrice
           self.thumbnailUrl = thumbnailUrl
           self.username = username
           self.zipCode = zipCode
        
        
    }
    
}
