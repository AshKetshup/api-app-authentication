ApiAppAuthenticatorServer
===============






* Class name: ApiAppAuthenticatorServer
* Namespace: \





Properties
----------


### authorized_apps

```
protected mixed authorized_apps
```





* Visibility: **protected**


Methods
-------


### \ApiAppAuthenticatorServer::__construct()

```
mixed ApiAppAuthenticatorServer::\ApiAppAuthenticatorServer::__construct()(mixed authorized_apps)
```

Constructor



* Visibility: **public**

#### Arguments

* authorized_apps **mixed**



### \ApiAppAuthenticatorServer::authenticate_app()

```
mixed ApiAppAuthenticatorServer::\ApiAppAuthenticatorServer::authenticate_app()(mixed headers, mixed method, mixed custom_sig)
```

Authenticates the app with the api for the methods GET, HEAD and DELETE



* Visibility: **public**

#### Arguments

* headers **mixed**
* method **mixed**
* custom_sig **mixed**



### \ApiAppAuthenticatorServer::authenticate_app_with_body()

```
mixed ApiAppAuthenticatorServer::\ApiAppAuthenticatorServer::authenticate_app_with_body()(mixed headers, mixed body, mixed is_json, mixed method, mixed custom_sig)
```

Authenticates the app with the api for the methods GET, HEAD and DELETE



* Visibility: **public**

#### Arguments

* headers **mixed**
* body **mixed**
* is_json **mixed**
* method **mixed**
* custom_sig **mixed**



### \ApiAppAuthenticatorServer::headers_present()

```
bool ApiAppAuthenticatorServer::\ApiAppAuthenticatorServer::headers_present()(mixed headers)
```

Checks if all headers are present



* Visibility: **private**

#### Arguments

* headers **mixed**


