'use strict';
module.exports = (sequelize, DataTypes) => {
  const Address = sequelize.define('Address', {
    addressID: {
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    userID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    activeInd:{ type: DataTypes.BOOLEAN, default: true },
    addressLine1: DataTypes.STRING,
    addressLine2: DataTypes.STRING,
    city: DataTypes.STRING,
    state: DataTypes.STRING,
    zipCode: DataTypes.STRING,
    country: { type: DataTypes.STRING, default: 'USA' }   
    
  }, {freezeTableName: true});




  Address.associate = function (models) {
    // associations can be defined here
 

    Address.belongsTo(models.User, {
      foreignKey: 'userID',
      targetKey: 'userID'
    });
  };
  return Address;
};