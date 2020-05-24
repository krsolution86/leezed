var db = require('./../models');
var _ = require('lodash');
var bCrypt = require("bcrypt-nodejs");
const nodemailer = require('nodemailer');
var db = require('./../models');
const Joi = require("joi");
const templateDir = __dirname + './../public/templates';
function generateHash(password) {
    return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
};

function UpdateUser(generateHash, data, user, users, res) {
    var Password = generateHash(data.newPassword);
    console.log("password hash", Password);
    console.log(user.userID);
    return users
        .update({
            password: Password,
        }, { where: { userID: user.userID, } });
}
function IsValidRequest(data, schema) {
    const { error, value } = Joi.validate(data, schema);
    //console.log(error);
    if (error) {
        return false;
    }
    return value;
}

const transporter = nodemailer.createTransport({

    host: 'smtp.gmail.com',
    provider: 'gmail',
    port: 465,
    secure: true,
    auth: {
        user: 'abhishekdxt3@gmail.com ', // Enter here email address from which you want to send emails
        pass: 'vesdnalrcndvftqb ' // Enter here password for email account from which you want to send emails
    },
    tls: {
        rejectUnauthorized: false
    }
});

module.exports = {


    modifyUser: async (req, res, next) => {
        const data = req.body;
        const userID = req.user.sub.userID;

        console.log(data);
        // define the validation schema
        const schema = Joi.object().keys({

            name: Joi.string().not("").required(),
            screenName: Joi.string().not("").required(),
            email: Joi.string().not("").required(),


            phone: Joi.string().not("").required()
        }).unknown();
        //validate Request withJOI
        if (IsValidRequest(data, schema)) {

            db.User
                .update({

                    email: data.email,

                    name: data.name,
                    screenName: data.screenName,
                    phone: data.phone

                },
                    { where: { userID: userID } })
                .then(function (rows) {

                    if (rows[0] > 0) {

                        return res.send({
                            error: false,
                            message: "User updated!",
                            userID: userID
                        });
                    }
                    else {
                        return res.send({
                            error: false,
                            message: "User details not saved, please check!",
                            userID: userID
                        });
                    }
                })
                .catch(function (err) {
                    console.log("Oops! something went wrong, : ", err);
                    return res.status(500).send({
                        error: err,
                        message: "Oops! something went wrong saving User details!",
                        userID: userID
                    });

                });
        } else {
            return res.status(400).send("Bad Request!");
        }

    }
    ,

    /***new user block */
    sendNewUserEmail: function (req) {

        let senderName = req.body.screenName;
        let senderEmail = req.body.email;
        let messageSubject = "Verify your email for Leezed.com!";
        let messageText = "Welcome " + senderName + "!<br/> you new account has been created with below details:<br/> Email:" + senderEmail + "<br> Phone:" + req.body.email + "<br> Zip:" + req.body.zip;
        let copyToSender = 'abdixit@shertechinfo.com';

        db.User.findOne({
            where: {
                email: senderEmail,
            },
        }).then(user => {
            let token = user.emailVerificationToken;
            console.log(token);
            let mailOptions = {
                to: [senderEmail], // Enter here the email address on which you want to send emails from your customers http://52.55.210.169/verification
                from: "Leezed Customer Service",
                subject: messageSubject,
                html: `<img src="cid:116@nodemailer.com"/><br/><br/> 
            
            Dear user,<br/>
            Your email `+ 'abc' + ` was used to sign up at Leezed on ` + (new Date()) + `. Please please click <a href=" http://3.226.150.129/verification?token=` + token + `">here</a> to confirm your email.
            <br/>Did not sign up? click <a href=" https://leezed.com/contactus">here</a> to let us know.<br/>
           <br/><br/> Warm Regards,<br/><b>Leezed Customer Service</b>  `,
                attachments: [{
                    filename: 'welcome.png',
                    path: __dirname + './../assets/leezed.png',
                    cid: '116@nodemailer.com' //same cid value as in the html img src
                }],
            };

            transporter.sendMail(mailOptions, function (error, response) {
                if (error) {
                    console.log(error);
                    // res.send({ message: 'error' });
                } else {
                    console.log('Message sent: ', response);
                    //   res.send({ message: 'sent' });
                }
            });

        }).catch(err => {
            // res.status(400);
            // res.send({
            //     message: 'Bad request',
            //     error: err
            // });
            return;
        });
    },
    verifyUser: function (req, res, next) {
        if (req.body.token != undefined) {
            // console.log("ver called", req.body.token)
             const token = req.body.token;
           
            console.log(token);
            var User = db.User;
            User.findOne({
                where: {
                    emailVerificationToken: token,
                },
            }).then(resp => {
                console.log("token verified!");
                console.log(resp);
                User
                    .update({
                        emailVerified: 1,
                        emaiVerificationDate: new Date(),

                    }, { where: { userID: resp.userID, } })
                    .then(success => {
                        SendWelComeMail(resp);
                        res.status(200).send({
                            message: 'User Verified!',

                        });
                        return;
                    })
                    .catch(err => {
                        res.status(500).send({
                            message: 'error occured in user vefification!',
                            error: err
                        });
                        return;

                    });
            }).catch(err => {
                res.status(400);
                res.send({
                    message: 'Bad request',
                    error: err
                });
                return;
            });
        }
        else {
            res.status(401);
            res.send({
                message: 'Bad request',
                error: err
            });
            return;
        }
    },
    sendUserWelcomeMail: function (user) {
       // if (user.emailVerified) {

            SendWelComeMail(user);
       // }
   },

    /***end of new user block ***/
    //send password reset email

    sendPwdResetEmail: function (req, res, next) {
        let senderEmail = req.body.email;
        console.log(senderEmail);
        var users = db.User;
        users.findOne({
            where: {
                email: senderEmail,
            },
        }).then(user => {
            let token = (new Date()).getTime();
            if (user) {
                console.log(user);
                users
                    .update({
                        passwordResetToken: token
                    }, { where: { userID: user.userID, } }).then(resp => {
                        if (resp) {
                            //send mail block
                            let messageSubject = "Password Reset Link!";
                            let mailOptions = {
                                to: [senderEmail], // Enter here the email address on which you want to send emails from your customers http://52.55.210.169/verification
                                from: "Leezed",
                                subject: messageSubject,
                                html: `<img src="cid:116@nodemailer.com"/><br/><br/> <span>Welcome user, <br/> 
                               please click <a href=" http://3.226.150.129/resetpassword?authVer=` + token + `">here</a> to reset your password!</span>
                                      <br/> <br/> <br/> <br/>
                                  Regards,<br/>
                                  <b> Leezed<br/>
                                      Support
                                  </b>
              `,
                                attachments: [{
                                    filename: 'welcome.png',
                                    path: __dirname + './../assets/leezed.png',
                                    cid: '116@nodemailer.com' //same cid value as in the html img src
                                }],

                            };
                            transporter.sendMail(mailOptions, function (error, response) {
                                if (error) {
                                    console.log(error);
                                    res.send({ message: 'error' });
                                } else {
                                    console.log('Message sent: ', response);
                                    res.send({ message: 'sent' });
                                }
                            });
                        }
                    }).catch(err => {
                        res.status(500);
                        res.send({
                            message: 'Error occured while saving reset token',
                            error: err

                        });
                        return;
                    });
            }
            else {
                res.status(201);
                res.send({
                    message: 'No user exists with given email id!'

                });
                return;

            }

        }).catch(err => {
            res.status(400);
            res.send({
                message: 'Bad request, Some error occured while fetching user details!',
                error: err
            });
            return;
        });
    },


    /****product related mails(to be migrated to firebase) */
    rentRequestRecievedMail: function (order) {



db.sequelize.
query(`
select o.orderID,o.productID,p.name as productName,u.name as rentedFrom,u.userID as rentedFromUserID,u.email as rentedFromEmail,o.isApproved,
 o.userID as rentedByUserID,v.screenName as requestedBy, v.email as rentedByEmail,
 p.userID as rentedFromUserID,u.screenName as ownerName, 
 o.rentPrice, o.discounts,o.rentalStartDate,o.rentalEndDate,
p.pickupInstructions,p.location from leezed.order o  join product p on o.productID=p.productID
 join user u on p.userID=u.userID  join user v on o.userID=v.userID where o.userID=`+order.userID+`  and o.orderID=`+order.orderID+`;
`, 
{ type: db.sequelize.QueryTypes.SELECT }).then(resp=>{

    if(resp.length>0){
        console.table(resp);
        var result=resp[0];
        console.log(result);
       var  senderEmail=result.rentedFromEmail;
       console.log(senderEmail);
            //send mail block
            let messageSubject = "New request for item "+result.productName+" : "+result.productID;
            let mailOptions = {
                to: [senderEmail], // Enter here the email address on which you want to send emails from your customers http://52.55.210.169/verification
                from: "Leezed",
                subject: messageSubject,
                html: `<img src="cid:116@nodemailer.com"/><br/><br/> 
                
                
                Dear `+result.rentedFrom+`,

                Your item `+result.productName+` : `+result.productID+` has been requested by user `+result.requestedBy+` from `+result.rentalStartDate+` to `+result.rentalEndDate+`.
                
                Click <a href="http://3.226.150.129/pendingapprovals">here</a> to APPROVE or REJECT.
                <br/><br/>
                Warm Regards, <br/>
                Leezed Customer Service
    `,
                attachments: [{
                    filename: 'welcome.png',
                    path: __dirname + './../assets/leezed.png',
                    cid: '116@nodemailer.com' //same cid value as in the html img src
                }],
    
            };
            transporter.sendMail(mailOptions, function (error, response) {
                if (error) {
                    console.log(error);
                    res.send({ message: 'error' });
                } else {
                    console.log('Message sent: ', response);
                    res.send({ message: 'sent' });
                }
            });
        

    }



}).catch(err=>{

});


 





     
    },

    /**end of product email ops**/
    //save new password
    saveNewPassword: function (req, res, next) {
        // define the validation schema
        const schema = Joi.object()
            .keys({
                // email is required
                // email must be a valid email string
                email: Joi.string()
                    .email()
                    .required(),
                //password is required
                passwordResetToken: Joi.required(),
                newPassword: Joi.required(),
                confirmPassword: Joi.required()
            })
            .unknown();
        var data = req.body;
        console.log(data);
        Joi.validate(data, schema, (error, value) => {
            if (error) {
                console.log(error.message);
                return res.status(400).send(error.message);
            }
            var users = db.User;

            var date1 = new Date(data.passwordResetToken * 1);
            const diffTime = Math.abs((new Date()).getTime() - date1.getTime());
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            console.log('date diff between  token sent and verified', diffDays);
            if (diffDays > 1) {
                res.status(200).send({
                    message: 'Token Expired, Please try  again..',
                    statusCode: "TOK_EXPIRED"
                });
                return;
            }
            if (data.newPassword === data.confirmPassword) {
                users.findOne({
                    where: {
                        email: data.email,
                        passwordResetToken: data.passwordResetToken
                    },
                })
                    .then(user => {
                        console.log("found user", user);
                        UpdateUser(generateHash, data, user, users, res).then((userupdated) => {
                            return res.send({
                                error: null,
                                message: "user updated!",
                                recordsUpdated: userupdated

                            });


                        })
                            .catch(err => {
                                console.log(err);
                                res.status(500).send({
                                    message: 'error occured in reseting password!!',
                                    error: err
                                });
                                return;

                            });
                    }).catch(err => {
                        console.log(err);
                        res.status(500).send({
                            message: 'error occured in saving password!!',
                            error: err
                        });
                        return;

                    });

            }
            else {
                res.status(403).send({
                    message: 'Password mismatch,new password & confirm password!'

                });
                return;
            };
        });
    },





    getAllUsers: function (req, res, next) {
        db.User.findAll().then(function (users) {

            res.json(users);

        }).catch(err => {
            console.log(err);
            res.send(err);
        });
    },

    getByIdUser: function (req, res, next) {
        console.log('user', req.query);
        db.User.findOne({
            attributes: ['userID', 'name', 'userID', 'screenName', 'email', 'phone', 'isAdmin'],
            where: {
                userID: req.query.userID
            }
        }).then(function (user) {

            res.json(user);

        }).catch(err => {
            console.log(err);
            res.send(err);
        });

    }
}

function SendWelComeMail(user) {
    var senderEmail=user.email;
    var messageSubject="Welcome to Leezed";
    let mailOptions = {
        to: [senderEmail],
        from: "Leezed Customer Service",
        subject: messageSubject,
        html: `<img src="cid:116@nodemailer.com"/><br/><br/> 
    
        Dear ` + user.name + `,<br/>

        Welcome to Leezed!!<br/>
        
        You can download the app on <a href="https://leezed.com"><img  style="height:35px;width:100px" src="cid:118@nodemailer.com"/></a> <a href="https://leezed.com"> <img style="height:35px;width:100px" src="cid:117@nodemailer.com"/></a> .
        <br/><br/>
        Warm Regards, <br/>
        Leezed Customer Service
      
         `,
        attachments: [{
            filename: 'welcome.png',
            path: __dirname + './../assets/leezed.png',
            cid: '116@nodemailer.com' //same cid value as in the html img src
        }, {
            filename: 'google.png',
            path: __dirname + './../assets/google.png',
            cid: '117@nodemailer.com' //same cid value as in the html img src
        }, {
            filename: 'applestore.png',
            path: __dirname + './../assets/applestore.png',
            cid: '118@nodemailer.com' //same cid value as in the html img src
        }],
    };
    transporter.sendMail(mailOptions, function (error, response) {
        if (error) {
            console.log(error);
            // res.send({ message: 'error' });
        }
        else {
            console.log('Message sent: ', response);
            //   res.send({ message: 'sent' });
        }
    });
}
