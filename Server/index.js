var express = require('express');
var ParseServer = require('parse-server').ParseServer;
var Parse = require('parse/node');
var IPA = require('./ipa.js');
var APK = require('./apk.js');
var Cert = require('./cert.js');
var util = require('util')
var path = require('path');
var fs = require('fs');
var os = require('os');
var multer  = require('multer')
// omit the options object, the files will be kept in memory and never written to disk
var upload = multer({ dest: 'tmp_file/' })


var databaseUri = process.env.DATABASE_URI || process.env.MONGODB_URI;

if (!databaseUri) {
  databaseUri = 'mongodb://localhost:27017/dev';
  process.env.MONGODB_URI = databaseUri;
  console.log('DATABASE_URI not specified, falling back to localhost.');
}
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
var api = new ParseServer({
  databaseURI: databaseUri,
  appId: process.env.APP_ID || 'playappstore',
  masterKey: process.env.MASTER_KEY || 'masterKey', //Add your master key here. Keep it secret!
  serverURL: process.env.SERVER_URL || 'http://localhost:1337/cgi',  // Don't forget to change to https if needed
  maxUploadSize: '200mb', 
});


var app = express();

// Serve static assets from the /public folder
// app.use('/public', express.static(path.join(__dirname, '/public')));


var mountPath = process.env.PARSE_MOUNT || '/cgi';
app.use(mountPath, api);

// enable to visit this page to install customize cert
app.get('/public/diy', function(req, res) {
  res.sendFile(path.join(__dirname, '/public/cert.html'));
});
// Serve static assets from the /public folder
app.use('/public', express.static(path.join(__dirname, '/public')));

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('I dream of being a website!');
});


// POST method route
app.post('/apps', upload.single('package'), function (req, res) {
  // req.file is the `package` file
  var file = req.file;
  var filepath = file.originalname;
  var promise;
  if (path.extname(filepath) === ".ipa") {
    promise = IPA.publish(file);
  }
  if (path.extname(filepath) === ".apk") {
    promise = APK.publish(file);
  }
  promise.then(function(app) {
    res.send(app.toJSON());
    //res.send('success, ' + app.id);
  }, function(error) {
    res.send('fail, ' + error.message);
  });
})


app.get('/apps/:platform', function(req, res) {

  if(req.params.platform === 'ios') {
    var jsonArray = [];
    var promise = IPA.getAllApps();
    promise.then(function(apps) {
      console.log(apps);
      for (var i=0; i<apps.length; i++) {
        jsonArray.push(apps[i].toJSON());
      }
      res.send(jsonArray);
    }, function(err) {
      res.send('fail,' + err);
    })

  }
  
})

var route = ['/apps/:platform/:bundleID', '/apps/:platform/:bundleID/:page', '/apps/:platform/:bundleID/:page/:count'];
app.get(route, function(req, res) {
  var page = parseInt(req.params.page ? req.params.page : 1);
  var count = parseInt(req.params.count ? req.params.count : 10);
  var bundleID = req.params.bundleID;
  if (req.params.platform === 'ios') {

    var jsonArray = [];
    var promise = IPA.getAllVersions(bundleID, page, count);
    promise.then(function(apps) {
      console.log(apps);
      for (var i=0; i<apps.length; i++) {
        jsonArray.push(apps[i].toJSON());
      }
      res.send(jsonArray);
    }, function(err) {
      res.send('fail,' + err);
    })  

  }

});

  app.get(['/apps/:platform/:bundleID', '/apps/:platform/:bundleID/:page'], function(req, res, next) {
  	  res.set('Access-Control-Allow-Origin','*');
      res.set('Content-Type', 'application/json');
      var page = parseInt(req.params.page ? req.params.page : 1);
      if (req.params.platform === 'android' || req.params.platform === 'ios') {
        queryDB("select * from info where platform=? and bundleID=? order by uploadTime desc limit ?,? ", [req.params.platform, req.params.bundleID, (page - 1) * pageCount, page * pageCount], function(error, result) {
          if (result) {
            res.send(mapIconAndUrl(result))
          } else {
            errorHandler(error, res)
          }
        })
      }
  });



var port = process.env.PORT || 1337;
var ipAddress = Cert.getIP();
var certsOptions;;
var certsPath;
Cert.configCerts(ipAddress, function (options, path) {
  certsOptions = options;
  certsPath = path;
})


Parse.initialize("playappstore");
var baseUrl =  util.format('https://%s:%d/', ipAddress, port)
Parse.serverURL = baseUrl + 'cgi'

app.use('/cer', express.static(certsPath));
console.log('please visit this url to install ca cert: ' + baseUrl + 'cer/my-root-ca.cer');
var httpsServer = require('https').createServer(certsOptions, app);
httpsServer.listen(port, function() {
    console.log('parse-server-example running on: ' + baseUrl );
});
