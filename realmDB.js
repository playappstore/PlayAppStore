'use strict';

var Realm = require('realm');
var util = require('util')
var fs = require('fs');
var os = require('os');

Realm.defaultPath = os.homedir() + "/.playappstore/realm/default.realm"

const AppIconSchema = {
  name: 'AppIcon',
  primaryKey: 'primaryKey',
  properties: {
    primaryKey: 'string', // compound primaryKey, format like [B:bundleId][P:platform][V:version]
    bundleId:  'string', // 
    version: 'string',
    platform: 'string', // ios or android
    icon: 'string', // icon path
    name: {type: 'string', optional: true},
    createdAt: {type: 'date',  default: new Date()},
    updatedAt: {type: 'date',  default: new Date()},
  }
};

const AppRecordSchema = {
  name: 'AppRecord',
  primaryKey: 'primaryKey',
  properties: {
    primaryKey: 'string', // compound primaryKey, format like [B:bundleId][P:platform]
    bundleId:  'string', // 
    platform: 'string', // ios or android
    version: 'string',
    name: 'string',
    icon: 'string', // icon path
    createdAt: {type: 'date',  default: new Date()},
    updatedAt: {type: 'date',  default: new Date()},
  }
};

const AppInfoSchema = {
  name: 'AppInfo',
  primaryKey: 'objectId',
  properties: {
    objectId: 'string',
    bundleId:  'string', 
    version: 'string',
    description: {type: 'string', optional: true}, // short des for the app.
    build: {type: 'string', optional: true}, // build version 
    changelog: {type: 'string', optional: true}, // changelog 
    lastCommitMsg: {type: 'string', optional: true}, // last git commit message
    jenkinsChangelog: {type: 'string', optional: true}, // changelog from jenkins since last build
    name: 'string', // app name
    icon: 'string', // icon path
    size: 'string', // package size
    package: 'string', // package download url
    platform: 'string', // ios or android
    manifest: {type: 'string', optional: true}, // ios only, for itms-service download 
    createdAt: {type: 'date',  default: new Date()},
    updatedAt: {type: 'date',  default: new Date()},
  }
};


const DeviceSchema = {
  name: 'Device', 
  primaryKey: 'uuid',
  properties: {
    uuid: 'string',
    platform: 'string',
    apnsToken:{type: 'string', optional: true},  // apns device token
    followed: {type: 'list', objectType:'AppRecord'},
    activitedAt: {type: 'date', default: new Date()},
    createdAt: {type: 'date',  default: new Date()},
    updatedAt: {type: 'date',  default: new Date()},
  }
}

var realm = new Realm({schema: [AppIconSchema, AppRecordSchema, AppInfoSchema, DeviceSchema]});

function RealmDB() {
}

RealmDB.prototype.updateAppIcon = function(app) {
  return new Promise(function(resolve, reject) {
    var appIcon;
    realm.write(() => {
      appIcon = realm.create('AppIcon', app, true);
    });
    resolve(appIcon);
  });
}
RealmDB.prototype.updateAppRecord = function(app) {
  return new Promise(function(resolve, reject) {
    var appRecord;
    realm.write(() => {
      appRecord = realm.create('AppRecord', app, true);
    });
    resolve(appRecord);
  });
}

RealmDB.prototype.updateAppInfo = function(app) {
  return new Promise(function(resolve, reject) {
    var appInfo;
    realm.write(() => {
      appInfo = realm.create('AppInfo', app, true);
    });
    resolve(appInfo);
  });

}
RealmDB.prototype.findAppIcon = function(app) {
      
  var filter = util.format('bundleId = "%s" AND version = "%s"', app.bundleId, app.version);
  var icons = realm.objects('AppIcon').filtered(filter);
  if (icons.length > 0) {
    return icons[0].icon;
  } else {
    return "";
  }
}
RealmDB.prototype.getRecords = function(platform) {

  var filter = util.format('platform = "%s"', platform);
  var records = realm.objects('AppRecord').filtered(filter);
  // for set property values out a transaction.
  var mappedArray = records.map(function(record) {
    return JSON.parse(JSON.stringify(record));
  })
  return mappedArray;
}

RealmDB.prototype.getAppVersions = function(platform, bundleId, page, count) {
  page = typeof page  !== 'undefined' ? page : 1;
  count = typeof count !== 'undefined' ? count : 10;

  var filter = util.format('platform = "%s" AND bundleId = "%s"', platform, bundleId);
  var infos = realm.objects('AppInfo').filtered(filter).sorted('updatedAt', true);
  // for pagination
  var start = (page-1)*count;
  var firstInfos = infos.slice(start, count);

  var fields = ['objectId', 'bundleId', 'changelog', 'version', 'build', 'name', 'icon', 'size', 'platform', 'manifest', 'createdAt', 'updatedAt'];
  var mappedArray = firstInfos.map(function(info) {
    var app = {};
    fields.forEach(function(key) {
      app[key] = info[key];
    });
    return app;
  })
  return mappedArray;
}

RealmDB.prototype.getAppDetail = function(platform, bundleId, objectId) {
 
  var infos = realm.objects('AppInfo').filtered('platform = $0 AND bundleId = $1 AND objectId = $2', platform, bundleId, objectId);
  var fields = ['objectId', 'bundleId', 'changelog', 'lastCommitMsg', 'jenkinsChangelog', 'version', 'build', 'name', 'icon', 'size', 'platform', 'manifest', 'createdAt', 'updatedAt'];
  var mappedArray = infos.map(function(info) {
    var app = {};
    fields.forEach(function(key) {
      app[key] = info[key];
    });
    return app;
  })
  return mappedArray;
}
RealmDB.prototype.getAppInfos = function(platform, page, count) {
  page = typeof page  !== 'undefined' ? page : 1;
  count = typeof count !== 'undefined' ? count : 10;
  var infos = realm.objects('AppInfo').filtered('platform = $0', platform);
  // for pagination
  var start = (page-1)*count;
  var firstInfos = infos.slice(start, count);
  var mappedArray = firstInfos.map(function(info) {
    return JSON.parse(JSON.stringify(info));
  })
  return mappedArray;
}
/// action: 1 for follow, 0 for unfollow.
RealmDB.prototype.updateDevice = function(device, bundleId, action) {
  return new Promise(function(resolve, reject) {
    var result;
    realm.write(() => {
      result = realm.create('Device', device, true);
      if (bundleId === 'undefined') {
        return;
      }
      var records = realm.objects('AppRecord').filtered('bundleId = $0 AND platform = $1', bundleId, 'ios');
      if (records.length == 0) { 
        return;
      }
      var contain = result.followed.filtered('bundleId = $0', bundleId).length > 0;
      if (action === '1') {
        // if this record not in the followed list, then push it.
        if (!contain) {
          result.followed.push(records[0]);
        }
      }
      if (action === '0') {
        // otherwise, remove it from the list
        if (contain) {
          var index = result.followed.findIndex(function(obj, index, collection) {
            if (obj.bundleId === bundleId) {
              return true;
            }
            return false;
          })
          result.followed.splice(index, 1);
        }
      }
    });
    resolve(result);
  });
}

RealmDB.prototype.getFolloweds = function(deviceID, platform) {

  var records = realm.objects('Device').filtered('uuid = $0 AND platform = $1', deviceID, platform);
  if (records.length > 0) {
    var device = records[0];
    var followeds = device.followed;
    // for set property values out a transaction.
    var mappedArray = followeds.map(function(record) {
      return JSON.parse(JSON.stringify(record));
    })
    return mappedArray;
  } else {
    return [];
  }
}
RealmDB.prototype.getDeviceTokens = function(info) {
  // use info's bundleId and platform
  var records = realm.objects('Device').filtered('platform = $0 AND followed.bundleId = $1', info.platform, info.bundleId);
  var mappedArray = records.map(function(device) {
    if (typeof(device.apnsToken) === 'string') {
      return device.apnsToken;
    }
  })
  return mappedArray;
}

module.exports = RealmDB;
