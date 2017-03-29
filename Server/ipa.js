var path = require('path');
var fs = require('fs');
var pngdefry = require('pngdefry');
var AdmZip = require("adm-zip");
var uuidV4 = require('uuid/v4');
var util = require('util')
var extract = require('ipa-extract-info');
var Manifest = require('./manifest.js');
var pretty = require('prettysize');
var tmp_dir = path.join(__dirname, 'tmp_file');
var DB = require('./realmDB.js');
var db = new DB();
var FileHelper = require('./file-helper.js');
var fl = new FileHelper();

module.exports = {
  publish : function (file) {
    var filepath = file.originalname;
    if (path.extname(filepath) === ".ipa") {
      return publishIpa(file);
    }
    if (path.extname(filepath) === ".apk") {
      return publishApk(file);
    }
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
    var records = db.getRecords('ios');
    resolve(records);
  });
}
function allInfos(bundleID, page, count)  {
  var page = 1;
  var count = 100;
  return new Promise(function(resolve, reject) {
    var records = db.getAppInfos('ios', bundleID);
    resolve(records);
  });
}
function allVersions(bundleID, page, count) {

  var Application = Parse.Object.extend('Application');
  var query = new Parse.Query(Application);
  query.equalTo("bundleID", bundleID);
  query.descending("updatedAt");  
  query.limit(count);
  query.skip((page-1)*count); // for pagination
  return new Promise(function(resolve, reject) {
    query.find({
      success: function(apps) {
        resolve(mapIpas(apps));
      },
      error: function(err) {
        reject(err);
      }
    })
  });
}

// map icon, package, manifest property.
function mapIpas(apps) {
  var mapedIpas = apps.map(function(ipa) {
    ipa.set('icon', ipa.get('icon').url());
    ipa.set('package', ipa.get('package').url());
    var manifest = util.format('itms-services://?action=download-manifest&url=%s', ipa.get('manifest').url());
    ipa.set('manifest', manifest);
    return ipa;
  })
  
  return mapedIpas;
}

function findApp(bundleID) {
    var Application = Parse.Object.extend('Application');
    var query = new Parse.Query(Application);
    query.equalTo("bundleID", bundleID);
     // query.descending("updatedAt"); 
    return new Promise(function(resolve, reject) {
      query.first({
        success: function(app) {
          resolve(app);
        },
        error: function(err) {
          reject(err);
        }
      })
    });
}

function publishIpa(filepath) {
    // 1. save icon 2. parse info.plist 3. save ipa
    var size =  '7 M';
    var info = {};
    return Promise.all([extractIpaIcon(filepath), parseIpa(filepath)])
    .then(values => {
        console.log('begin');
      var tmpIconPath = values[0];
      info = values[1];
      var iconPath = db.findAppIcon(info);
      if (iconPath == '') {
        console.log('miss hit icon');
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
      var appPath = path.join(fl.appDir, util.format('%s.ipa', uuidV4()));
      console.log('app path : ' + appPath);
      return fl.rename(filepath, appPath);
    }) 
    .then(function(ipaPath) {
      info['package'] = path.basename(ipaPath);
      var manifestPath = path.join(fl.manifestDir, util.format('%s.plist', uuidV4()));
      console.log('manifest path : ' + manifestPath);
      return Manifest.generate(info, manifestPath);      
    })
    .then(function(manifestPath) {
      info['objectId'] = uuidV4();
      info['manifest'] = path.basename(manifestPath);
      info['size'] = size;

      return db.updateAppInfo(info);
    })
} 

function publishApk(file) {
  console.log('publishApk');
  
}
    
function newSaveFile(input, output) {

  return new Promise(function(resolve, reject) {
    fs.rename(input, output, function(err) {
      if (err) reject(err);
      resolve(output);
    })
  });
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


function parseIpa(filename) {

	
  return new Promise(function(resolve,reject){
    var fd = fs.openSync(filename, 'r');
    extract(fd, function(err, info, raw){
    if (err) reject(err);
      var data = info[0];
      var info = {}
      info["platform"] = "ios"
      info["build"] = data.CFBundleVersion,
      info["bundleID"] = data.CFBundleIdentifier,
      info["version"] = data.CFBundleShortVersionString,
      info["name"] = data.CFBundleName
      resolve(info)
    });
  });
}

function extractAndSaveIpaIcon(filename) {
  var promise = extractIpaIcon(filename);
  return promise.then(function(icon_path) {
    return saveFile(icon_path, 'icon.png')
  });

}


function extractIpaIcon(filename) {
  return new Promise(function(resolve,reject){
    var zip = new AdmZip(filename); 
    var ipaEntries = zip.getEntries();
    var found = false;
    ipaEntries.forEach(function(ipaEntry) {
      if (ipaEntry.entryName.indexOf('AppIcon60x60@2x.png') != -1) {
        found = true;
        var buffer = new Buffer(ipaEntry.getData());
        if (buffer.length) {
          var guid = uuidV4();
          var input = util.format('%s/%s.png', tmp_dir, guid)
          var output = util.format('%s/%s.new.png', tmp_dir, guid)

          fs.writeFile(input, buffer,function(err){  
            if(err){ 
              
              reject(err)
            } 

            pngdefry(input, output, function(err) {
  				    if (err) {
                // may not the correct format, so we just return the input file instand.
                resolve(input);
  					    //reject(err)
 				      }
 				      resolve(output);
			      });
          });
        }
      }
    })
    if (!found) {
      reject("can not find icon ")
    }
  })
}


var pro = allInfos('com.lashou.StartupCycle.BusinessMembers');
pro.then(function(result) {
  console.log(result);
}, function(error) {
  console.log(error);

})

// var path = path.join(__dirname) + "/xxx.ipa";
// console.log(path);

// var p = test(path).then(function(info) {
//   console.log(info);

// });

// var p = parseIpa(path).then(function(info) {
//   console.log(info);
// });




