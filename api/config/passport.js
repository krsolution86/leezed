//load bcrypt
var bCrypt = require("bcrypt-nodejs");
var jwt = require("jsonwebtoken");
const _ = require("lodash");
const userOps=require('./../controllers/user');
//var env = require("dotenv").config({ path: __dirname + "../../../.env" });

module.exports = function (passport, user) {
    var User = user;
    var LocalStrategy = require("passport-local").Strategy;
    const JWTstrategy = require("passport-jwt").Strategy;
    //We use this to extract the JWT sent by the user
    const ExtractJWT = require("passport-jwt").ExtractJwt;


    /***********Social Auth *************** */




    var FacebookTokenStrategy = require('passport-facebook-token');
    var configAuth = require('./oAuth');


    passport.use('facebook-token', new FacebookTokenStrategy({
        clientID: configAuth.facebookAuth.clientID,
        clientSecret: configAuth.facebookAuth.clientSecret,

    },
        function (token, refreshToken, profile, done) {
            // asynchronous
            process.nextTick(function () {

                var generateHash = function (password) {
                    return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
                };
                // find the user in the database based on their facebook id
                User.findOne({ where: { 'facebookID': profile.id } }).then(

                    function (user) {

                        // if there is an error, stop everything and return that
                        // ie an error connecting to the database

                        // if the user is found, then log them in
                        if (user) {
                            return done(null, user.get()); // user found, return that user
                        } else {
                            // if there is no user found with that facebook id, create them
                            var newUser = {};

                            // set all of the facebook information in our user model




                            var prof = profile._json;
                            newUser.email = prof.email;
                            newUser.password = generateHash("@welcome");
                            newUser.screenName = prof.displayName;
                            newUser.facebookID = prof.id; // set the users facebook id                   
                            newUser.facebookToken = token; // we will save the token that facebook provides to the user                    
                            newUser.facebookName = prof.displayName; // look at the passport user profile to see how names are returned
                            newUser.disclaimerDate = new Date(),
                                newUser.disclaimerVersion = 1
                            // save our user to the database
                            User.create(newUser).then(function (resp, created) {
                                if (!resp) {
                                    return done(null, false);
                                }
                                // const user = resp.get();

                                if (resp) {
                                    userOps.sendUserWelcomeMail(resp.get());
                                    return done(null, resp.get());
                                }
                            }).catch(err => {
                                return done(err, false);
                            });

                        }

                    }).catch(err => {
                        return done(err, false);
                    });
            });

        }

    ));

    ///Google Auth for leezed

    var GoogleStrategy = require( 'passport-google-oauth2' ).Strategy;

passport.use(new GoogleStrategy({

    clientID:    configAuth.googleAuth.clientID,
    clientSecret: configAuth.googleAuth.clientSecret,
  
    passReqToCallback   : false
  },
  function (req, accessToken, refreshToken, profile, done) {

    process.nextTick(function () {

        var generateHash = function (password) {
            return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
        };
        // find the user in the database based on their facebook id
        User.findOne({ where: { 'facebookID': profile.id } }).then(

            function (user) {

                // if there is an error, stop everything and return that
                // ie an error connecting to the database

                // if the user is found, then log them in
                if (user) {
                    return done(null, user.get()); // user found, return that user
                } else {
                    // if there is no user found with that facebook id, create them
                    var newUser = {};

                    // set all of the facebook information in our user model




                    var prof = profile._json;
                    newUser.email = prof.email;
                    newUser.password = generateHash("@welcome");
                    newUser.screenName = prof.displayName;
                    newUser.facebookID = prof.id; // set the users facebook id                   
                    newUser.facebookToken = token; // we will save the token that facebook provides to the user                    
                    newUser.facebookName = prof.displayName; // look at the passport user profile to see how names are returned
                    newUser.disclaimerDate = new Date(),
                        newUser.disclaimerVersion = 1
                    // save our user to the database
                    User.create(newUser).then(function (resp, created) {
                        if (!resp) {
                            return done(null, false);
                        }
                        // const user = resp.get();

                        if (resp) {
                            userOps.sendUserWelcomeMail(resp.get());
                            return done(null, resp.get());
                        }
                    }).catch(err => {
                        return done(err, false);
                    });

                }

            }).catch(err => {
                return done(err, false);
            });
    });


}
));
    // var GoogleOAuth2Strategy = require('passport-google-auth2').Strategy;

    // passport.use('google-oAuth',new GoogleOAuth2Strategy({
    //     clientID: configAuth.googleAuth.clientID,
    //     clientSecret: configAuth.googleAuth.clientSecret,
       
    // },
    //     function (req, accessToken, refreshToken, profile, done) {

    //         process.nextTick(function () {

    //             var generateHash = function (password) {
    //                 return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
    //             };
    //             // find the user in the database based on their facebook id
    //             User.findOne({ where: { 'facebookID': profile.id } }).then(

    //                 function (user) {

    //                     // if there is an error, stop everything and return that
    //                     // ie an error connecting to the database

    //                     // if the user is found, then log them in
    //                     if (user) {
    //                         return done(null, user.get()); // user found, return that user
    //                     } else {
    //                         // if there is no user found with that facebook id, create them
    //                         var newUser = {};

    //                         // set all of the facebook information in our user model




    //                         var prof = profile._json;
    //                         newUser.email = prof.email;
    //                         newUser.password = generateHash("@welcome");
    //                         newUser.screenName = prof.displayName;
    //                         newUser.facebookID = prof.id; // set the users facebook id                   
    //                         newUser.facebookToken = token; // we will save the token that facebook provides to the user                    
    //                         newUser.facebookName = prof.displayName; // look at the passport user profile to see how names are returned
    //                         newUser.disclaimerDate = new Date(),
    //                             newUser.disclaimerVersion = 1
    //                         // save our user to the database
    //                         User.create(newUser).then(function (resp, created) {
    //                             if (!resp) {
    //                                 return done(null, false);
    //                             }
    //                             // const user = resp.get();

    //                             if (resp) {
    //                                 return done(null, resp.get());
    //                             }
    //                         }).catch(err => {
    //                             return done(err, false);
    //                         });

    //                     }

    //                 }).catch(err => {
    //                     return done(err, false);
    //                 });
    //         });


    //     }
    // ));

    /***********End of social Auth Strategies */

    //This verifies that the token sent by the user is valid
    passport.use(
        "jwt-strategy",
        new JWTstrategy(
            {
                //secret we used to sign our JWT
                secretOrKey: process.env.JWT_SECRET,
                //we expect the user to send the token as a query paramater with the name 'secret_token'
                jwtFromRequest: ExtractJWT.fromAuthHeaderAsBearerToken("secret_token")
            },
            async (jwtPayload, done) => {
                //If the token has expiration, raise unauthorized
                // var expirationDate = new Date(jwtPayload.exp * 1000);
                // console.log(expirationDate);
                if (new Date().getTime() > jwtPayload.exp) {
                    return done(null, false);
                }
                var user = jwtPayload;
                return done(null, user);
            }
        ));

    //LOCAL SIGNIN
    passport.use(
        "local-signin",
        new LocalStrategy(
            {  // by default, local strategy uses username and password, we will override with email

                usernameField: "email",
                passwordField: "password",
                passReqToCallback: true // allows us to pass back the entire request to the callback
            },

            function (req, email, password, done) {
                var isValidPassword = function (userpass, password) {
                    return bCrypt.compareSync(password, userpass);
                };
                User.findOne({
                    where: {
                        email: email
                    }
                }).then(function (user) {
                    if (!user) {
                        return done(null, false, {
                            message: "Email does not exist"
                        });
                    }
                    if (!isValidPassword(user.password, password)) {
                        return done(null, false, {
                            message: "Incorrect password."
                        });
                    }
                    var userinfo = user.get();
                    if(userinfo.emailVerified){
                        return done(null, userinfo);
                    }
                    else{
                        return done(null, false, {
                            message: "email not verified"
                        });
                    }
                    // console.log(userinfo);
                   
                })
                    .catch(function (err) {
                        console.log("Error:", err);
                        return done(null, false, {
                            message: "Something went wrong with your Signin"
                        });
                    });
            }
        )
    );
    //LOCAL SIGNUP
    passport.use(
        "local-signup",
        new LocalStrategy(
            {
                usernameField: "email",

                passwordField: "password",

                passReqToCallback: true // allows us to pass back the entire request to the callback
            },
            function (req, email, password, done) {
                console.log(req.body);
                var generateHash = function (password) {
                    return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
                };
                User.findOne({
                    where: {
                        email: email
                    }
                }).then(function (user) {
                    if (user) {
                        return done(null, false, {
                            message: "That email is already taken"
                        });
                    } else {
                        var userPassword = generateHash(password);
                        let token = Math.random(100000, 1000000);
                        var data = {
                            email: email,
                            password: userPassword,
                            name: req.body.name,
                            screenName: req.body.screenName,
                            phone: req.body.phone,
                            emailVerificationToken: token,
                            disclaimerDate: new Date(),
                            disclaimerVersion: 1
                        };
                        // console.log(data);
                        User.create(data).then(function (newUser, created) {
                            if (!newUser) {
                                return done(null, false);
                            }
                            const user = newUser.get();
                            // console.log(user);
                            if (user) {
//send email verification mail with token
userOps.sendNewUserEmail(req,done);
                                return done(null, user);
                            }
                        });
                    }
                });
            }
        )
    );

    //serialize
    passport.serializeUser(function (user, done) {
        done(null, _.pick(user, ["id", "email", "firstname", "lastname"]));
    });

    // deserialize user
    passport.deserializeUser(function (id, done) {
        User.findOne({
            where: {
                email: email
            }
        }).then(function (user) {
            if (user) {
                done(null, user.get());
            } else {
                done(user.errors, null);
            }
        });
    });
};
