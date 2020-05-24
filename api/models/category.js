'use strict';
module.exports = (sequelize, DataTypes) => {
  const Category = sequelize.define('Category', {
    categoryID: {
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    activeInd: { type: DataTypes.BOOLEAN, default: true },
    description: DataTypes.STRING

  },{ freezeTableName: true,});
  Category.associate = function (models) {    
    
  };
  return Category;
};