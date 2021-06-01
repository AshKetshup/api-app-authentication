# API APP Authentication for Swift

## Table of Contents

* [Dependencies](#Dependencies)
* [Installation](#Installation)
* Usage
    * [Server Side](#Usage-Server-Side)
    * [Client Side](#Usage-Client-Side)
    * [Advanced Usage](#Advanced-Usage)
* [Full Documentation](Full_Docs/Home.md)

## Dependencies

* _None_

## Installation

Download the files in latest release, create a folder on the root of your project called `appauth` (this is an example, can be other name), extrat the files into this folder

## Usage Server Side

We assume that the files of this library are in a folder called `appauth` in the root of your project, and your api files are in the root of the project



## Advanced Usage

The most advanced usage provided by this library as of now is the support for a custom signature the signature a string must be passed in the `customsig` argument (check the table of arguments below)

The default string is `{appid}{method}{timestamp}{nonce}{bodyhash}` for the "POST", "PATCH" and "PUT" methods and `{appid}{method}{timestamp}{nonce}` for the "GET", "HEAD" and "DELETE"

You can rearrange this fields as you wish even placing more text between them for example
```swift
var sig_str_body = "{method} for: {appid} on {timestamp} with uuid {nonce} with body hash {bodyhash}"
var sig_str = "{method} for: {appid} on {timestamp} with uuid {nonce}"
```

As long as the placeholders for `method`, `appid`, `timestamp` and `nonce` are present for all methods and `bodyhash` is present for "POST", "PATCH" and "PUT" it will generate a valid signature, just need to inform the developers of the client app what signature to use