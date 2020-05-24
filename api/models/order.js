'use strict';
module.exports = (sequelize, DataTypes) => {
  const Order = sequelize.define('Order', {   
    orderID: { autoIncrement: true,  primaryKey: true,  type: DataTypes.INTEGER },
    productID: {   type: DataTypes.INTEGER ,allowNull: false },    
    userID: { type: DataTypes.INTEGER, allowNull: false    },
//fields required from the person renting
    rentUnit: { type: DataTypes.STRING, allowNull: false    },
    rentUnitCount:  { type: DataTypes.DOUBLE, allowNull: false    },
    unitCost : { type: DataTypes.DOUBLE, allowNull: false    },    
    rentPrice: { type: DataTypes.DOUBLE, allowNull: false    }, 
    rentalStartDate:{ type:DataTypes.DATE ,allowNull:false},
    rentalEndDate:{ type:DataTypes.DATE ,allowNull:false},
    discounts:DataTypes.DOUBLE,
//fields for product owner
    isApproved: { type: DataTypes.BOOLEAN, default:'0'    },
    approvalDate:{ type:DataTypes.DATE },
    approvalComments:{ type:DataTypes.STRING },
    pickupInstructions :{ type:DataTypes.STRING },  
  
  
  
    activeInd: { type: DataTypes.BOOLEAN, default: '1' }
  },{freezeTableName: true});



  




 


  Order.associate = function (models) {
    // associations can be defined here
    // Product.belongsTo(models.CostManager, {
    //   foreignKey: 'costManagerID',
    //   sourceKey: 'costManagerID'
    // });

    Order.belongsTo(models.Product, {foreignKey: 'productID', 
      sourceKey: 'productID'});

      Order.belongsTo(models.User, {foreignKey: 'userID', 
      sourceKey: 'userID'});
  };
  return Order;
};