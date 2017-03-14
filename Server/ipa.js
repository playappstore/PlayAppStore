var Parse = require('parse/node');
var path = require('path');
var fs = require('fs');
var pngdefry = require('pngdefry');
var AdmZip = require("adm-zip");
var uuidV4 = require('uuid/v4');
var util = require('util')
var extract = require('ipa-extract-info');
var Manifest = require('./manifest.js');
var DB = require('./dbhelper')
var pretty = require('prettysize');
var tmp_dir = path.join(__dirname, 'tmp_file');

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
  getAllApps: function (platform) {
    return allApps(platform);
  },
  getAllVersions: function (bundleID, page, count) {

  }

};

function allApps(platform, page, count)  {
  // usaully, a company may not have more than 20 apps.
  var page = 1;
  var count = 100;
  var promise = DB.groupby('bundleID');
  return promise.then(function(result) {
    var bundleIDArray = result;
    var taskArray = bundleIDArray.map(findApp);
    return Promise.all(taskArray)
      .then(values => {
        return values;
      }, reason => {
        console.log(reason);
        return Promise.reject(reason);
    });
  });
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

function publishIpa(file) {
    // 1. save icon 2. parse info.plist 3. save ipa
    var filepath = file.path;
    var size =  pretty(file.size);
    var save_icon = extractAndSaveIpaIcon(filepath);
    var parse_info = parseIpa(filepath);
    var save_ipa = saveFile(filepath, 'app.ipa');
    return Promise.all([save_icon, parse_info, save_ipa])
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

        var promise = Manifest.generate(app);
        return promise.then(function(manifestFile) {

          app.set('manifest', manifestFile);
          app.save(null, {
            success: function(app) {
              resolve(app);
            },
            error: function(obj, err) {
              reject(err);
            }
          });
        });

      });

    }, reason => {
      console.log(reason);
      return Promise.reject(reason);
    });
} 

function publishApk(file) {
  console.log('publishApk');
  
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


// var path = path.join(__dirname) + "/xxx.ipa";
// console.log(path);

// var p = test(path).then(function(info) {
//   console.log(info);

// });

// var p = parseIpa(path).then(function(info) {
//   console.log(info);
// });




