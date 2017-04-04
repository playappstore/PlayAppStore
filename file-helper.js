var fs = require('fs');
var os = require('os');

var serverDir = os.homedir() + "/.playappstore/"
var appDir = serverDir + "app/";
var iconDir = serverDir + "icon/";
var manifestDir = serverDir + 'manifest/'

function createFolderIfNeeded (path) {
  if (!fs.existsSync(path)) {  
    fs.mkdirSync(path, function (err) {
        if (err) {
            console.log(err);
            return;
        }
    });
  }
}

function FileHelper() {
    createFolderIfNeeded(serverDir)
    createFolderIfNeeded(appDir)
    createFolderIfNeeded(iconDir)
    createFolderIfNeeded(manifestDir)
    this.appDir = appDir;
    this.iconDir = iconDir;
    this.manifestDir = manifestDir;
}

FileHelper.prototype.rename = function(input, output) {

  return new Promise(function(resolve, reject) {
    fs.rename(input, output, function(err) {
      if (err) reject(err);
      resolve(output);
    })
  });

}
module.exports = FileHelper;

