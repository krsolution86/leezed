'use strict';
module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    userID: {
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    name: DataTypes.STRING,
    screenName: DataTypes.STRING,
    email: DataTypes.STRING,
    phone: DataTypes.STRING,
    password: DataTypes.STRING,
    isAdmin: { type: DataTypes.BOOLEAN, default: false },
    emailVerificationToken: {
      type: DataTypes.STRING
    },
    emaiVerificationDate: {
      type: DataTypes.DATE
    },
    emailVerified: {
      type: DataTypes.BOOLEAN,
      defaultValue: 0
    },
    passwordResetToken: {
      type: DataTypes.STRING
    },
    disclaimerDate: {
      type: DataTypes.DATE

    },
    disclaimerVersion: {
      type: DataTypes.STRING
    }
  },{freezeTableName: true});




  User.associate = function (models) {
    // associations can be defined here
   

    User.hasMany(models.Address, {
      foreignKey: 'userID',
      sourceKey: 'userID'
    });
  };
  return User;
};