var fs = require('fs-extra');  
var path = require('path');  
var mustache = require('mustache');
var Parse = require('parse/node');



module.exports = {
  generate : function (app) {

    return renderManifest(app);
  }
}

function renderManifest(app) {

  return new Promise(function(resolve, reject) {
    var filepath = path.join(__dirname, 'templates', 'template.plist');
    fs.readFile(filepath, function(err, data) {
      if (err) {reject(err)};

      var template = data.toString();
      var rendered = mustache.render(template, {
        name: app.get('name'),
        bundleID: app.get('bundleID'),
        url: app.get('package')['url'],
        version: app.get('version'),
      });

      var base64 = {
        base64: new Buffer(rendered).toString('base64')
      };
      var parseFile = new Parse.File('manifest.plist', base64);
      parseFile.save().then(function() {
        resolve(parseFile);
      }, function(err) {
        console.log('manifest fail, ' + err.message);
        reject(err);
      });
    });
  });
}





