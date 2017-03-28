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
    var filepath = file.originalname;
   
    return publishApk(file);
    
  },
  getAllApps: function () {
    return allApps();
  },
  getAllVersions: function (bundleID, page, count) {
    return allVersions(bundleID, page, count);
  }
};

function publishApk(file) {

   // 1. save icon 2. parse info 3. save apk 
    var filepath = file.path;
    var size =  pretty(file.size);
    var save_icon = extractAndSaveApkIcon(filepath);
    var parse_info = parseApk(filepath);
    var save_app = saveFile(filepath, 'app.apk');

    return Promise.all([save_icon, parse_info, save_app])
    .then(values => {

      return new Promise(function(resolve, reject) {

        var icon_file = values[0];
        var info = values[1];
        var ipa_file = values[2];

        var Application = Parse.Object.extend('Application');
        var app = new Application();
        app.set('icon', icon_file);
        app.set('package', ipa_file);
        app.set('size', size);
        
        Object.keys(info).forEach(function(key) {
          var val = info[key];
          app.set(key, val);
        });
        app.save(null, {
            success: function(app) {
                resolve(app);
            },
            error: function(obj, err) {
                reject(err);
            }

        });
      });

    }, reason => {
      console.log(reason);
      return Promise.reject(reason);
    });    
  
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



function extractAndSaveApkIcon(filename) {
  var promise = extractApkIcon(filename);
  return promise.then(function(icon_path) {
    return saveFile(icon_path, 'icon.png')
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

function saveFile(filename, mimeType) {

  return new Promise(function(resolve, reject) {

    fs.readFile(filename, function(err, data) {
      if (err) {reject(err)};

      var base64 = {
        base64: new Buffer(data).toString('base64')
      };

      var parseFile = new Parse.File(mimeType, base64);
      parseFile.save().then(function() {
        // this file has been saved to Parse.
        resolve(parseFile);
      }, function(err) {
        reject(err);
      });
    })


  // delete file
  // fs.unlink(req.files.path, function (err) {
  //   if (err) throw err;
  //   console.log('successfully deleted ' + req.files.path);
  // }); 

  });

}
