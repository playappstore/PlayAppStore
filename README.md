[![PlayAppStore](https://raw.githubusercontent.com/playappstore/PlayAppStore/develop/assets/logo.JPG)]()

  [![NPM Version][npm-image]][npm-url]
  [![NPM Downloads][downloads-image]][downloads-url]


PlayAppStore is a web service for quickly publising and downloading your own company's iOS apps and Android apps OTA. This project is heavily inspired by the [ipapk-server](https://github.com/zhao0/ipapk-server) repo. It provides you a chance to make it easy for  Beta Testing.

## Why called PlayAppStore

We blieved that the best way to install an app for beta testing is via a package management app like the iPhone's App Store app or the Android's Play Store app, so we dicided to develop these two native apps for different platform to do the same things, and named this project PlayAppStore :-D  

Here is a preview for iOS side:

<p align="left">

<img src="https://raw.githubusercontent.com/playappstore/playappstore/develop/assets/ios_screenshot_01.png" width="280" height="498"/>

<img src="https://raw.githubusercontent.com/playappstore/playappstore/develop/assets/ios_screenshot_02.png" width="280" height="498"/>

</p>

## Features

- [x] Auto generate sefl-signing HTTPS server for iOS OTA itms-services. 
- [x] Support both web client-side and mobile client-side.
- [x] Full information such as changelog.
- [ ] Push notification for new build.

## Requirements

- nodejs

## Install

```
$ npm install -g playappstore
```

## Usage

```
$ playappstore [option]

Options:

-h, --help                 output usage information
-V, --version              output the version number
-p, --port <port-number>   set port for server (defaults is 9090)
-h, --host <host>          set host for server (defaults is your LAN ip)
-h, --config <config-file> set the config json file path
```

## Quick Start 

The quickest way to get started with playappstore is to utilize the default parameters (such as port and host) to generate a server as shown below:

```
$ playappstore
```

In this situation, we will auto generate self-signed certificate for you. Otherwise, if you already have a certificate, it is recommend to config the certificate with a json file:

```
$ playappstore -c "path/to/config.json"
```
You can see the details of the config file from this [wiki](https://github.com/playappstore/PlayAppStore/wiki/Config-file-example).


To publish an app is very simple, here is an example to request with curl:

```
$ curl 'https://host:port/apps' -F "package=@path" -F "changelog=some feature" --header "MasterKey: playappstore" --insecure
```

Note that you should change the `host` and `port` variables with your owns, and the path variable must be the file path where the ipa or apk is.

### For iOS Side

For some code sign reasons, we could not provide you the downloadable ipa package, and we also could not publish this project to the App Store cause the use of private api.

Follow this [guideline](iOS/README.md) to do the build manually.


### For Android Side

Just under development, will release as fast as we can.

### For Web Side

Just visit this url `https://host:port/` in your mobile browser.

## Docs & Community

* Visit the [wiki](https://github.com/playappstore/playappstore/wiki) for all REST full api.
* Please fell free to submit pull request, also submit a [issue](https://github.com/playappstore/playappstore/issue/new) if you have any questions.


## Contributors


- [@red3](https://github.com/red3)
- [@endust](https://github.com/endust)
- [@dearkong](https://github.com/dearkong)
- [@jasonhantao](https://github.com/jasonhantao)
- [@zhao0](https://github.com/zhao0)
- [@mask2](https://github.com/mask2)



## License

PlayAppStore is released under the MIT license. See LICENSE for details.


[npm-image]: https://img.shields.io/npm/v/playappstore.svg
[downloads-image]: https://img.shields.io/npm/dm/playappstore.svg
[npm-url]: https://npmjs.org/package/playappstore
[downloads-url]: https://npmjs.org/package/playappstore





