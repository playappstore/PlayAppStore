[![PlayAppStore](https://raw.githubusercontent.com/playappstore/PlayAppStore/develop/assets/logo.JPG)]()

  [![NPM Version][npm-image]][npm-url]
  [![NPM Downloads][downloads-image]][downloads-url]


PlayAppStore is a web service for quickly publising and downloading your own company's iOS apps and Android apps OTA. This project is heavily inspired by the [ipapk-server](https://github.com/zhao0/ipapk-server) repo. It provides you a chance to make it easy for TestFlight Beta Testing.

## Features

- [x] Auto generate sefl-signing HTTPS server for iOS OTA itms-services. 
- [x] Support both web client-side and mobile client-side.
- [x] Full information such as changelog.

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

-h, --help                output usage information
-V, --version             output the version number
-p, --port <port-number>  set port for server (defaults is 1337)
-h, --host <host>         set host for server (defaults is your LAN ip)
```

## Quick Start 

The quickest way to get started with playappstore is to utilize the default parameters (such as port and host) to generate a server as shown below:

```
$ playappstore
```

To publish an app is very simple, here is an example to request with curl:

```
$ curl 'https://ip:port/apps' -F "package=@path" -F "changelog=some feature" --insecure

```

Note that you should change the `ip` and `port` variables with your owns, and the path variable must be the file path where the ipa or apk is.

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





