var fs = require('fs');  
var path = require('path');  
var mustache = require('mustache');



module.exports = {
  generate : function (app, output) {

    return renderManifest(app, output);
  }
}

function renderManifest(app, output) {

  return new Promise(function(resolve, reject) {
    var filepath = path.join(__dirname, 'templates', 'template.plist');
    fs.readFile(filepath, function(err, data) {
      if (err) {reject(err)};

      var template = data.toString();
      var rendered = mustache.render(template, {
        name: app['name'],
        bundleID: app['bundleID'],
        url: app['package'],
        version: app['version'],
      });

      var buffer = new Buffer(rendered);
      fs.writeFile(output, buffer, function(err){  
        if(err) {
          reject(err);
        }
        resolve(output);
      });
    });
  })
}





