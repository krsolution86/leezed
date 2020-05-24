'use strict';
module.exports = (sequelize, DataTypes) => {
  const ProductIndex = sequelize.define('ProductIndex', {   
    productID: { autoIncrement: true,  primaryKey: true,  type: DataTypes.INTEGER },
    productName: { type: DataTypes.STRING, allowNull: false    },
    productDesc: DataTypes.STRING,
    categoryID: DataTypes.INTEGER ,
    imageUrls:DataTypes.STRING,
    categoryName: DataTypes.STRING ,
    ownerID: { type: DataTypes.INTEGER, allowNull: false    },
    ownerName: { type: DataTypes.STRING, allowNull: false    },
    rentPrice: DataTypes.DOUBLE ,
    durationUnit:DataTypes.STRING,
    durationUnitDesc:DataTypes.STRING,
    minRental:{ type: DataTypes.INTEGER, default: 1 },
    city:DataTypes.STRING,
    state:DataTypes.STRING,
    location: DataTypes.STRING,
    zipCode:DataTypes.INTEGER,
    pickupInstructions: DataTypes.STRING,
    officialurl:DataTypes.STRING,    
    availableFromDate:{ type:DataTypes.DATE ,allowNull:false},
    availableToDate: DataTypes.DATE,
    activationDate:{ type:DataTypes.DATE ,allowNull:false},
    activeInd: { type: DataTypes.BOOLEAN, default: true }
  },{freezeTableName: true});




 


  ProductIndex.associate = function (models) {
   
  };
  return ProductIndex;
};