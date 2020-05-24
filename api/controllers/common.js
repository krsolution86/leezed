var db = require('../models');
module.exports = {
  getCategories: function (req, res, next) {

    var category = db.Category;
    category.findAll({
      attributes:['categoryID','name','description'],
      where: {
        activeInd: 1
      }
    })
      //db.query("SELECT * FROM `Product`", { type: sequelize.QueryTypes.SELECT})
      .then(function (cats) {
        return res.status(200).send({
          message: "Categories List..",
          categories: cats,
          count: cats.count,
          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching categories..",
          categories: [],
          count: 0,
          error: err
        });
      })




  },
  getSharedData: function (req, res, next) {

    db.sequelize.query("SELECT CodeID,Code,Description,CodeType,SequenceID FROM `SharedData` p   ", { type: db.sequelize.QueryTypes.SELECT })
      .then((shared) => {
        return res.status(200).send({
          message: "shared data values...",
          sharedData: shared,
          count: shared.count,
          error: null
        });
        // We don't need spread here, since only the results will be returned for select queries
      })


      .catch(err => {
        console.log("Oops! something went fetching products, : ", err);
        return res.status(500).send({
          message: "error fetching shared data values...",
          sharedData: [],
          count: 0,
          error: err

        });

      });
  },

}