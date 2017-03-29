var Parse = require('parse/node');
var path = require('path');
var fs = require('fs');
var AdmZip = require("adm-zip");
var uuidV4 = require('uuid/v4');
var util = require('util')
var apkParser3 = require("apk-parser3");
var DB = require('./dbhelper')
var pretty = require('prettysize');
var tmp_dir = path.join(__dirname, 'tmp_file');

module.exports = {
  publish : function (file) {
    return publishApk(file);
  },
  getRecords: function () {
    return allRecords();
  },
  getAllVersions: function (bundleID, page, count) {
    return allVersions(bundleID, page, count);
  }
};

function allRecords()  {
  // usaully, a company may not have more than 20 apps.
  var page = 1;
  var count = 100;
  return new Promise(function(resolve, reject) {
    var records = db.getRecords('android');
    resolve(records);
  });
}
function allInfos(bundleID, page, count)  {
  var page = 1;
  var count = 100;
  return new Promise(function(resolve, reject) {
    var records = db.getAppInfos('android', bundleID);
    resolve(records);
  });
}

function publishApk(file) {

   // 1. save icon 2. parse info 3. save apk 
    var filepath = file.path;
    var size =  pretty(file.size);
    var info = {};

    return new Promise.all([extractApkIcon(filepath), parseApk(filepath)])
    .then(values => {
      var tmpIconPath = values[0];
      info = values[1];
      var iconPath = db.findAppIcon(info);
      if (iconPath == '') {
        console.log('not hit icon');
        iconPath = fl.iconDir + util.format('%s.png', uuidV4());
      }
      return fl.rename(tmpIconPath, iconPath);
    }, reason => {
      console.log(reason);
      return Promise.reject(reason);
    })
    .then(function(iconPath) {
      info['icon'] = path.basename(iconPath);
      return db.updateAppIcon(info);
    })
    .then(function(appIcon) {
      return db.updateAppRecord(info);
    })
    .then(function(appRecord) {
      var appPath = path.join(fl.appDir, util.format('%s.apk', uuidV4()));
      console.log('app path : ' + appPath);
      return fl.rename(filepath, appPath);
    }) 
    .then(function(ipaPath) {
      info['package'] = path.basename(ipaPath);
      info['objectId'] = uuidV4();
      info['manifest'] = path.basename(manifestPath);
      info['size'] = size;

      return db.updateAppInfo(info);
          
    })
  
}

function parseText(text) {
  var regx = /(\w+)='([\w\.\d]+)'/g
  var match = null, result = {}
  while(match = regx.exec(text)) {
    result[match[1]] = match[2]
  }
  return result
}

function parseApk(filename) {
  return new Promise(function(resolve,reject){
    apkParser3(filename, function (err, data) {
        if (err) reject(err);
        var package = parseText(data.package)
        var info = {
          "name":data["application-label"].replace(/'/g,""),
          "build":package.versionCode,
          "bundleID":package.name,
          "version":package.versionName,
          "platform":"android"
        }
        resolve(info)
    });
  });
}

function extractApkIcon(filename) {
  return new Promise(function(resolve,reject){
    apkParser3(filename, function (err, data) {
      var iconPath = data["application-icon-640"]
      iconPath = iconPath.replace(/'/g,"")
      var guid = uuidV4();
      var output = util.format('%s/%s.new.png', tmp_dir, guid)
      var zip = new AdmZip(filename); 
      var ipaEntries = zip.getEntries();
      var found = false
      ipaEntries.forEach(function(ipaEntry) {
        if (ipaEntry.entryName.indexOf(iconPath) != -1) {
          var buffer = new Buffer(ipaEntry.getData());
          if (buffer.length) {
            found = true
            fs.writeFile(output, buffer,function(err){  
              if(err){  
                  reject(err)
              }
              resolve(output)
            })
          }
        }
      })
      if (!found) {
        reject("can not find icon ")
      }
    });
  })
}
