/*=============================================================================
                               ELASTIC SEARCH  T E S T   A P I s-ADIXIT
===============================================================================*/

var express = require('express');
var router = express.Router();
const ELASTICSEARCH_Service=require('./../../controllers/es-ops');
router.get(
'/elastic/ping', function(req, res){
    ELASTICSEARCH_Service.ping(req, res);
});

router.post('/elastic/index/init',function(req, res){
    // [ 1 ] Create an index
    var index =  process.env.INDEX_NAME;//req.param('index_name');

    ELASTICSEARCH_Service.initIndex(req, res, index);
});

router.post('/elastic/index/check', function(req, res){
    //  [ 2 ] Check if Index exists
    var index = req.param('index_name');
    ELASTICSEARCH_Service.indexExists(req, res, index);
});

router.post('/elastic/index/mapping', function(req, res){
    //  [ 3 ] Preparing index and its mapping (basically setting data-types of each attributes and more)
    var payload = req.param('payload');
    var index =  process.env.INDEX_NAME;// req.param('index_name');
    ELASTICSEARCH_Service.initMapping(req, res, index, payload);
    return null;
});

router.post('/elastic/add', function(req, res){
    //  [ 4 ] Add data to index
    var payload = req.param('payload');
    var index =  process.env.INDEX_NAME;
   // var index = req.param('index_name');
    var _id = req.param('_id');
    var docType = req.param('type');
    ELASTICSEARCH_Service.addDocument(req, res, index, _id, docType, payload);
    return null; 
});

router.put('/elastic/update',function(req, res){
    //  [ 5 ] Update a document
    var payload = req.param('payload');
    var index =  process.env.INDEX_NAME;
    //var index = req.param('index_name');
    var _id = req.param('_id');
    var docType = req.param('type');
    ELASTICSEARCH_Service.updateDocument(req, res, index, _id, docType, payload);
    return null; 
});

router.post('/elastic/search',function(req, res, next){
    // [ 6 ] Search an index
    var index = req.param('index_name');
    var payload = req.param('payload');
    var docType = req.param('type');
    ELASTICSEARCH_Service.search(req, res, index, docType, payload);
});


// -----------------------DANGER ZONE APIs-------------------
router.delete('/elastic/delete-document',function(req, res){
    //  Delete a document
    // var index = req.param('index_name');
    // var _id = req.param('_id');
    // var docType = req.param('type');
    // ELASTICSEARCH_Service.deleteDocument(req, res, index, _id, docType);
    return null; 
});

router.delete('/elastic/delete_all', function(req, res){
   // Delete all indexes
    // ELASTICSEARCH_Service.deleteAll(req, res);
});


module.exports=router;