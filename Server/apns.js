var apn = require('apn');
const path = require('path');
var keyPath = path.join(__dirname, 'apns.p8');
console.log(keyPath);

var options = {
  token: {
    key: keyPath, // Path to the key p8 file
    keyId: "N4L6HNZW6Q",  // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
    teamId: "4SK4K45JGW" // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
  },
  production: false
};

function test (tokens) {

    var apnProvider = new apn.Provider(options);

    // Enter the device token from the Xcode console
    // var deviceToken = '02ec1068812dd3b377010d86d253d87488a95b876920145467da299096bc9689';

    // Prepare a new notification
    var notification = new apn.Notification();

    // Specify your iOS app's Bundle ID (accessible within the project editor)
    notification.topic = 'com.lashou.StartupCycle.BusinessMembers';

    // Set expiration to 1 hour from now (in case device is offline)
    notification.expiry = Math.floor(Date.now() / 1000) + 3600;

    // Set app badge indicator
    notification.badge = 3;

    // Play ping.aiff sound when the notification is received
    notification.sound = 'ping.aiff';

    // Display the following message (the actual notification text, supports emoji)
    notification.alert = 'Hello World \u270C';

    // Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
    notification.payload = {id: 123};

    // Actually send the notification
    apnProvider.send(notification, tokens).then(function(result) {  
        // Check the result for any failed devices
        console.log(result);

        response.sent.forEach( (token) => {
           // notificationSent(user, token);
        });
        response.failed.forEach( (failure) => {
        if (failure.error) {
            // A transport-level error occurred (e.g. network problem)
           // notificationError(user, failure.device, failure.error);
        } else {
            // `failure.status` is the HTTP status code
            // `failure.response` is the JSON payload
            // notificationFailed(user, failure.device, failure.status, failure.response);
        }
        apnProvider.shutdown();
    });
    });
}


var a = function send () {
    console.log('hello');

}
module.exports = {
    push: function (tokens) {
        return test(tokens);
    },
    send: a

};

