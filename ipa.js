var path = require('path');
var fs = require('fs');
var pngdefry = require('pngdefry');
var AdmZip = require("adm-zip");
var uuidV4 = require('uuid/v4');
var util = require('util')
var extract = require('ipa-extract-info');
var Manifest = require('./manifest.js');
var pretty = require('prettysize');
var tmp_dir = require('os').homedir() + "/.playappstore/tmp_file/"
var DB = require('./realmDB.js');
var db = new DB();
var FileHelper = require('./file-helper.js');
var fl = new FileHelper();

module.exports = {
  publish : function (file) {
    return publishIpa(file);
  },
  getRecords: function () {
    return allRecords();
  },
  getAllInfos: function(page, count) {
    return allInfos(page, count);
  },
  getAllVersions: function (bundleId, page, count) {
    return allVersions(bundleId, page, count);
  },
  getAppDetail: function(bundleId, objectId) {
    return appDetail(bundleId, objectId);
  },
  renderManifist: function(guid, basePath) {
    var input = path.join(fl.manifestDir, util.format('%s.plist', guid));
    return Manifest.render(input, basePath);      
  },
  registerDevice: function (device) {
    return db.updateDevice(device);
  },
  updateDevice: function(device) {
    return db.updateDevice(device);
  },
  updateFollowedRecords: function(deviceID, bundleId, action) {
    var device = {uuid: deviceID, platform: 'ios'};
    return db.updateDevice(device, bundleId, action);
  },
  getAllFolloweds: function(deviceID) {
    return allFolloweds(deviceID);
  }
};

function allFolloweds(deviceID) {
  return new Promise(function(resolve, reject) {
    var records = db.getFolloweds(deviceID, 'ios');
    resolve(records);
  });
}

function allRecords()  {
  // usaully, a company may not have more than 20 apps.
  var page = 1;
  var count = 100;
  return new Promise(function(resolve, reject) {
    var records = db.getRecords('ios');
    resolve(records);
  });
}
function allInfos(page, count) {
  var page = 1;
  var count = 20;
  return new Promise(function(resolve, reject) {
    var infos = db.getAppInfos('ios', page, count);
    resolve(infos);
  })
}
function allVersions(bundleId, page, count)  {
  return new Promise(function(resolve, reject) {
    var records = db.getAppVersions('ios', bundleId, page, count);
    resolve(records);
  });
}
function appDetail(bundleId, objectId) {

  return new Promise(function(resolve, reject) {
    var records = db.getAppDetail('ios', bundleId, objectId);
    resolve(records);
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


function publishIpa(file) {
    // 1. save icon 2. parse info.plist 3. save ipa
    var filepath = file.path;
    var size =  pretty(file.size);
    var info = {};
    return Promise.all([extractIpaIcon(filepath), parseIpa(filepath)])
    .then(values => {
      var tmpIconPath = values[0];
      info = values[1];
      var iconPath = db.findAppIcon(info);
      if (iconPath == '') {
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
      return fl.rename(filepath, appPath);
    }) 
    .then(function(ipaPath) {
      info['package'] = path.basename(ipaPath);
      var manifestPath = path.join(fl.manifestDir, util.format('%s.plist', uuidV4()));
      return Manifest.generate(info, manifestPath);      
    })
    .then(function(manifestPath) {
      info['objectId'] = uuidV4();
      info['manifest'] = path.basename(manifestPath);
      info['size'] = size;
      return db.updateAppInfo(info);
    })
    //.then(push(info))
} 
function push(info) {
  console.log('begin push');
  new Promise(function(resolve, reject) {
    var tokens = db.getDeviceTokens(info);
    console.log(tokens);

  });
  console.log('check if async');
 
  return info;
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
      info["bundleId"] = data.CFBundleIdentifier,
      info["version"] = data.CFBundleShortVersionString,
      info["name"] = data.CFBundleDisplayName
      resolve(info)
    });
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


