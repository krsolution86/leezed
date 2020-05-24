module.exports = function(sequelize, Sequelize) {
  var SharedData = sequelize.define(
    "SharedData",
    {
      CodeID: {
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      Code: {
        type: Sequelize.STRING,
        allowNull: false
      },
      Description: {
        type: Sequelize.STRING,
        allowNull: false
      },
      CodeType: {
        type: Sequelize.STRING,
        allowNull: false
      },
      SequenceID: {
        type: Sequelize.INTEGER
        
      }
    },
    {
      timestamps: false,
      freezeTableName: true
    }
  );

  return SharedData;
};
