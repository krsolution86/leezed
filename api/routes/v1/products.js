var express = require('express');
var router = express.Router();
const passport=require('passport');
const productController=require('../../controllers/product');
const orderController=require('../../controllers/order');
/* GET users listing. */
router.get('/',productController.getAllProducts);
//router.get('/getByIdProduct',passport.authenticate("jwt-strategy", { session: false }), productController.getByIdUser);

router.get('/getProductBySearchTerm', productController.getProductBySearchTerm);

router.get('/searchProducts', productController.searchProducts);

router.get('/getMyProducts', productController.getUserProducts);

//get my added products items
router.get('/getMyItems',passport.authenticate("jwt-strategy", { session: false }), productController.getMyItems);

router.get('/getProductDetails', productController.getProductById);
//internal apis should not be public
router.get('/getProductViewModel', productController.getProductViewModel);

/*POST users listing */
router.post('/create',passport.authenticate("jwt-strategy", { session: false }), productController.createProduct);
router.post('/update', passport.authenticate("jwt-strategy", { session: false }),productController.updateProduct);
router.post('/addProductToLiveListings', passport.authenticate("jwt-strategy", { session: false }),productController.addProductToLiveListings);



module.exports = router;
