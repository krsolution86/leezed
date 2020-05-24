'use strict';
module.exports = (sequelize, DataTypes) => {
  const Chat = sequelize.define('Chat', {   
    chatID: { autoIncrement: true,  primaryKey: true,  type: DataTypes.INTEGER },
    orderID: {  type: DataTypes.INTEGER,allowNull: false  },
    productID: {   type: DataTypes.INTEGER ,allowNull: false },    
    fromUserID: { type: DataTypes.INTEGER, allowNull: false    },
//fields required from the person renting
    toUserID: { type: DataTypes.STRING, allowNull: false    }, 
    message :{ type:DataTypes.STRING },  
    activeInd: { type: DataTypes.BOOLEAN, default: '1' }
  },{freezeTableName: true,  timestamps: true});



  




 


  Chat.associate = function (models) {
  
  };
  return Chat;
};