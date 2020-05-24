var db = require('../models');
const Joi = require('joi');
const userOps=require('./user');
const Sequelize = require('sequelize');

module.exports = {

  placeRentRequest: function (req, res, next) {
    var Order = db.Order;
    const Product = db.Product;
    var data = req.body;
    //validations
    const schema = Joi.object()
      .keys({
        productID: Joi.required(),
        rentPrice: Joi.required(),
        rentalStartDate: Joi.date().required(),
        rentalEndDate: Joi.date().required(),
        rentUnit: Joi.required(),
        rentUnitCount: Joi.required(),
        unitCost: Joi.required()


      }).unknown();
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }

      //check if product available for rent

      //add to orders table
      const placeOrderReq = {
        ...req.body,
        activeInd: 1,
        isApproved: 0,
        userID: req.user.sub.userID

      };
      console.log(placeOrderReq);


      //check product owner
      Product.findOne({
        where: {
          productID: data.productID,
        }
      }).then(resp => {

        if (resp.userID == req.user.sub.userID) {
          return res.send({
            error: false,
            message: "Bad Request,You can not rent your own products!",
            productID: placeOrderReq.productID,
            orderID: placeOrderReq.orderID

          });
        }
      })
        .catch(err => {
          return res.send({
            error: err,
            message: "Internal Error checking product",
            productID: placeOrderReq.productID,
            orderID: placeOrderReq.orderID

          });
        });


      Order
        .create(placeOrderReq)
        .then(function (newOrder) {
          if (newOrder) {

            userOps.rentRequestRecievedMail(newOrder);
            return res.send({
              error: false,
              message: "Order placed",
              orderID: newOrder.orderID
            });
          }
          else {
            return res.send({
              error: null,
              message: "Order not place,please check!",
              orderID: null
            });
          }
        })
        .catch(function (err) {
          console.log("Oops! something went wrong, : ", err);
          return res.status(500).send({
            error: err,
            message: "Oops! something went wrong placing order!",
            orderID: null
          });

        });

    });
  },

  processRentRequest: function (req, res, next) {
    var Order = db.Order;

    var data = req.body;
    //validations
    const schema = Joi.object()
      .keys({
        productID: Joi.required(),
        orderID: Joi.required(),
        isApproved: Joi.required(),
        approvalComments: Joi.required()



      }).unknown();
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }

      //check if product available for rent
      var loginUserID = req.user.sub.userID;
      //add to orders table
      const placeOrderReq = {
        ...req.body,

        userID: loginUserID

      };
      console.log(placeOrderReq);



      //if not product owner then place rent request
      Order.update(
        {
          isApproved: placeOrderReq.isApproved,
          approvalComments: placeOrderReq.approvalComments,
          approvalDate: new Date()
        },
        { where: { orderID: placeOrderReq.orderID, productID: placeOrderReq.productID } })

        .then(function (rows) {
          if (rows[0] > 0) {
            return res.send({
              error: false,
              message: "Order status updated!",
              productID: placeOrderReq.productID,
              orderID: placeOrderReq.orderID

            });
          }
          else {
            return res.send({
              error: false,
              message: "Order status not updated, please check!",
              productID: placeOrderReq.productID,
              orderID: placeOrderReq.orderID
            });
          }
        })
        .catch(function (err) {
          console.log("Oops! something went wrong, : ", err);
          return res.status(500).send({
            error: err,
            message: "Oops! something went wrong updating order!",
            productID: placeOrderReq.productID,
            orderID: placeOrderReq.orderID
          });

        });

    });
  },


  getMyOrders: function (req, res, next) {

    const userID = req.user.sub.userID;
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
  fetchChatHistory: function (req, res, next) {

    const userID = req.user.sub.userID;
    const orderID = req.query.orderID;
    const Chat = db.Chat;
    Chat.findAll({
      where: {
        orderID: orderID,
        activeInd: '1'
      }
    })
      .then(resp => {
        console.log(resp);
        return res.status(200).send({
          message: "Chat history fecth Ok!",
          chatHistory: resp,
          error: null
        });

      })
      .catch(err => {
        console.log(err);
        return res.status(500).send({
          message: "Error fetching  chat hisitory",
          error: err
        });
      });

  },

  postChatMessage: function (req, res, next) {
    var Order = db.Order;
const Product=db.Product;
    var data = req.body;
    //validations
    const schema = Joi.object()
      .keys({
        productID: Joi.required(),
        orderID: Joi.required(),
        message: Joi.required(),
        fromUserID:Joi.required(),
        toUserID:Joi.required()

      }).unknown();
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }

      const postChatRequest = {
        ...req.body
      };
      console.log(postChatRequest);


      //send chat message



      db.sequelize
        .query('CALL postChatMessage (:orderID,:productID,:fromUserID,:toUserID,:message)',
          {
            replacements: {
              orderID: postChatRequest.orderID,
              productID: postChatRequest.productID,
              fromUserID: postChatRequest.fromUserID,
              toUserID: postChatRequest.toUserID,
              message: postChatRequest.message
            }
          })

        .then(function (prods) {
          console.log(prods);
          return res.status(200).send({
            message: "Message sent!",
            error: null
          });

        }).catch(err => {

          console.log(err.message);

          return res.status(500).send({
            message: "Error sending message",
            error: err
          });
        });
  

    });
  },


  // getMyOrders: function (req, res, next) {
  //   const userID= req.user.sub.userID;
  //   console.log(userID);
  //   db.sequelize.query("select * from `order`  where   activeInd=1 and userID="+userID+ " order by createdAt desc", { type: db.sequelize.QueryTypes.SELECT })
  //     .then((orders) => {
  //       return res.status(200).send({
  //         message: "order list",
  //         orders: orders,
  //         count: orders.count,
  //         error:null
  //       });

  //     })
  //     .catch(err => {
  //       console.log("Oops! something went fetching products, : ", err);
  //       return res.status(200).send({
  //         message: "Error",
  //         orders: [],
  //         count: 0,
  //         error:err
  //       });
  //     });
  // },

}