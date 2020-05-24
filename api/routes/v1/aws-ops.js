const aws = require('aws-sdk')
const express = require('express')
const passport = require('passport');
const router = express.Router();
const multer = require('multer');
const multerS3 = require('multer-s3');
const awsBasePath = "https://leezed-prod.s3.us-east-2.amazonaws.com/";
const s3 = new aws.S3(
  {
    accessKeyId: "AKIAXOAAN3DFSPTGXLVU",
    secretAccessKey: "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"
  }
);
const bucket = 'leezed-prod';
const imgFolder='ProductImages/';
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: bucket,
    contentType: multerS3.AUTO_CONTENT_TYPE,
    acl: 'public-read',
    metadata: function (req, file, cb) {

      cb(null, { fieldName: file.fieldname });
    },
    key: function (req, file, cb) {

      console.log(req.body);

      cb(null, imgFolder+'Prod_' + req.body.productID + '/' + file.originalname)
    }
  })
}).array('photos', 3);

//delete one or whole product folder from s3 bucket
const deleteFromBucket = (req, res, next) => {
  var deleteKey = imgFolder+'Prod_' + req.body.productID;
  const deleteType = req.body.deleteType;
  const imageName = req.body.imageName;
  if (deleteType && imageName) {
    //if delete type is single image then deleteKey is single  image name
    deleteKey = deleteKey + "/" + imageName;
  }
  let currentData;
  let params = {
    Bucket: bucket,
    Prefix: deleteKey
  };

  return s3.listObjects(params).promise().then(data => {
    if (data.Contents.length === 0) {
      throw new Error('List of objects empty.');
    }
    currentData = data;
    params = { Bucket: bucket };
    params.Delete = { Objects: [] };
    currentData.Contents.forEach(content => {
      params.Delete.Objects.push({ Key: content.Key });
    });
    return s3.deleteObjects(params).promise();
  }).then(() => {
    return res.send({message:'Deleted Successfully'});
  }).catch(err => {
    console.log(err);
    return res.status(500).send(err);
  });
};

//delete one or whole product folder from s3 bucket
const getS3ProductImages = (req, res, next) => {
  var folderKey = imgFolder+'Prod_' + req.query.productID;

  let currentData;
  let params = {
    Bucket: bucket,
    Prefix: folderKey
  };

  return s3.listObjects(params).promise().then(data => {
    if (data.Contents.length === 0) {
      //throw new Error('List of objects empty.');
      return res.status(200).send({message:'List of Product Images Empty.',Images:[]});
    }
    currentData = data;
    params = { Bucket: bucket };
    params.Products = [];
//+bucker + "/"  removed
    currentData.Contents.forEach(content => {
      params.Products.push(
        { Url: awsBasePath + content.Key,ProductID:req.query.productID ,imageName:content.Key}
        );
    });

    return res.send({ message: "Image List", Images: params.Products });

  }).catch(err => {
    console.log(err);
    return res.status(500).send(err);
  });
};

router.get('/getProductImages',function (req, res, next) {

  var prodID=req.query.productID;
  console.log(prodID);
  getS3ProductImages(req, res, next);
});

router.post('/upload',passport.authenticate("jwt-strategy", { session: false }), function (req, res, next) {

  upload(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      // A Multer error occurred when uploading.
      res.status(400).send('Multer error :' + err);
    } else if (err) {
      // An unknown error occurred when uploading.
      res.status(500).send('error :' + err.message);
    }

    // Everything went fine.
    res.status(200).send({message:'Successfully uploaded ' + req.files.length + ' files!'});
  });

});


router.post('/upload/:productID',passport.authenticate("jwt-strategy", { session: false }), function (req, res, next) {
var prodID=req.query.productID;
console.log(prodID);
  upload(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      // A Multer error occurred when uploading.
      res.status(400).send('Multer error :' + err);
    } else if (err) {
      // An unknown error occurred when uploading.
      res.status(500).send('error :' + err.message);
    }

    // Everything went fine.
    res.status(200).send({message:'Successfully uploaded ' + req.files.length + ' files!'});
  });

});

router.post('/delete',passport.authenticate("jwt-strategy", { session: false }), function (req, res, next) {
  deleteFromBucket(req, res, next);
});
module.exports = router;
