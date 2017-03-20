var path = require('path');
var fs = require('fs');
var parentCertFolder = path.join(__dirname, '.playappstore', 'certs');
var child_process = require('child_process');
var underscore = require('underscore');

module.exports = {
  getIP : function () {

    var ipAddress = underscore
    .chain(require('os').networkInterfaces())
    .values()
    .flatten()
    .find(function(iface) {
        return iface.family === 'IPv4' && iface.internal === false;
    })
    .value()
    .address;

    return ipAddress;

  },
  configCerts: function (ip, callback) {
      var options = makeCAAndCert(ip);
      var dirPath = path.join(parentCertFolder, ip);
      callback(options, dirPath);

      //return makeCAAndCert(ip);
  }
};



function makeCAAndCert(ip) {
  var certFolder = path.join(parentCertFolder, ip);
  console.log(certFolder);
  var key;
  var cert;
  var keyPath = path.join(certFolder, 'private.key');
  var certPath = path.join(certFolder, 'cert.cer');
  console.log(keyPath, certPath);
  try {
    key = fs.readFileSync(keyPath, 'utf8');
    cert = fs.readFileSync(certPath, 'utf8');
  } catch (e) {
    var result = child_process.execSync('sh  ' + path.join(__dirname, 'bin', 'make-root-ca-and-certificates.sh') + ' ' + ip).output;
    // var result = exec('sh  ' + path.join(__dirname, 'bin', 'make-root-ca-and-certificates.sh') + ' ' + ip).output;
    console.log(result);
    key = fs.readFileSync(keyPath, 'utf8');
    cert = fs.readFileSync(certPath, 'utf8');
  }

  var options = {
    key: key,
    cert: cert
  };
  return options;
}