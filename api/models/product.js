'use strict';
module.exports = (sequelize, DataTypes) => {
  const Product = sequelize.define('Product', {   
    productID: { autoIncrement: true,  primaryKey: true,  type: DataTypes.INTEGER },
    name: { type: DataTypes.STRING, allowNull: false    },
    description: DataTypes.STRING,
    categoryID: DataTypes.INTEGER ,
    userID: { type: DataTypes.INTEGER, allowNull: false    },
    rentPrice: DataTypes.DOUBLE ,
    durationUnit:DataTypes.STRING,
    minRental:{ type: DataTypes.INTEGER, default: 1 },
    city:DataTypes.STRING,
    state:DataTypes.STRING,
    location: DataTypes.STRING,
    zipCode:DataTypes.STRING,
    pickupInstructions: DataTypes.STRING,
    officialurl:DataTypes.STRING,
    availableFromDate:{ type:DataTypes.DATE ,allowNull:false},
    availableToDate: DataTypes.DATE,
    activeInd: { type: DataTypes.BOOLEAN, default: true }
  },{freezeTableName: true});




 


  Product.associate = function (models) {
    // associations can be defined here
    // Product.belongsTo(models.CostManager, {
    //   foreignKey: 'costManagerID',
    //   sourceKey: 'costManagerID'
    // });

    Product.belongsTo(models.Category, {foreignKey: 'categoryID', 
      sourceKey: 'categoryID'});

      Product.belongsTo(models.User, {foreignKey: 'userID', 
      sourceKey: 'userID'});
  };
  return Product;
};