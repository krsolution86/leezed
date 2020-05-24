var db = require('./../models');
const Joi = require('joi');
const jwt = require("jsonwebtoken");
var passport = require('passport');
const _ = require('lodash');
//sign the jwt
const signToken = user => {
  return jwt.sign(
    {
      iss: "leezed@shertech",
      sub: _.pick(user, ["userID", "name", "email", "screenName", "phone"]),
      iat: new Date().getTime(),
      exp: new Date().setDate(new Date().getDate() + 1)
    },
    process.env.JWT_SECRET
  );
};

module.exports = {
  signUp: function (req, res, next) {
    // fetch the request data
    const data = req.body;
    console.log(req.body);
    //console.log(req.body);
    // define the validation schema
    const schema = Joi.object()
      .keys({
        // email is required
        // email must be a valid email string
        email: Joi.string()
          .email()
          .required(),

        // phone is required
        // and must be a string of the format XXX-XXX-XXXX
        // where X is a digit (0-9)
        //phone: Joi.string().regex(/\(?\+[0-9]{1,3}\)? ?-?[0-9]{1,3} ?-?[0-9]{3,5} ?-?[0-9]{4}( ?-?[0-9]{3})? ?(\w{1,10}\s?\d{1,6})?/),

        //password is required
        password: Joi.required()
      })
      .unknown();

    // console.log(IsValidRequest(data, schema));
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }
      passport.authenticate(
        "local-signup",
        { session: false },
        async (err, newUser, info) => {
          try {
            if (err) {
              const error = new Error("An Error occured");
              console.log(error.message);
              return next(error.message);
            }
            //user is null that means user alrady exists at the time of signup
            if (!newUser) {
              const error = new Error(info.message);
              console.log(error.message);
              return res.status(401).send({ errorMsg: error.message });
            }
            req.login(newUser, { session: false }, async error => {
              if (error) return next(error);
              // console.log(newUser.email);
              //Sign the JWT token and populate the payload with the user email and id
              const token = signToken(newUser);
              //Send back the token to the user    
              return res.json({ message: "sign up successful!", authToken: 'VRF' });
            });
          } catch (error) {
            return next(error);
          }
        }
      )(req, res, next);
    });
  },

  signIn: function (req, res, next) {

    // fetch the request data
    const data = req.body;
    //console.log(data);
    // define the validation schema
    const schema = Joi.object().keys({
      // email is required
      // email must be a valid email string
      email: Joi.string()
        .email()
        .required(),

      //password is required
      password: Joi.string()
        .not("")
        .required()
    });

    if (IsValidRequest(data, schema)) {
      passport.authenticate(
        "local-signin",
        { session: false },
        async (err, user, info) => {
          try {
            if (err) {
              const error = new Error("An Error occured");
              return next(error.message);
            }
            if (!user) {
              const error = new Error("Invalid username  or password!");
              return res.status(401).send({ errorMsg: error.message });
              // return next(error.message);
            }
            req.login(user, { session: false }, async error => {
              if (error) return res.status(401).send({ errorMsg: error.message });//return next(error.message);

              //Sign the JWT token and populate the payload with the user email and id
              //console.log(user);
              const token = signToken(user);

              return res.json({ message: "sign in successful!", authToken: token });
            });
          } catch (error) {
            return res.status(500).send({ errorMsg: error.message });
            // return next(error.message);
          }
        }
      )(req, res, next);
    } else {
      return res.status(400).send("Bad Request!");
    }

  },

  signInWithFacebook: async (req, res, next) => {
    // fetch the request data
    const token = req.body;
    console.log(req.body);
    // define the validation schema

    passport.authenticate('facebook-token', { session: false },
      async (err, newUser, info) => {
        try {
          if (err) {
            const error = new Error("An Error occured");
            console.log(error.message);
            return next(error.message);
          }
          //user is null that means user alrady exists at the time of signup
          if (!newUser) {
            const error = new Error(info.message);
            console.log(error.message);
            return res.status(401).send({ errorMsg: error.message });
          }
          req.login(newUser, { session: false }, async error => {
            if (error) return next(error);
            // console.log(newUser.email);
            //Sign the JWT token and populate the payload with the user email and id
            const token = signToken(newUser);
            //Send back the token to the user

            return res.json({ authToken: token });
          });
        } catch (error) {
          return next(error);
        }
      }
    )(req, res, next);
  },


  signInWithGoogle: async (req, res, next) => {
    // fetch the request data
    const token = req.body;
    console.log(req.body);
    // define the validation schema
    passport.authenticate('google-oAuth', { session: false },
      async (err, newUser, info) => {
        try {
          if (err) {
            const error = new Error("An Error occured");
            console.log(error.message);
            return next(error.message);
          }
          //user is null that means user alrady exists at the time of signup
          if (!newUser) {
            const error = new Error(info.message);
            console.log(error.message);
            return res.status(401).send({ errorMsg: error.message });
          }
          req.login(newUser, { session: false }, async error => {
            if (error) return next(error);
            // console.log(newUser.email);
            //Sign the JWT token and populate the payload with the user email and id
            const token = signToken(newUser);
            //Send back the token to the user

            return res.json({ authToken: token });
          });
        } catch (error) {
          return next(error);
        }
      }
    )(req, res, next);
  },



  refreshToken: function (req, res, next) {


  },

  saveAddress: function (req, res, next) {
    const data = req.body;
    console.log(req.body);
    const loggedInUserID = req.user.sub.userID;
    console.log(req.user);
    // define the validation schema
    const schema = Joi.object()
      .keys({
        // email is required
        // email must be a valid email string
        addressLine1: Joi.string()
          .required(),
        city: Joi.string()
          .required(),
        state: Joi.string()
          .required(),
        zipCode: Joi.string()
          .required(),
        country: Joi.string()
          .required()


      })
      .unknown();

    // console.log(IsValidRequest(data, schema));
    Joi.validate(data, schema, (error, value) => {
      if (error) {
        console.log(error.message);
        return res.status(400).send(error.message);
      }
      //save the address (create if no adress Id in body and update if id exists)
      const addressSaveRequest = {
        ...req.body,
        userID: loggedInUserID
      };
      const Address = db.Address;
      if (addressSaveRequest.addressID != null && addressSaveRequest.addressID != undefined) {
        //create new lawn
        Address
          .update({
            activeInd: addressSaveRequest.activeInd,
            addressLine1: addressSaveRequest.addressLine1,
            addressLine2: addressSaveRequest.addressLine2,
            city: addressSaveRequest.city,
            state: addressSaveRequest.state,
            zipCode: addressSaveRequest.zipCode,
            country: addressSaveRequest.country

          },
            { where: { addressID: addressSaveRequest.addressID, } })
          .then(function (rows) {
            console.log("jasshdkjhsakhd");
            if (rows[0] > 0) {
              return res.send({
                error: false,
                message: "address updated!",
                address: addressSaveRequest
              });
            }
            else {
              return res.send({
                error: false,
                message: "address not updated, please check!"
              });
            }
          })
          .catch(function (err) {
            console.log("Oops! something went wrong, : ", err);
            return res.status(500).send({
              error: err,
              message: "Oops! something went wrong updating address!",
              address: addressSaveRequest
            });

          });
      }
      else {
        //create new address
        Address
          .create(addressSaveRequest)
          .then(function (newAddress) {
            if (newAddress) {
              return res.send({
                error: false,
                message: "address saved!",
                addressID: newAddress.addressID
              });
            }
            else {
              return res.send({
                error: false,
                message: "address not saved, please contact support!"
              });
            }
          })
          .catch(function (err) {
            return res.status(500).send({
              error: err,
              message: "Oops! something went wrong saving address!",
              address: addressSaveRequest
            });
            console.log("Oops! something went wrong, : ", err);
          });
      }





    });
  },


  fetchZipDetails: async (req, res, next) => {

    var zipcode = req.query.zipcode;

    var zipcodes = db.zip_codes_usa;

    zipcodes.findOne({
      where: {
        zip: zipcode,
      },
    }).then(details => {
      res.send({ ZipCode: zipcode, City: details.primary_city, State: details.state, Country: details.country, lat: details.latitude, lon: details.longitude });

    }).catch((err) => {
      res.send({ message: "an error occured fetching zip details", error: err });

    });

  }

}
function IsValidRequest(data, schema) {
  const { error, value } = Joi.validate(data, schema);
  //console.log(error);
  if (error) {
    return false;
  }
  return value;
}

