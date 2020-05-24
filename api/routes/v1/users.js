var express = require('express');
var router = express.Router();
const passport=require('passport');
var userController=require('../../controllers/user');
var authController=require('../../controllers/auth');
/* GET users listing. */
router.get('/',passport.authenticate("jwt-strategy", { session: false }), userController.getAllUsers);
router.get('/getByIdUser',passport.authenticate("jwt-strategy", { session: false }), userController.getByIdUser);

/*POST users listing */
router.post('/signup', authController.signUp);
router.post('/signin', authController.signIn);
router.post('/verifyUser', userController.verifyUser);
router.post("/api/auth/facebook", authController.signInWithFacebook);
router.post("/api/auth/google", authController.signInWithGoogle);

router.post('/saveAddress',passport.authenticate("jwt-strategy", { session: false }), authController.saveAddress);
router.post('/updateProfile',passport.authenticate("jwt-strategy", { session: false }), userController.modifyUser);


router.post('/sendPwdResetEmail', userController.sendPwdResetEmail);
router.post('/saveNewPassword', userController.saveNewPassword);


 //unprotected routes
 router.get("/fetchZipDetails", authController.fetchZipDetails);
module.exports = router;
