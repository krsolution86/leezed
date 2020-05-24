module.exports = function (sequelize, Sequelize) {
  var zip_codes_usa = sequelize.define(
    "zip_codes_usa",
    {
      id: {
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      zip: {

        type: Sequelize.STRING
      },
      type: {
        type: Sequelize.STRING,

      },
      decommissioned: {
        type: Sequelize.INTEGER,

      },
      primary_city: {
        type: Sequelize.STRING,

      },
      acceptable_cities: {
        type: Sequelize.STRING,

      },
      unacceptable_cities: {
        type: Sequelize.STRING,

      },
      state: {
        type: Sequelize.STRING,

      },
      county: {
        type: Sequelize.STRING,

      },
      timezone: {
        type: Sequelize.STRING,

      },
      area_codes: {
        type: Sequelize.STRING,

      },
      world_region: {
        type: Sequelize.STRING,

      },
      country: {
        type: Sequelize.STRING,

      },
      latitude: {
        type: Sequelize.DOUBLE,

      },
      longitude: {
        type: Sequelize.DOUBLE,

      },
      irs_estimated_population_2015: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
    },
    {
      timestamps: false,
      freezeTableName: true,
    }
  );

  return zip_codes_usa;
};
