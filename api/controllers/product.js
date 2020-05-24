var db = require('./../models');
const Joi = require('joi');

const Sequelize = require('sequelize');
const Op = Sequelize.Op;
var elasticsearch = require('elasticsearch');
const host=process.env.ELASTIC_LOCAL_HOST;
//elastic search logic
var client = new elasticsearch.Client({
  host:    ['http://localhost:9200'],
});
//test the elastic search connection 
client.ping({
  requestTimeout: 30000,
}, function (error) {
  if (error) {
    console.error('elasticsearch cluster is down!');
  } else {
    console.log('Everything is ok');
  }
});


function SerachProductsFromES(qTerms,geoLocation) {
  if(geoLocation && geoLocation.lat && geoLocation.lan){

  }
  else{
    geoLocation.lat= 18.07982;
    geoLocation.lan=-66.94274;
  }


  return client.search({
    index: 'products',
    type: '_doc',
    body: {
      size: 20,
    //   "query": {
    //     "match_all": { "boost" : 1.2 }
    // }

    
      "query": {
          "bool": {
              "must": {
                  "match_all": {}
              },
              "filter": {
                  "geo_distance": {
                      "distance": "32km",
                      "geo_loc.location": [
                        geoLocation.lat,  geoLocation.lan
                      ]
                  }
              }
          }
      }
  

  //   "query": {
  //     "bool" : {
  //         "must" : {
  //           multi_match: {
  //             query: qTerms,
  //              fields: ["name^4", "description^2"]
  //            }
  //         },
        
  //         "filter" : {
  //             "geo_distance" : {
  //               "distance" : "10km",
  //               "geo_loc.location":[  geoLocation.lat,  geoLocation.lan]
  //             }
  //         }
  //     }
  // }
    //   query: {
    //     multi_match: {
    //       query: qTerms,
    //       fields: ["name^4", "description^2"]
    //     }
    //   }
     }
  });
}

const paginate = (query, { page, pageSize }) => {
  const offset = page * pageSize;
  const limit = offset + pageSize;

  return {
    ...query,
    offset,
    limit,
  };
};

module.exports = {

  createProduct: function (req, res, next) {
    var Product = db.Product;
    var data = req.body;
    //validations
    const schema = Joi.object()
      .keys({


        name: Joi.string().required(),
        description: Joi.string().required(),
        rentPrice: Joi.required(),
        durationUnit: Joi.required(),
        categoryID: Joi.required(),
        location: Joi.string().required(),
       // pickupInstructions: Joi.string().required(),
        zipCode: Joi.number().required(),
        availableFromDate: Joi.date().required(),
        availableToDate: Joi.date().required()
      }).unknown();
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }
      const saveProductReq = {
        ...req.body,
        userID: req.user.sub.userID

      };
      console.log(saveProductReq);
      Product
        .create(saveProductReq)
        .then(function (newProd) {
          if (newProd) {

            return res.send({
              error: false,
              message: "new product added!",
              productID: newProd.productID
            });
          }
          else {
            return res.send({
              error: null,
              message: "new product  not added, please check!",
              productID: null
            });
          }
        })
        .catch(function (err) {
          console.log("Oops! something went wrong, : ", err);
          return res.status(500).send({
            error: err,
            message: "Oops! something went wrong saving Product details!",
            productID: null
          });

        });

    });
  },

  updateProduct: function (req, res, next) {
    var Product = db.Product;
    var data = req.body;
    //validations
    const schema = Joi.object()
      .keys({
        name: Joi.string().required(),
        description: Joi.string().required(),
        rentPrice: Joi.required(),
        durationUnit: Joi.required(),
        categoryID: Joi.required(),
        location: Joi.string().required(),
        pickupInstructions: Joi.string().required(),
        zipCode: Joi.number().required(),
        availableFromDate: Joi.date().required(),
        availableToDate: Joi.date().required()
      }).unknown();
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }
      //pick userid from token and apply to lawnuserid
      const saveProductReq = {
        ...req.body,
        userID: req.user.sub.id

      };
      console.log(saveProductReq);

      Product
        .update({

          name: saveProductReq.name,
          description: saveProductReq.description,
          rentPrice: saveProductReq.rentPrice,
          durationUnit: saveProductReq.durationUnit,
          categoryID: saveProductReq.categoryID,
          location: saveProductReq.location,
          zipCode: saveProductReq.zipCode,
          pickupInstructions: saveProductReq.pickupInstructions,
          availableFromDate: saveProductReq.availableFromDate,
          availableToDate: saveProductReq.availableToDate,
          activeInd: saveProductReq.activeInd
        },
          { where: { productID: saveProductReq.productID, } })
        .then(function (rows) {

          if (rows[0] > 0) {
            return res.send({
              error: false,
              message: "product updated!",
              productID: saveProductReq.productID
            });
          }
          else {
            return res.send({
              error: false,
              message: "Product details not saved, please check!",
              productID: saveProductReq.productID
            });
          }
        })
        .catch(function (err) {
          console.log("Oops! something went wrong, : ", err);
          return res.status(500).send({
            error: err,
            message: "Oops! something went wrong saving Product details!",
            productID: saveProductReq.productID
          });

        });

    });
  },


  addProductToLiveListings: function (req, res) {
      const data=req.body;
      const userID= req.user.sub.userID;
      const schema = Joi.object()
      .keys({
        productID: Joi.required(),
        imageUrls: Joi.required()
        
      }).unknown();
        Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }

    db.sequelize.query('CALL markProductAsAvailable (:productID,:userID,:imageUrls,:activationDate)',
    { replacements: {productID :data.productID,userID: userID,imageUrls:data.imageUrls,activationDate:new Date()  } })
      .then(function (prod) {
        console.log(prod);
        return res.status(200).send({
          message: "Product live at Leezed for renting",
          productID: data.productID,

          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error adding to Live List at Leezed!",
          productID: data.productID,

          error: err
        });
      })
    });
  },



  deleteProduct: function (req, res, next) {

  },

  getMyOrders: function (req, res, next) {
    
    const userID= req.user.sub.userID;
    db.sequelize
      .query('CALL getRentedItemsByUserID (:userID)',
        { replacements: { userID: userID } })
      //db.query("SELECT * FROM `Product`", { type: sequelize.QueryTypes.SELECT})
      .then(function (prods) {
        console.log(prods);
        return res.status(200).send({
          message: "Order List Fetch Successfull..",
          myOrders: prods,
          count: prods.count,
          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching my Orders..",
          myOrders: [],
          count: 0,
          error: err
        });
      })
  },

  getProductBySearchTerm: function (req, res, next) {
    var qTerms = req.query.searchTerms;
    var zipCode = req.query.zipCode;
    //if no search terms then  return from default location 
    if (qTerms == null || qTerms == "") {
      return res.status(400).send({
        message: "bad request, no search term",
        products: [],
        count: 0
      });
    }


    console.log(qTerms);

    db.sequelize
      .query('CALL SearchProducts (:searchTerm, :zipCode)',
        { replacements: { searchTerm: qTerms, zipCode: zipCode } })
      //db.query("SELECT * FROM `Product`", { type: sequelize.QueryTypes.SELECT})
      .then(function (prods) {
        console.log(prods);
        return res.status(200).send({
          message: "Product List Fetch Successfull..",
          products: prods,
          count: prods.count,
          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching product list..",
          products: [],
          count: 0,
          error: err
        });
      })

    // var Product = db.Product;
    // Product.findAll({
    //   where: {
    //     name:{[Op.like]: '%'+qTerms},
    //   }
    // })
    // //db.query("SELECT * FROM `Product`", { type: sequelize.QueryTypes.SELECT})
    // .then(function(prods) {
    //   return res.status(200).send({
    //     message: "Product List Fetch Successfull..",
    //     products: prods,
    //     count: prods.count,
    //     error: null
    //   });

    // }).catch(err=>{

    //   console.log(err.message);

    //   return res.status(500).send({
    //     message: "Error fetching product list..",
    //     products: [],
    //     count: 0,
    //     error: err
    //   });
    // })




  },

  searchProducts: function (req, res, next) {
    var qTerms = req.query.searchTerms;
    var lat=parseFloat(req.query.lat);
    var lan=parseFloat(req.query.lan);
  
    //if no search terms then  return from default location 
    // if (qTerms == null || qTerms == "") {
    //   return res.status(400).send({
    //     message: "bad request, no search term",
    //     products: [],
    //     count: 0

    //   });
    // }




    SerachProductsFromES(qTerms,{lat,lan})
      .then(function (resp) {

        console.log(resp.hits.total);
        //return source list of products
        var products = resp.hits.hits.map(x => x._source);

        return res.status(200).send({
          message: "Product List Fetch Successfull..",
          products: products,
          count: products.count,
          error: null
        });


      }, function (err) {
        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching product list..",
          products: [],
          count: 0,
          error: err
        });

      });






  },

  getUserProducts: function (req, res, next) {

    page=1;
    pageSize=1;
    db.sequelize.query("select p.productID,p.name,p.description, p.categoryID, c.name as CategoryName,  p.zipCode,p.rentPrice,p.durationUnit,  p.location,p.pickupInstructions, p.officialurl,  p.availableFromDate,p.availableToDate,p.activeInd  FROM `product` p inner  join `category` c on p.categoryID=c.categoryID  where p.userID=" + userID + " and p.activeInd=1 ",
    
 
    { type: db.sequelize.QueryTypes.SELECT })


      .then((products) => {
        return res.status(200).send({
          message: "product list",
          products: products,
          count: products.count
        });

      })
      .catch(err => {
        console.log("Oops! something went fetching products, : ", err);
        return res.status(500).send(err);
      });
  },


  getAllProducts: function (req, res, next) {

    db.sequelize.query("SELECT p.productID,p.name,p.description,p.categoryID,c.name as CategoryName,c.description as CategoryDesc,p.location,p.pickupInstructions,  p.availableFromDate,p.availableToDate,p.activeInd FROM `products` p join `categories` c on p.categoryID=c.categoryID where p.activeInd=1 and c.activeInd=1 and order by createdDate desc ", { type: db.sequelize.QueryTypes.SELECT 
    
  
    })
      .then((products) => {
        return res.status(200).send({
          message: "product list",
          products: products,
          count: products.count
        });

      })
      .catch(err => {
        console.log("Oops! something went fetching products, : ", err);
        return res.status(500).send(err);
      });
  },


  getProductById: function (req, res, next) {
    var id = req.query.id;
    var Product = db.Product;
    Product.findOne({
      where: {
        productID: id
      }
    })
      //db.query("SELECT * FROM `Product`", { type: sequelize.QueryTypes.SELECT})
      .then(function (prods) {
        return res.status(200).send({
          message: "Product Details..",
          product: prods,

          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching product details..",
          product: {},

          error: err
        });
      })
  },
  //method to get product details for view only should contain all description fields with IDs which will be used for display
  getProductViewModel: function (req, res) {
    var id = req.query.productID;
    db.sequelize.query("SELECT p.productID,p.name,p.description,p.rentPrice,p.durationUnit,p.minRental,p.location, p.availableFromDate,p.availableToDate,sd.description as durationUnitDesc,c.name as categoryName,u.screenName as username,p.userID as ownerID  FROM product p inner join category c on p.categoryID=c.categoryID inner join user u on p.userID=u.userID inner join shareddata sd on p.durationUnit=sd.Code where p.productID=" + id + "", { type: Sequelize.QueryTypes.SELECT })
      .then(function (prod) {
        return res.status(200).send({
          message: "Product View Model for rentscreen",
          product: prod,

          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching product details..",
          product: {},

          error: err
        });
      })
  },
  getMyItems: function (req, res) {
      
    const userID= req.user.sub.userID;
    db.sequelize.query('CALL getMyItems (:userID)',
    { replacements: { userID: userID } })
      .then(function (prod) {
        return res.status(200).send({
          message: "My added product list",
          myItems: prod,

          error: null
        });

      }).catch(err => {

        console.log(err.message);

        return res.status(500).send({
          message: "Error fetching product list..",
          myItems: [],

          error: err
        });
      })
  }



}