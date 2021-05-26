# API APP Authentication for Python

## Table of Contents

* [Dependencies](#Dependencies)
* Installation
    * [Server Side](#Installation-Server-Side)
    * [Client Side](#Installation-Client-Side)
* Usage
    * [Server Side](#Usage-Server-Side)
        * **[Class Documentation](AppAuthenticationServer.md)**
    * [Client Side](#Usage-Client-Side)
        * **[Class Documentation](AppAuthenticationClient.md)**
    * [Advanced Usage](#Advanced-Usage)

## Dependencies

_None_

## Installation Server Side

Get the latest [release](https://api.github.com/repos/pedrocavaleiro/api-app-authentication/releases/latest) for Python

Import the file `AppAuth.swift` located on the `Server` folder onto your project

## Installation Client Side

Import the file `AppAuth.swift` located on the `Client` folder onto your project

## Usage Server Side

**File documentation for [client side](appauth_server.md)**

First and foremost import the required files and initialize the library
```python
# make sure to import everything since there are exceptions referenced in this file
from appauth import *
# it's assumed that there is one variable 'apps' representing an array of tuples with the app id and app key [(appid, appkey)]
try:
    appAuth = AppAuthenticationServer(apps)
except  (NoAppsProvided) as ex:
    print(ex.message)
```

Now with the library initialized we can start authorizing apps, the below example is for servers using Flask

```python
# POST request
@app.route("/auth/login", methods=['POST'])
def login():
    try:
        ok = appAuth.authenticateApp(request.headers, request.method, dict(request.form))
        if not ok:
            return json.dumps({ "error": "Unknown error authenticating app" }) # this should never happen
    except (InvalidAppAuthenticationChallenge, AppAuthHeaderNotFound, AppIdNotFound, InvalidBody, InvalidMethod) as ex:
        return json.dumps({ "error": ex.message })
    
    # rest of the code

# GET request
@app.route("/user/email/", methods=['GET'])
def getEmail():
    try:
        ok = appAuth.authenticateApp(request.headers, request.method)
        if not ok:
            return json.dumps({ "error": "Unknown error authenticating app" })
    except (InvalidAppAuthenticationChallenge, AppAuthHeaderNotFound, AppIdNotFound, InvalidMethod) as ex:
        return json.dumps({ "error": ex.message })
        
    # rest of the code
```

## Usage Client Side

**File documentation for [client side](appauth_client.md)**

First and foremost import the required files and initialize the library
```python
# make sure to import everything since there are exceptions referenced in this file
from appauth import *

class App(object):
    def __init__(self):
        # during the initialization of the class we must pass the app id and the app key
        # it's up to the developer to keep the app key stored safely
        self._appauth = AppAuthenticationClient(appid, appkey)
```

Now with the library initialized we can start performing requests, the example will use the requests library from python.

The library provides two methods to generate the headers, one method to generate headers for methods as "GET", "HEAD" and "DELETE", that method is `generateHeaderWitoutBody` and for methods "POST", "PATCH" and "PUT" `generateHeaderWithBody`

```python
# a request with body
def loginUser(self, username, password):
        data = {
            'username' : str(username),
            'password' : str(password)
        }

        try:
             headers = self._appauth.generateHeaderWithBody(data, "POST")
        except (InvalidMethod, InvalidBody) as ex:
             print(ex.message)

        r = requests.post(
            url=f"{self._url}/auth/login",
            data=data,
            headers=headers
        )
        # rest of the code

# request without a body
def getEmail(self, id_user):
        try:
             headers = self._appauth.generateHeaderWithoutBody(data, "GET")
        except (InvalidMethod) as ex:
             print(ex.message)

        r = requests.get(
            url=f"{self._url}/user/email",
            params={'id' : id_user},
            headers=self._appauth.generateGetHeader()
        )
        
        # rest of the code
```

## Advanced Usage

The most advanced usage provided by this library as of now is the support for a custom signature the signature a string must be passed in the `customsig` argument (check the table of arguments below)

The default string is `{appid}{method}{timestamp}{nonce}{bodyhash}` for the "POST", "PATCH" and "PUT" methods and `{appid}{method}{timestamp}{nonce}` for the "GET", "HEAD" and "DELETE"

You can rearrange this fields as you wish even placing more text between them for example
```python
sig_str_body = "{method} for: {appid} on {timestamp} with uuid {nonce} with body hash {bodyhash}"
sig_str = "{method} for: {appid} on {timestamp} with uuid {nonce}"
```

As long as the placeholders for `method`, `appid`, `timestamp` and `nonce` are present for all methods and `bodyhash` is present for "POST", "PATCH" and "PUT" it will generate a valid signature, just need to inform the developers of the client app what signature to use