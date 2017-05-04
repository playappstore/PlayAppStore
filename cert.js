var path = require('path');
var fs = require('fs');
var uuidV4 = require('uuid/v4');
var parentCertFolder = require('os').homedir() + "/.playappstore/certs"
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
      var caPath = path.join(parentCertFolder, 'ca/certs/my-root-ca.cer');
      callback(options, dirPath, caPath);

      //return makeCAAndCert(ip);
  }
};



function makeCAAndCert(ip) {
  var certFolder = path.join(parentCertFolder, ip, '/');
  var key;
  var cert;
  var keyPath = path.join(certFolder, 'private.key');
  var certPath = path.join(certFolder, 'cert.cer');
  try {
    key = fs.readFileSync(keyPath, 'utf8');
    cert = fs.readFileSync(certPath, 'utf8');
  } catch (e) {
    var uuid = uuidV4()
    var result = child_process.execSync('sh  ' + path.join(__dirname, 'bin', 'make-root-ca-and-certificates.sh') + ' ' + ip + ' ' + parentCertFolder + ' ' + uuid).output;
    key = fs.readFileSync(keyPath, 'utf8');
    cert = fs.readFileSync(certPath, 'utf8');
  }

  var options = {
    key: key,
    cert: cert
  };
  return options;
}