var fs = require('fs');  
var path = require('path');  
var mustache = require('mustache');
var util = require('util')

module.exports = {
  generate : function (app, output) {
    return generateManifest(app, output);
  },
  render: function(input, basePath) {
    return renderManifest(input, basePath)
  }
}

function generateManifest(app, output) {

  return new Promise(function(resolve, reject) {
    var filepath = path.join(__dirname, 'templates', 'template.plist');
    fs.readFile(filepath, function(err, data) {
      if (err) {reject(err)};

      var template = data.toString();
      var rendered = mustache.render(template, {
        name: app['name'],
        bundleID: app['bundleID'],
        path:  util.format('{{{basePath}}}/%s', app['package']),
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

function renderManifest(input, basePath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(input, function(err, data) {
      if (err) {reject(err)};

      var template = data.toString();
      var rendered = mustache.render(template, {
        basePath: basePath + 'app'
      });
      resolve(rendered);     
    });
  })
}





