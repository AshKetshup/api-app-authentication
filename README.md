# API App Authentication

A simple library written in multiple languages to authenticate a Client App with an API

Currently supported languages:

* Python
* Swift

## Requirements

To use this library there are the following requirements besides the requirements for each language

* An SQL server with a table to store the AppIDs and AppKeys, more information can be stored as well app privileges for different app privileges, this is not covered by this library.

* Ability to redirect the headers `X-Req-Timestamp`, `X-Req-Nonce`, `X-Req-Sig` and `X-App-Id` if using a web server as proxy

## Concept

You can find the concept behind this library [here](docs/concept.md)

## Documentation

You can find the documentation per language here:

* Python - Under Construction
* [Swift](docs/Swift/README.md)
    * [AppAuth.swift (server)](docs/Swift/AppAuthenticationServer.md)
    * [AppAuth.swift (client)](docs/Swift/AppAuthenticationClient.md)