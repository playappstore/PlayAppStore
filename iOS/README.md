
## How to build this project

For some codesign reasons, we could not provide you the downloadable package like Apple's App Store does, and we also could not publish this project to the App Store cause the use of private api.

So you should do the build yourself.


### Requirement

1. Development membership
2. fastlane
3. cocoapods

### Step by step

1. Go to Apple's [Developer Website](https://developer.apple.com/account/ios/certificate) and add new App IDS with bunleId like `com.playappstore.ios` and new Provisioning Profiles with this new App ID, also remembered to download them to your local machine.

2. Git clone this repo and goto the `iOS` folder, open the `PlayAppStore.xcworkspace` file with XCode.

3. From Xcode 8, it is recommended to enable Automatic Signing feature when setting up your Xcode project, follow this [guideline](https://docs.fastlane.tools/codesigning/xcode-project/#xcode-8-and-up) to specify the right bundelId and provisioning profile.

4. Open terminal, go to the folder where the `PlayAppStore.xcworkspace` is, and build with:

```
$ fastlane build
```

If everything works as expected, you will find a folder named `fastlane-autobuild` in your desktop.

Cheers!

