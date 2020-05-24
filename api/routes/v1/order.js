var express = require('express');
var router = express.Router();
const passport=require('passport');

const orderController=require('../../controllers/order');



router.post('/processRentRequests', passport.authenticate("jwt-strategy", { session: false }),orderController.processRentRequest);
router.post('/placeRentRequest', passport.authenticate("jwt-strategy", { session: false }),orderController.placeRentRequest);
router.post('/sendMessage', passport.authenticate("jwt-strategy", { session: false }),orderController.postChatMessage);
router.get('/fetchChatHistory', passport.authenticate("jwt-strategy", { session: false }),orderController.fetchChatHistory);
router.get('/getMyOrders', passport.authenticate("jwt-strategy", { session: false }),orderController.getMyOrders);

module.exports = router;
