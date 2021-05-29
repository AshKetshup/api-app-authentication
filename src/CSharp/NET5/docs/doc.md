<a name='assembly'></a>
# AppApiAuthenticator

## Contents

- [AppIdNotFoundException](#T-AppApiAuthenticator-Server-AppIdNotFoundException 'AppApiAuthenticator.Server.AppIdNotFoundException')
  - [#ctor()](#M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor 'AppApiAuthenticator.Server.AppIdNotFoundException.#ctor')
  - [#ctor(message)](#M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor-System-String- 'AppApiAuthenticator.Server.AppIdNotFoundException.#ctor(System.String)')
  - [#ctor(message,inner)](#M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor-System-String,System-Exception- 'AppApiAuthenticator.Server.AppIdNotFoundException.#ctor(System.String,System.Exception)')
- [Authorizor](#T-AppApiAuthenticator-Client-Authorizor 'AppApiAuthenticator.Client.Authorizor')
  - [#ctor(appId,appKey)](#M-AppApiAuthenticator-Client-Authorizor-#ctor-System-String,System-String- 'AppApiAuthenticator.Client.Authorizor.#ctor(System.String,System.String)')
  - [appId](#F-AppApiAuthenticator-Client-Authorizor-appId 'AppApiAuthenticator.Client.Authorizor.appId')
  - [appKey](#F-AppApiAuthenticator-Client-Authorizor-appKey 'AppApiAuthenticator.Client.Authorizor.appKey')
  - [generateHeader(method,customSig)](#M-AppApiAuthenticator-Client-Authorizor-generateHeader-AppApiAuthenticator-Common-GetMethods,System-String- 'AppApiAuthenticator.Client.Authorizor.generateHeader(AppApiAuthenticator.Common.GetMethods,System.String)')
  - [generateHeader\`\`1(body,method,isJson,customSig)](#M-AppApiAuthenticator-Client-Authorizor-generateHeader``1-``0,AppApiAuthenticator-Common-PostMethods,System-Boolean,System-String- 'AppApiAuthenticator.Client.Authorizor.generateHeader``1(``0,AppApiAuthenticator.Common.PostMethods,System.Boolean,System.String)')
- [Authorizor\`1](#T-AppApiAuthenticator-Server-Authorizor`1 'AppApiAuthenticator.Server.Authorizor`1')
  - [#ctor(apps)](#M-AppApiAuthenticator-Server-Authorizor`1-#ctor-System-Collections-Generic-List{`0}- 'AppApiAuthenticator.Server.Authorizor`1.#ctor(System.Collections.Generic.List{`0})')
  - [apps](#F-AppApiAuthenticator-Server-Authorizor`1-apps 'AppApiAuthenticator.Server.Authorizor`1.apps')
  - [authenticateApp(headers,method,customSig)](#M-AppApiAuthenticator-Server-Authorizor`1-authenticateApp-System-Collections-Generic-Dictionary{System-String,System-String},AppApiAuthenticator-Common-PostMethods,System-String- 'AppApiAuthenticator.Server.Authorizor`1.authenticateApp(System.Collections.Generic.Dictionary{System.String,System.String},AppApiAuthenticator.Common.PostMethods,System.String)')
  - [authenticateApp\`\`1(headers,body,method,isJson,customSig)](#M-AppApiAuthenticator-Server-Authorizor`1-authenticateApp``1-System-Collections-Generic-Dictionary{System-String,System-String},``0,AppApiAuthenticator-Common-PostMethods,System-Boolean,System-String- 'AppApiAuthenticator.Server.Authorizor`1.authenticateApp``1(System.Collections.Generic.Dictionary{System.String,System.String},``0,AppApiAuthenticator.Common.PostMethods,System.Boolean,System.String)')
  - [headersPresent(headers)](#M-AppApiAuthenticator-Server-Authorizor`1-headersPresent-System-Collections-Generic-Dictionary{System-String,System-String}- 'AppApiAuthenticator.Server.Authorizor`1.headersPresent(System.Collections.Generic.Dictionary{System.String,System.String})')
- [Common](#T-AppApiAuthenticator-Common 'AppApiAuthenticator.Common')
  - [replacePlaceholders(signature,values)](#M-AppApiAuthenticator-Common-replacePlaceholders-System-String@,System-Collections-Generic-Dictionary{System-String,System-String}- 'AppApiAuthenticator.Common.replacePlaceholders(System.String@,System.Collections.Generic.Dictionary{System.String,System.String})')
- [Crypto](#T-AppApiAuthenticator-Crypto 'AppApiAuthenticator.Crypto')
  - [calculateHMACSha256(text,key)](#M-AppApiAuthenticator-Crypto-calculateHMACSha256-System-String,System-String- 'AppApiAuthenticator.Crypto.calculateHMACSha256(System.String,System.String)')
  - [calculateSha256(text)](#M-AppApiAuthenticator-Crypto-calculateSha256-System-String- 'AppApiAuthenticator.Crypto.calculateSha256(System.String)')
- [GetMethods](#T-AppApiAuthenticator-Common-GetMethods 'AppApiAuthenticator.Common.GetMethods')
  - [DELETE](#F-AppApiAuthenticator-Common-GetMethods-DELETE 'AppApiAuthenticator.Common.GetMethods.DELETE')
  - [GET](#F-AppApiAuthenticator-Common-GetMethods-GET 'AppApiAuthenticator.Common.GetMethods.GET')
  - [HEAD](#F-AppApiAuthenticator-Common-GetMethods-HEAD 'AppApiAuthenticator.Common.GetMethods.HEAD')
- [Header](#T-AppApiAuthenticator-Server-Authorizor`1-Header 'AppApiAuthenticator.Server.Authorizor`1.Header')
- [IAppDbModel](#T-AppApiAuthenticator-Interfaces-IAppDbModel 'AppApiAuthenticator.Interfaces.IAppDbModel')
  - [AppAuthID](#P-AppApiAuthenticator-Interfaces-IAppDbModel-AppAuthID 'AppApiAuthenticator.Interfaces.IAppDbModel.AppAuthID')
  - [Key](#P-AppApiAuthenticator-Interfaces-IAppDbModel-Key 'AppApiAuthenticator.Interfaces.IAppDbModel.Key')
- [InvalidChallengeException](#T-AppApiAuthenticator-Server-InvalidChallengeException 'AppApiAuthenticator.Server.InvalidChallengeException')
  - [#ctor()](#M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor 'AppApiAuthenticator.Server.InvalidChallengeException.#ctor')
  - [#ctor(message)](#M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor-System-String- 'AppApiAuthenticator.Server.InvalidChallengeException.#ctor(System.String)')
  - [#ctor(message,inner)](#M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor-System-String,System-Exception- 'AppApiAuthenticator.Server.InvalidChallengeException.#ctor(System.String,System.Exception)')
- [InvalidEnumException](#T-AppApiAuthenticator-InvalidEnumException 'AppApiAuthenticator.InvalidEnumException')
  - [#ctor()](#M-AppApiAuthenticator-InvalidEnumException-#ctor 'AppApiAuthenticator.InvalidEnumException.#ctor')
  - [#ctor(message)](#M-AppApiAuthenticator-InvalidEnumException-#ctor-System-String- 'AppApiAuthenticator.InvalidEnumException.#ctor(System.String)')
  - [#ctor(message,inner)](#M-AppApiAuthenticator-InvalidEnumException-#ctor-System-String,System-Exception- 'AppApiAuthenticator.InvalidEnumException.#ctor(System.String,System.Exception)')
- [MissingHeaderException](#T-AppApiAuthenticator-Server-MissingHeaderException 'AppApiAuthenticator.Server.MissingHeaderException')
  - [#ctor()](#M-AppApiAuthenticator-Server-MissingHeaderException-#ctor 'AppApiAuthenticator.Server.MissingHeaderException.#ctor')
  - [#ctor(message)](#M-AppApiAuthenticator-Server-MissingHeaderException-#ctor-System-String- 'AppApiAuthenticator.Server.MissingHeaderException.#ctor(System.String)')
  - [#ctor(message,inner)](#M-AppApiAuthenticator-Server-MissingHeaderException-#ctor-System-String,System-Exception- 'AppApiAuthenticator.Server.MissingHeaderException.#ctor(System.String,System.Exception)')
- [NoAuthorizedAppsException](#T-AppApiAuthenticator-Server-NoAuthorizedAppsException 'AppApiAuthenticator.Server.NoAuthorizedAppsException')
  - [#ctor()](#M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor 'AppApiAuthenticator.Server.NoAuthorizedAppsException.#ctor')
  - [#ctor(message)](#M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor-System-String- 'AppApiAuthenticator.Server.NoAuthorizedAppsException.#ctor(System.String)')
  - [#ctor(message,inner)](#M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor-System-String,System-Exception- 'AppApiAuthenticator.Server.NoAuthorizedAppsException.#ctor(System.String,System.Exception)')
- [PostMethods](#T-AppApiAuthenticator-Common-PostMethods 'AppApiAuthenticator.Common.PostMethods')
  - [PATCH](#F-AppApiAuthenticator-Common-PostMethods-PATCH 'AppApiAuthenticator.Common.PostMethods.PATCH')
  - [POST](#F-AppApiAuthenticator-Common-PostMethods-POST 'AppApiAuthenticator.Common.PostMethods.POST')
  - [PUT](#F-AppApiAuthenticator-Common-PostMethods-PUT 'AppApiAuthenticator.Common.PostMethods.PUT')
- [extensionClass](#T-AppApiAuthenticator-extensionClass 'AppApiAuthenticator.extensionClass')
  - [getDescription(e)](#M-AppApiAuthenticator-extensionClass-getDescription-System-Enum- 'AppApiAuthenticator.extensionClass.getDescription(System.Enum)')
  - [parseEnum\`\`1(str)](#M-AppApiAuthenticator-extensionClass-parseEnum``1-System-String- 'AppApiAuthenticator.extensionClass.parseEnum``1(System.String)')

<a name='T-AppApiAuthenticator-Server-AppIdNotFoundException'></a>
## AppIdNotFoundException `type`

##### Namespace

AppApiAuthenticator.Server

##### Summary

Exception when the app id is not found

<a name='M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor'></a>
### #ctor() `constructor`

##### Summary

Default initializer when there's no data

##### Parameters

This constructor has no parameters.

<a name='M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor-System-String-'></a>
### #ctor(message) `constructor`

##### Summary

Default initializer, for message only

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |

<a name='M-AppApiAuthenticator-Server-AppIdNotFoundException-#ctor-System-String,System-Exception-'></a>
### #ctor(message,inner) `constructor`

##### Summary

Default initializer, for message and inner exception

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |
| inner | [System.Exception](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Exception 'System.Exception') | Inner exception |

<a name='T-AppApiAuthenticator-Client-Authorizor'></a>
## Authorizor `type`

##### Namespace

AppApiAuthenticator.Client

##### Summary

Class containing the methods to generate the headers

<a name='M-AppApiAuthenticator-Client-Authorizor-#ctor-System-String,System-String-'></a>
### #ctor(appId,appKey) `constructor`

##### Summary

Initializes the class, requires the appId and appKey

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| appId | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The appId to be authorized |
| appKey | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The appKey to use on the authorization |

<a name='F-AppApiAuthenticator-Client-Authorizor-appId'></a>
### appId `constants`

##### Summary

Holds the appId on the current instance

<a name='F-AppApiAuthenticator-Client-Authorizor-appKey'></a>
### appKey `constants`

##### Summary

Holds the appKey on the current instance

<a name='M-AppApiAuthenticator-Client-Authorizor-generateHeader-AppApiAuthenticator-Common-GetMethods,System-String-'></a>
### generateHeader(method,customSig) `method`

##### Summary

Generates the headers required for the app authentication with the API for the methods "GET", "HEAD" and "DELETE"

##### Returns

The dictionary with the headers required for the authentication

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| method | [AppApiAuthenticator.Common.GetMethods](#T-AppApiAuthenticator-Common-GetMethods 'AppApiAuthenticator.Common.GetMethods') | The method of the request |
| customSig | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}" |

<a name='M-AppApiAuthenticator-Client-Authorizor-generateHeader``1-``0,AppApiAuthenticator-Common-PostMethods,System-Boolean,System-String-'></a>
### generateHeader\`\`1(body,method,isJson,customSig) `method`

##### Summary

Generates the headers required for the app authentication with the API for the methods "POST", "PATCH" and "PUT"

##### Returns

The dictionary with the headers required for the authentication

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| body | [\`\`0](#T-``0 '``0') | The body of the request, must be a codable struct or a \`string\` if body is a \`string\` parameter \`isJson\` must be set to \`false\` |
| method | [AppApiAuthenticator.Common.PostMethods](#T-AppApiAuthenticator-Common-PostMethods 'AppApiAuthenticator.Common.PostMethods') | The method of the request, optional, defaults to \`PostMethods.POST\` |
| isJson | [System.Boolean](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Boolean 'System.Boolean') | Sets if the body is a conformable json class or a \`string\` |
| customSig | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}" |

##### Generic Types

| Name | Description |
| ---- | ----------- |
| T | The type of the body, this is inferred by the parameter |

<a name='T-AppApiAuthenticator-Server-Authorizor`1'></a>
## Authorizor\`1 `type`

##### Namespace

AppApiAuthenticator.Server

##### Summary

Class containing the methods to authenticate the app with the API

<a name='M-AppApiAuthenticator-Server-Authorizor`1-#ctor-System-Collections-Generic-List{`0}-'></a>
### #ctor(apps) `constructor`

##### Summary

Initializes the authorizor for the server side, requires a list of type LT that implements the protocol IAppDbModel
If the dictionary is empty the exception \`NoAuthorizedApps\` is thrown

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| apps | [System.Collections.Generic.List{\`0}](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Collections.Generic.List 'System.Collections.Generic.List{`0}') | Dictionary of authorized apps |

##### Exceptions

| Name | Description |
| ---- | ----------- |
| [AppApiAuthenticator.Server.NoAuthorizedAppsException](#T-AppApiAuthenticator-Server-NoAuthorizedAppsException 'AppApiAuthenticator.Server.NoAuthorizedAppsException') | The list of authorized apps is empty |

<a name='F-AppApiAuthenticator-Server-Authorizor`1-apps'></a>
### apps `constants`

##### Summary

Holds the list contaning the authorized apps id's and keys

<a name='M-AppApiAuthenticator-Server-Authorizor`1-authenticateApp-System-Collections-Generic-Dictionary{System-String,System-String},AppApiAuthenticator-Common-PostMethods,System-String-'></a>
### authenticateApp(headers,method,customSig) `method`

##### Summary

Tries to authenticate the app with the api for the methods "GET", "HEAD" and "DELETE"

##### Returns

true if authenticated, no other return as all other paths lead to exceptions

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| headers | [System.Collections.Generic.Dictionary{System.String,System.String}](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Collections.Generic.Dictionary 'System.Collections.Generic.Dictionary{System.String,System.String}') | The headers of the request, must be at least the headers mentioned on the \`Header\` enum |
| method | [AppApiAuthenticator.Common.PostMethods](#T-AppApiAuthenticator-Common-PostMethods 'AppApiAuthenticator.Common.PostMethods') | The method of the request, optional, defaults to \`GetMethods.GET\` |
| customSig | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}" |

##### Exceptions

| Name | Description |
| ---- | ----------- |
| [AppApiAuthenticator.Server.MissingHeaderException](#T-AppApiAuthenticator-Server-MissingHeaderException 'AppApiAuthenticator.Server.MissingHeaderException') | Missing required header for the authorization (the missing header is described in the Message) |
| [AppApiAuthenticator.Server.InvalidChallengeException](#T-AppApiAuthenticator-Server-InvalidChallengeException 'AppApiAuthenticator.Server.InvalidChallengeException') | Missing required header for the authorization (the missing header is described in the Message) |

<a name='M-AppApiAuthenticator-Server-Authorizor`1-authenticateApp``1-System-Collections-Generic-Dictionary{System-String,System-String},``0,AppApiAuthenticator-Common-PostMethods,System-Boolean,System-String-'></a>
### authenticateApp\`\`1(headers,body,method,isJson,customSig) `method`

##### Summary

Tries to authenticate the app with the api for the methods "POST", "PATCH" and "PUT"

##### Returns

true if authenticated, no other return as all other paths lead to exceptions

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| headers | [System.Collections.Generic.Dictionary{System.String,System.String}](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Collections.Generic.Dictionary 'System.Collections.Generic.Dictionary{System.String,System.String}') | The headers of the request, must be at least the headers mentioned on the \`Header\` enum |
| body | [\`\`0](#T-``0 '``0') | The body of the request, must be a codable struct or a \`string\` if body is a \`string\` parameter \`isJson\` must be set to \`false\` |
| method | [AppApiAuthenticator.Common.PostMethods](#T-AppApiAuthenticator-Common-PostMethods 'AppApiAuthenticator.Common.PostMethods') | The method of the request, optional, defaults to \`PostMethods.POST\` |
| isJson | [System.Boolean](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Boolean 'System.Boolean') | Sets if the body is a conformable json class or a \`string\` |
| customSig | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}" |

##### Generic Types

| Name | Description |
| ---- | ----------- |
| T | The type of the body, this is inferred by the parameter |

##### Exceptions

| Name | Description |
| ---- | ----------- |
| [AppApiAuthenticator.Server.MissingHeaderException](#T-AppApiAuthenticator-Server-MissingHeaderException 'AppApiAuthenticator.Server.MissingHeaderException') | Missing required header for the authorization (the missing header is described in the Message) |
| [AppApiAuthenticator.Server.InvalidChallengeException](#T-AppApiAuthenticator-Server-InvalidChallengeException 'AppApiAuthenticator.Server.InvalidChallengeException') | Missing required header for the authorization (the missing header is described in the Message) |

<a name='M-AppApiAuthenticator-Server-Authorizor`1-headersPresent-System-Collections-Generic-Dictionary{System-String,System-String}-'></a>
### headersPresent(headers) `method`

##### Summary

Checks if all headers required for the authorization are present

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| headers | [System.Collections.Generic.Dictionary{System.String,System.String}](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Collections.Generic.Dictionary 'System.Collections.Generic.Dictionary{System.String,System.String}') | The headers of the request |

##### Exceptions

| Name | Description |
| ---- | ----------- |
| [AppApiAuthenticator.Server.MissingHeaderException](#T-AppApiAuthenticator-Server-MissingHeaderException 'AppApiAuthenticator.Server.MissingHeaderException') | Missing required header for the authorization (the missing header is described in the Message) |

<a name='T-AppApiAuthenticator-Common'></a>
## Common `type`

##### Namespace

AppApiAuthenticator

##### Summary

Class containing shared methods and enums

<a name='M-AppApiAuthenticator-Common-replacePlaceholders-System-String@,System-Collections-Generic-Dictionary{System-String,System-String}-'></a>
### replacePlaceholders(signature,values) `method`

##### Summary

Replaces the signature format with the proper signature values 
The signature format must be passed as reference to it's done "in place" thus not returning any value

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | [System.String@](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String@ 'System.String@') | The signature format |
| values | [System.Collections.Generic.Dictionary{System.String,System.String}](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Collections.Generic.Dictionary 'System.Collections.Generic.Dictionary{System.String,System.String}') | The values to replace on the signature |

<a name='T-AppApiAuthenticator-Crypto'></a>
## Crypto `type`

##### Namespace

AppApiAuthenticator

<a name='M-AppApiAuthenticator-Crypto-calculateHMACSha256-System-String,System-String-'></a>
### calculateHMACSha256(text,key) `method`

##### Summary

Calculates the HMAC-SHA256 of a string

##### Returns



##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| text | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The string from which will be calculated the authenticated message |
| key | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The key to create the authenticated message |

<a name='M-AppApiAuthenticator-Crypto-calculateSha256-System-String-'></a>
### calculateSha256(text) `method`

##### Summary

Calculates the SHA256 of a string

##### Returns



##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| text | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | String from which will be generate the hash |

<a name='T-AppApiAuthenticator-Common-GetMethods'></a>
## GetMethods `type`

##### Namespace

AppApiAuthenticator.Common

##### Summary

The allowed methods for requests without body

<a name='F-AppApiAuthenticator-Common-GetMethods-DELETE'></a>
### DELETE `constants`

##### Summary

Method DELETE

<a name='F-AppApiAuthenticator-Common-GetMethods-GET'></a>
### GET `constants`

##### Summary

Method GET

<a name='F-AppApiAuthenticator-Common-GetMethods-HEAD'></a>
### HEAD `constants`

##### Summary

Method HEAD

<a name='T-AppApiAuthenticator-Server-Authorizor`1-Header'></a>
## Header `type`

##### Namespace

AppApiAuthenticator.Server.Authorizor`1

##### Summary

Required headers for the authorization

<a name='T-AppApiAuthenticator-Interfaces-IAppDbModel'></a>
## IAppDbModel `type`

##### Namespace

AppApiAuthenticator.Interfaces

##### Summary

Interface required to initialize the AppAuthServer
The class contaning the AppID's and Keys must conform with this interface

<a name='P-AppApiAuthenticator-Interfaces-IAppDbModel-AppAuthID'></a>
### AppAuthID `property`

##### Summary

GUID of the APP

<a name='P-AppApiAuthenticator-Interfaces-IAppDbModel-Key'></a>
### Key `property`

##### Summary

Key of the APP

<a name='T-AppApiAuthenticator-Server-InvalidChallengeException'></a>
## InvalidChallengeException `type`

##### Namespace

AppApiAuthenticator.Server

##### Summary

Exception when the challenge fails

<a name='M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor'></a>
### #ctor() `constructor`

##### Summary

Default initializer when there's no data

##### Parameters

This constructor has no parameters.

<a name='M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor-System-String-'></a>
### #ctor(message) `constructor`

##### Summary

Default initializer, for message only

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |

<a name='M-AppApiAuthenticator-Server-InvalidChallengeException-#ctor-System-String,System-Exception-'></a>
### #ctor(message,inner) `constructor`

##### Summary

Default initializer, for message and inner exception

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |
| inner | [System.Exception](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Exception 'System.Exception') | Inner exception |

<a name='T-AppApiAuthenticator-InvalidEnumException'></a>
## InvalidEnumException `type`

##### Namespace

AppApiAuthenticator

##### Summary

Exception when the Enum can't be parsed

<a name='M-AppApiAuthenticator-InvalidEnumException-#ctor'></a>
### #ctor() `constructor`

##### Summary

Default initializer when there's no data

##### Parameters

This constructor has no parameters.

<a name='M-AppApiAuthenticator-InvalidEnumException-#ctor-System-String-'></a>
### #ctor(message) `constructor`

##### Summary

Default initializer, for message only

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |

<a name='M-AppApiAuthenticator-InvalidEnumException-#ctor-System-String,System-Exception-'></a>
### #ctor(message,inner) `constructor`

##### Summary

Default initializer, for message and inner exception

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |
| inner | [System.Exception](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Exception 'System.Exception') | Inner exception |

<a name='T-AppApiAuthenticator-Server-MissingHeaderException'></a>
## MissingHeaderException `type`

##### Namespace

AppApiAuthenticator.Server

##### Summary

Exception when there's one missing header

<a name='M-AppApiAuthenticator-Server-MissingHeaderException-#ctor'></a>
### #ctor() `constructor`

##### Summary

Default initializer when there's no data

##### Parameters

This constructor has no parameters.

<a name='M-AppApiAuthenticator-Server-MissingHeaderException-#ctor-System-String-'></a>
### #ctor(message) `constructor`

##### Summary

Default initializer, for message only

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |

<a name='M-AppApiAuthenticator-Server-MissingHeaderException-#ctor-System-String,System-Exception-'></a>
### #ctor(message,inner) `constructor`

##### Summary

Default initializer, for message and inner exception

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |
| inner | [System.Exception](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Exception 'System.Exception') | Inner exception |

<a name='T-AppApiAuthenticator-Server-NoAuthorizedAppsException'></a>
## NoAuthorizedAppsException `type`

##### Namespace

AppApiAuthenticator.Server

##### Summary

Exception when there are no authorized apps

<a name='M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor'></a>
### #ctor() `constructor`

##### Summary

Default initializer when there's no data

##### Parameters

This constructor has no parameters.

<a name='M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor-System-String-'></a>
### #ctor(message) `constructor`

##### Summary

Default initializer, for message only

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |

<a name='M-AppApiAuthenticator-Server-NoAuthorizedAppsException-#ctor-System-String,System-Exception-'></a>
### #ctor(message,inner) `constructor`

##### Summary

Default initializer, for message and inner exception

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| message | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | Error message |
| inner | [System.Exception](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Exception 'System.Exception') | Inner exception |

<a name='T-AppApiAuthenticator-Common-PostMethods'></a>
## PostMethods `type`

##### Namespace

AppApiAuthenticator.Common

##### Summary

The allowed methods for requests with body

<a name='F-AppApiAuthenticator-Common-PostMethods-PATCH'></a>
### PATCH `constants`

##### Summary

Method PATCH

<a name='F-AppApiAuthenticator-Common-PostMethods-POST'></a>
### POST `constants`

##### Summary

Method POST

<a name='F-AppApiAuthenticator-Common-PostMethods-PUT'></a>
### PUT `constants`

##### Summary

Method PUT

<a name='T-AppApiAuthenticator-extensionClass'></a>
## extensionClass `type`

##### Namespace

AppApiAuthenticator

##### Summary

Adds extensions to classes

<a name='M-AppApiAuthenticator-extensionClass-getDescription-System-Enum-'></a>
### getDescription(e) `method`

##### Summary

Gets the description of the enumerator

##### Returns

The description as string

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| e | [System.Enum](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.Enum 'System.Enum') | The enumerator |

<a name='M-AppApiAuthenticator-extensionClass-parseEnum``1-System-String-'></a>
### parseEnum\`\`1(str) `method`

##### Summary

Parses a string to a enum
If a num is not found throws InvalidEnumException

##### Returns

The enum value

##### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| str | [System.String](http://msdn.microsoft.com/query/dev14.query?appId=Dev14IDEF1&l=EN-US&k=k:System.String 'System.String') | The string to be parsed |

##### Generic Types

| Name | Description |
| ---- | ----------- |
| T | The type of the enum |
