
var MongoClient = require('mongodb').MongoClient;
var url = process.env.MONGODB_URI || 'mongodb://localhost:27017/dev';


module.exports = {
  groupby : function (id, callback) {
   
    return new Promise(function(resolve, reject) {
      
      MongoClient.connect(url, function(err, db) {
        if (err) {
          reject(err);
          console.log('db err');
        }
        console.log('db connect');
        resolve(db);
      });
    }).then(function(db) {
      return new Promise(function(resolve, reject) {
        var collection = db.collection('Application');
        collection.distinct(id, function(err, result) {
          if (err) {
            reject(err);
          }
          db.close();
          resolve(result);
        })
      })     
    });
  }
};




// var simpleDistinct = function(db, callback) {
// 	var collection = db.collection( 'Application' );
//     collection.distinct( 'bundleID', 
	  
// 	  function(err, result) {
//         assert.equal(err, null);
//         console.log(result)
//         callback(result);
//       }
//   );
//   console.log('s or a');
// }

// var simplePipeline = function(db, callback) {
//   var collection = db.collection( 'Application' );
//   collection.aggregate( 
//       [ 
//         //{ '$sort': {'_updated_at': -1}},
//         { '$group': { '_id': "$bundleID", 'count': { '$sum': 1 }, "update": { "$last":"$_updated_at"}, "name": {"$last":"$name"} } }		
//       ],	  
// 	  function(err, results) {
//         assert.equal(err, null);

//         console.log(results)
//         callback(results);
//       }
//   );
// }

// var simpleGroup = function(db, callback) {
//     var collection = db.collection( 'Application' );
//     collection.group( ['bundleID'], 
//                       {},
//                       { },
//                       "function ( curr, result ) { result.total++ }",  
	  
//       function(err, result) {
//         assert.equal(err, null);
//         console.log(result)
//         callback(result);
//       }
//   );
// }