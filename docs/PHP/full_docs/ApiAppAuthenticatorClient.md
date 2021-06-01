ApiAppAuthenticatorClient
===============

Class that authenticates an app with an API
This class is for the client side of an app




* Class name: ApiAppAuthenticatorClient
* Namespace: \





Properties
----------


### app_id

```
protected mixed app_id
```





* Visibility: **protected**


Methods
-------


### \ApiAppAuthenticatorClient::__construct()

```
mixed ApiAppAuthenticatorClient::\ApiAppAuthenticatorClient::__construct()(mixed app_id)
```

Constructor



* Visibility: **public**

#### Arguments

* app_id **mixed**



### \ApiAppAuthenticatorClient::generate_headers()

```
array ApiAppAuthenticatorClient::\ApiAppAuthenticatorClient::generate_headers()(mixed method, mixed custom_sig)
```

Generates the app authentication headers for the methods GET, DELETE and HEAD



* Visibility: **public**

#### Arguments

* method **mixed**
* custom_sig **mixed**



### \ApiAppAuthenticatorClient::generate_headers_with_body()

```
array ApiAppAuthenticatorClient::\ApiAppAuthenticatorClient::generate_headers_with_body()(mixed body, mixed is_json, mixed method, mixed custom_sig)
```

Generates the app authentication headers for the methods POST, PUT and PATCH



* Visibility: **public**

#### Arguments

* body **mixed**
* is_json **mixed**
* method **mixed**
* custom_sig **mixed**


