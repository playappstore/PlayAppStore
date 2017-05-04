#!/usr/bin/env node
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
var upload = multer({ dest: os.homedir() + '/.playappstore/tmp_file/' })
var bodyParser = require('body-parser')
var FileHelper = require('./file-helper.js');
const fl = new FileHelper();
var program = require('commander');
var dateFormat = require('dateformat');
const pkgVersion = require('./package.json').version;

/**
 * Install a before function; AOP.
 */

function before(obj, method, fn) {
  var old = obj[method];

  obj[method] = function() {
    fn.call(this);
    old.apply(this, arguments);
  };
}


before(program, 'outputHelp', function() {
  this.allowUnknownOption();
});
program
    .version(pkgVersion)
    .usage('[option] [dir]')
    .option('-p, --port <port-number>', 'set port for server (defaults is 9090)')
    .option('-h, --host <host>', 'set host for server (defaults is your LAN ip)')
    .option('-c, --config <config-file>', 'set the config json file path')
    .parse(process.argv);

var app = express();

app.post('/apps', upload.single('package'), function (req, res) {
  var token = req.header('MasterKey')
  if (token !== masterKey) {
    res.sendStatus(403);
    return;
  }

  var info = {};
 
  if (req.body.changelog) {
    info['changelog'] = req.body.changelog;
  }
  if (req.body.description) {
    info['description'] = req.body.description;
  }
  if (req.body.lastCommitMsg) {
    info['lastCommitMsg'] = req.body.lastCommitMsg;
  }
  if (req.body.jenkinsChangelog) {
    info['jenkinsChangelog'] = req.body.jenkinsChangelog;
  }

  // req.file is the `package` file
  var file = req.file;
  var filepath = file.originalname;
  var promise;
  if (path.extname(filepath) === ".ipa") {
    promise = IPA.publish(file, info);
  }
  if (path.extname(filepath) === ".apk") {
    promise = APK.publish(file, info);
  }
  promise.then(function(app) {
    res.send(app);
    //res.send('success, ' + app.id);
  }, function(error) {
    res.send('fail, ' + error.message);
  });
})

app.get('/records/:platform', function(req, res) {

  var promise;
  if(req.params.platform === 'ios') {
    promise = IPA.getRecords();
  }
  if(req.params.platform === 'android') {
    promise = APK.getRecords();
  }
  promise.then(function(apps) {
      return mapApps(apps);
  })
  .then(function(apps) {
      res.send(apps);
  }, function(err) {
      res.send('fail,' + err);
  })
})


app.get('/apps/:platform/:bundleId', function(req, res) {
  var page = parseInt(req.query.page ? req.query.page : 1);
  var count = parseInt(req.query.count ? req.query.count : 10);
  var promise;
  if (req.params.platform === 'ios') {
    var bundleId = req.params.bundleId;
    if (typeof(bundleId) === 'string') {
      promise = IPA.getAllVersions(bundleId, page, count);
    } else {
      // promise = IPA.getAllInfos(page, count);
    }
  }
  if (req.params.platform === 'android') {
    var bundleId = req.params.bundleId;
    if (typeof(req.params.bundleId) === 'string') {
      promise = APK.getAllVersions(bundleId, page, count);
    } else {
      // promise = APK.getAllInfos(page, cout);
    }
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
app.get('/apps/:platform/:bundleId/:objectId', function(req, res) {
  var promise;
  if (req.params.platform === 'ios') {
    var bundleId = req.params.bundleId;
    var objectId = req.params.objectId;
    promise = IPA.getAppDetail(bundleId, objectId);
    
  }
  if (req.params.platform === 'android') {
    var bundleId = req.params.bundleId;
    if (typeof(req.params.bundleId) === 'string') {
      promise = APK.getAppDetail(bundleId, page, count);
    } else {
      // promise = APK.getAllInfos(page, cout);
    }
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
  var promise = IPA.renderManifist(req.params.guid, HTTPSServerUrl);
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
    app.icon = HTTPSServerUrl + path.join('icon', app.icon);
    
    if (app.hasOwnProperty('package')) {
      app.package = HTTPSServerUrl + path.join('app', app.package);
    }
    if (app.hasOwnProperty('createdAt')) {
      app.createdAt = dateFormat(app.createdAt, 'yyyy-mm-dd HH:MM');
    }
    if (app.hasOwnProperty('updatedAt')) {
      app.updatedAt = dateFormat(app.updatedAt, 'yyyy-mm-dd HH:MM');
    }
    if (app.hasOwnProperty('manifest')) {
      if (app.platform === 'ios') {
        var manifest = path.basename(app.manifest, '.plist')
        manifest = HTTPSServerUrl + path.join('plist', manifest);
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
  device.uuid = req.body.uuid;
  device.platform = req.body.platform;
  if (typeof(req.body.apnsToken) === 'string') {
    device.apnsToken = req.body.apnsToken; 
  }
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

var router = '/records/:platform/:bundleId/follow';
app.put(router, function(req, res) {
  var token = req.header('Authorization')
  if (typeof(token) !== 'string' ) {
    res.sendStatus(403);
  }
  var bundleId = req.params.bundleId;
  var platform = req.params.platform;
  var promise;
  if (platform === 'ios') {
    promise = IPA.updateFollowedRecords(token, bundleId, '1');
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
  var bundleId = req.params.bundleId;
  var platform = req.params.platform;
  var promise;
  if (platform === 'ios') {
    promise = IPA.updateFollowedRecords(token, bundleId, '0');
  }
  promise.then(function(result) {
    res.sendStatus(204);
  }, function(error) {
    res.send('fail: ' + error);
  })
})

var ssl_certificate;
var ssl_certificate_key;
var host;
var port;
var masterKeyHolder;
if (typeof(program.config) === 'string') {
  if (!fs.existsSync(program.config)) {
    console.log('wrong config path!');
    return;
  }
  var options = require(program.config);
  ssl_certificate = options.ssl_certificate || null;
  ssl_certificate_key = options.ssl_certificate_key || null;
  host = options.host;
  port = options.port || 9090;
  masterKeyHolder = options.masterKey || 'playappstore';
} else {
  host = process.env.host || Cert.getIP();
  port = process.env.PORT || 9090;
  // masterKey for post apps 
  masterKeyHolder = process.env.masterKey || 'playappstore';
}
const masterKey = masterKeyHolder;

console.log('please set request header field "MasterKey" to %s when publish a new app', masterKey);

// may remove the http server in the future.
var httpPort = 9091;
const HTTPServerUrl = util.format('http://%s:%d/', host, httpPort);

const HTTPSServerUrl =  util.format('https://%s:%d/', host, port);

var certsOptions;
// only generate the self-signed certificate when the user didn't have one.
if (ssl_certificate == null || ssl_certificate_key == null) {
  var caPath;
  Cert.configCerts(host, function (options, certDirPath, caCertPath) {
    certsOptions = options;
    caPath = caCertPath;
  })
  app.use('/cer/rootca.cer', express.static(caPath));
  // enable to visit this page to install customize cert
  app.get('/diy', function(req, res) {
    res.sendFile(path.join(__dirname, '/Web/cert.html'));
  });
  console.log('please visit this url to install ca cert: ' + HTTPSServerUrl + 'diy');
} else {
  certsOptions = {
    key: fs.readFileSync(ssl_certificate_key),
    cert: fs.readFileSync(ssl_certificate)
  }
}


app.use('/', express.static(path.join(__dirname, 'Web')));
app.use('/app', express.static(fl.appDir));
app.use('/icon', express.static(fl.iconDir));

// Serve static assets from the /public folder
app.use('/public', express.static(path.join(__dirname, '/public')));

var httpServer = require('http').createServer(app);
httpServer.listen(httpPort, function() {
});

var httpsServer = require('https').createServer(certsOptions, app);
httpsServer.listen(port, function() {
  console.log('playappstore running on: ' + HTTPSServerUrl );
}).on('error', function(err) {
  console.log('create https server fail, reason :' + err);
});
