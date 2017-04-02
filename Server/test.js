var apns = require('./apns.js');
var DB = require('./realmDB.js');
var db = new DB();

// print process.argv
process.argv.forEach((val, index) => {
  console.log(`${index}: ${val}`);
});


var info = {};
info.platform = 'ios';
info.bundleID = 'com.lashou.StartupCycle.BusinessMembers';

function push(info) {
  console.log('begin push');
  return new Promise(function(resolve, reject) {

    var tokens = db.getDeviceTokens(info);
    console.log(tokens);
    apns.push(tokens);
    resolve(true);
    var string = 'hshs';
    if(typeof(string) === 'number') {
        reject('hehe');
    }
  });
  console.log('check if async');
}
// push(info).then(function(result) {

// }, function(error) {
//     console.log(err);
// });