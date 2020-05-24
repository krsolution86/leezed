var express = require('express');
var router = express.Router();
const passport=require('passport');
var commonCtrl=require('../../controllers/common');




router.get('/getCategories',passport.authenticate("jwt-strategy", { session: false }), commonCtrl.getCategories);

router.get('/getSharedData',passport.authenticate("jwt-strategy", { session: false }), commonCtrl.getSharedData);


module.exports = router;
