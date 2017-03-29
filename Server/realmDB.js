'use strict';

var Realm = require('realm');
var util = require('util')
var fs = require('fs');
var os = require('os');

Realm.defaultPath = os.homedir() + "/.playappstore/realm/default.realm"

const AppIconSchema = {
  name: 'AppIcon',
  primaryKey: 'bundleID',
  primaryKey: 'version',
  primaryKey: 'platform',
  properties: {
    bundleID:  'string', // 
    version: 'string',
    platform: 'string', // ios or android
    icon: 'string', // icon path
    name: {type: 'string', optional: true},
    createAt: {type: 'date',  default: new Date()},
    updateAt: {type: 'date',  default: new Date()},
  }
};

const AppRecordSchema = {
  name: 'AppRecord',
  primaryKey: 'bundleID',
  primaryKey: 'platform',
  properties: {
    bundleID:  'string', // 
    platform: 'string', // ios or android
    version: 'string',
    name: 'string',
    icon: 'string', // icon path
    createAt: {type: 'date',  default: new Date()},
    updateAt: {type: 'date',  default: new Date()},
  }
};

const AppInfoSchema = {
  name: 'AppInfo',
  properties: {
    objectId: 'string',
    bundleID:  'string', 
    version: 'string',
    build: {type: 'string', optional: true}, // build version 
    name: 'string', // app name
    icon: 'string', // icon path
    size: 'string', // package size
    package: 'string', // package download url
    platform: 'string', // ios or android
    manifest: {type: 'string', optional: true}, // ios only, for itms-service download 
    createAt: {type: 'date',  default: new Date()},
    updateAt: {type: 'date',  default: new Date()},
  }
};

var realm = new Realm({schema: [AppIconSchema, AppRecordSchema, AppInfoSchema]});


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
        console.log(app);
    realm.write(() => {
      appInfo = realm.create('AppInfo', app, true);
    });
    resolve(appInfo);
  });

}
RealmDB.prototype.findAppIcon = function(app) {
      
  var filter = util.format('bundleID = "%s" AND version = "%s"', app.bundleID, app.version);
  console.log(filter);
  var icons = realm.objects('AppIcon').filtered(filter);
  if (icons.length > 0) {
    return icons[0].icon;
  } else {
    return "";
  }
}
RealmDB.prototype.getRecords = function (platform) {

  var filter = util.format('platform = "%s"', platform);
  console.log(filter);
  var records = realm.objects('AppRecord').filtered(filter);
  return records;
}

RealmDB.prototype.getAppInfos = function (platform, bundleID, page, count) {
  page = typeof page  !== 'undefined' ? page : 1;
  count = typeof count !== 'undefined' ? count : 10;

  var filter = util.format('platform = "%s" AND bundleID = "%s"', platform, bundleID);
  console.log(filter);
  var infos = realm.objects('AppRecord').filtered(filter);
  // for pagination
  var start = (page-1)*count;
  var firstInfos = infos.slice(start, page);
  return firstInfos;
}


module.exports = RealmDB;
