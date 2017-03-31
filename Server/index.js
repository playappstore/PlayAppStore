var express = require('express');
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
var bodyParser = require('body-parser')
var FileHelper = require('./file-helper.js');
const fl = new FileHelper();

var app = express();

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('I dream of being a website!');
});

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
    res.send(app);
    //res.send('success, ' + app.id);
  }, function(error) {
    res.send('fail, ' + error.message);
  });
})

app.get('/apps/:platform', function(req, res) {

  var promise;
  if(req.params.platform === 'ios') {
    promise = IPA.getRecords();
  }
  if(req.params.platform === 'android') {
    promise = APK.getRecords();
  }
  promise.then(function(apps) {
      console.log('got records');
      return mapApps(apps);
  })
  .then(function(apps) {
      res.send(apps);
  }, function(err) {
      res.send('fail,' + err);
  })
})

var route = ['/apps/:platform/:bundleID', '/apps/:platform/:bundleID/:page', '/apps/:platform/:bundleID/:page/:count'];
app.get(route, function(req, res) {
  var page = parseInt(req.params.page ? req.params.page : 1);
  var count = parseInt(req.params.count ? req.params.count : 10);
  var bundleID = req.params.bundleID;
  var promise;
  if (req.params.platform === 'ios') {
    promise = IPA.getAllVersions(bundleID, page, count);
  }
  if (req.params.platform === 'android') {
    promise = APK.getAllVersions(bundleID, page, count);
  }
  promise.then(function(apps) {
    return mapApps(apps);
  })
  .then(function(apps) {
    res.send(apps);
  }, function(err) {
    res.send('fail,' + err);
  })  
});

app.get('/plist/:guid', function(req, res) {
  var promise = IPA.renderManifist(req.params.guid, baseUrl);
  promise.then(function(buffer) {
    res.set('Content-Type', 'text/plain; charset=utf-8');
    res.set('Access-Control-Allow-Origin','*');
    res.send(buffer);
  }, function(error) {
    res.send('fail,' + err);
  })
})

function mapApps(apps) {
  var mapedApps = apps.map(function(app) {
    app.icon = path.join(baseUrl, 'icon', app.icon);
    // app.icon = util.format('%s/icon/%s', baseUrl, app.icon);
    if (app.hasOwnProperty('package')) {
      app.package = path.join(baseUrl, 'app', app.package);
    }
    if (app.hasOwnProperty('manifest')) {
      if (app.platform === 'ios') {
        var manifest = path.basename(app.manifest, '.plist')
        manifest = path.join(baseUrl, 'plist', manifest);
        app.manifest = util.format('itms-services://?action=download-manifest&url=%s', manifest);
      }
    }
    return app;
  })
  return mapedApps;
}

var jsonParser = bodyParser.json()
app.post('/devices', jsonParser, function (req, res) {
  if (!req.body) return res.sendStatus(400)
  var device = {};
  device['uuid'] = req.body.uuid;
  device['platform'] = req.body.platform;
  console.log(device);
  var promise = IPA.registerDevice(device);
  promise.then(function(result) {
    res.send(result);
  }, function(error) {
    res.send('fail: '+ error); 
  })
})

app.get('/records/:platform/followed', function(req, res) {
  var token = req.header('Authorization');
  var platform = req.params.platform;
  var promise;
  if (platform === 'ios') {
    promise = IPA.getAllFolloweds(token);
  }
  promise.then(function(records) {
    return mapApps(records);
  })
  .then(function(records) {
    res.send(records);
  }, function(error) {
    res.send('fail: ' + error);
  })
})

var router = '/records/:platform/:bundleID/follow';
app.put(router, function(req, res) {
  var token = req.header('Authorization')
  if (typeof(token) !== 'string' ) {
    res.sendStatus(403);
  }
  var bundleID = req.params.bundleID;
  var platform = req.params.platform;
  var promise;
  if (platform === 'ios') {
    promise = IPA.updateFollowedRecords(token, bundleID, '1');
  }
  promise.then(function(result) {
    res.sendStatus(204);
  }, function(error) {
    res.send('fail: ' + error);
  })
})
app.delete(router, function(req, res) {
  var token = req.header('Authorization')
  if (typeof(token) !== 'string' ) {
    res.sendStatus(403);
  }
  var bundleID = req.params.bundleID;
  var platform = req.params.platform;
  var promise;
  if (platform === 'ios') {
    promise = IPA.updateFollowedRecords(token, bundleID, '0');
  }
  promise.then(function(result) {
    res.sendStatus(204);
  }, function(error) {
    res.send('fail: ' + error);
  })
})


var port = process.env.PORT || 1337;
var ipAddress = Cert.getIP();
const baseUrl =  util.format('https://%s:%d/', ipAddress, port)
var certsOptions;;
var certsPath;
Cert.configCerts(ipAddress, function (options, path) {
  certsOptions = options;
  certsPath = path;
})

app.use('/cer', express.static(certsPath));
app.use('/app', express.static(fl.appDir));
app.use('/icon', express.static(fl.iconDir));

// enable to visit this page to install customize cert
app.get('/public/diy', function(req, res) {
  res.sendFile(path.join(__dirname, '/public/cert.html'));
});
// Serve static assets from the /public folder
app.use('/public', express.static(path.join(__dirname, '/public')));

console.log('please visit this url to install ca cert: ' + baseUrl + 'public/diy');
var httpsServer = require('https').createServer(certsOptions, app);
httpsServer.listen(port, function() {
    console.log('playappstore running on: ' + baseUrl );
});
