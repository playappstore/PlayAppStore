var express = require('express');
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



var app = express();

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


function mapApps(apps) {
  var mapedApps = apps.map(function(app) {
    app.icon = util.format('%s/icon/%s', baseUrl, app.icon);
    if (app.hasOwnProperty(package)) {
      app.package = util.format('%s/app/%s', baseUrl, app.package);
    }
    if (app.hasOwnProperty('manifest')) {
      if (app.platform === 'ios') {
        app.manifest = util.format('itms-services://?action=download-manifest&url=%s/plist/%s', baseUrl, path.basename(app.manifest, '.plist'));
      }
    }
    return app;
  })
  return mapedApps;
}


var port = process.env.PORT || 1337;
var ipAddress = Cert.getIP();
var certsOptions;;
var certsPath;
Cert.configCerts(ipAddress, function (options, path) {
  certsOptions = options;
  certsPath = path;
})


app.use('/cer', express.static(certsPath));
console.log('please visit this url to install ca cert: ' + baseUrl + 'cer/my-root-ca.cer');
var httpsServer = require('https').createServer(certsOptions, app);
httpsServer.listen(port, function() {
    console.log('playappstore running on: ' + baseUrl );
});
