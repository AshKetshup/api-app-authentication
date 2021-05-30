# API App Authentication

A simple library written in multiple languages to authenticate a Client App with an API

Currently supported languages:

* Python
* Swift

## Requirements

To use this library there are the following requirements besides the requirements for each language

* An SQL server with a table to store the AppIDs and AppKeys, more information can be stored as well app privileges for different app privileges, this is not covered by this library.

* Ability to redirect the headers `X-Req-Timestamp`, `X-Req-Nonce`, `X-Req-Sig` and `X-App-Id` if using a web server as proxy

## Root File Structure

This repository contains multiple languages, in order to provide ease of install some folders must be added to the root

* `Root`
    * `.github`: Contains the issues templates for GitHub
    * `Sources`: The source code for the Swift Package (also available on the `src/Swift` folder)
    * `Tests`: The tests folders for the Swift Package (it's required by SPM, also available on the `src/Swift` folder)
    * `docs`: Folder containing all documentation for all languages
    * `src`: Source code for all languages including the swift package
        * `Python`: Source code for the Python version
        * `Swift`: Source code for the Swift version
        * `CSharp`: Source code for the C#
    * `bin`: Contains the binaries for the supported languages
        * `CSharp`: The binary files for the C# version
    * `.gitignore`: The git ignore file
    * `LICENSE`: The repository license
    * `Package.swift`: The manifest file for the Swift Package
    * `README.md`: The readme file

## Concept

You can find the concept behind this library [here](docs/concept.md)

## Documentation

You can find the documentation per language here:

* [Python](docs/Python/README.md)
    * [appauth.py (server)](docs/Python/appauth_server.md)
    * [appauth.py (client)](docs/Python/appauth_client.md)
* [Swift](docs/Swift/README.md)
    * [Full library documentation](docs/Swift/Home.md)
* [C#](docs/CSharp/README.md)
    * [Full library documentation (.NET 5)](docs/CSharp/net5_fulldoc.md)
    * [Full library documentation (.NET Core / .NET Framework)](docs/CSharp/netcore_fulldoc.md)