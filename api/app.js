var createError = require('http-errors');
var express = require('express');
var path = require('path');
var db = require("./models");
var cors = require('cors')
const passport = require("passport");
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var indexRouter = require('./routes/v1/index');
var usersRouter = require('./routes/v1/users');
var commonRouter = require('./routes/v1/common');
var productRouter=require('./routes/v1/products');
var orderRouter=require('./routes/v1/order');
var s3Router=require('./routes/v1/aws-ops');
var esRouter=require('./routes/v1/es-routes');
var app = express();
//env setup
const result = require('dotenv').config() 
if (result.error) {
  throw result.error
} 
console.log(result.parsed)
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/', indexRouter);
app.use('/v1/users', usersRouter);
app.use('/v1/common', commonRouter);
app.use('/v1/images',s3Router);
app.use('/v1/products', productRouter);
app.use('/v1/orders', orderRouter);
app.use('/v1/elastic', esRouter);

app.use(passport.initialize());
//load passport strategies
require("./config/passport.js")(passport, db.User);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
