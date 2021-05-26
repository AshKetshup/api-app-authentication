Module appauth
==============

Classes
-------

`AppAuthHeaderNotFound(message='App authentication header not found')`
:   Exception that indicates that it cannot find Auth Header.

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException

`AppAuthenticationServer(apps)`
:   Initializes the AppAuthenticationServer
    
    Parameters
    ----------
        apps : array of tuples
            The array of apps allowed to access this API, the tuple should contain the (appid, appkey)
    
    Raises
    ------
    NoAppsProvided
        There are no authorized apps in the list

### Methods

`authenticateApp(self, headers, method='GET', body=None, isjson=True, customsig=None)`
:   Tries to authenticate an app with the API
    
    Parameters
    ----------
        headers : dictionary
            The headers of the request
        method : {'GET', 'POST', 'PATCH', 'PUT', 'HEAD', 'DELETE' }, optional
            The method of the request, can be one of the options in the brackets, defaults to the first one
        body : str or dictionary
            This variable can either be a str or a dictionary containing the body of the request
        isjson : bool
            The body is a JSON dictionary, defaults to True
        customsig : str
            A string to build a custom signature, more information in the repo wiki. Defaults to None
        
    Raises
    ------
    AppIdNotFound
        Unable to find the App Id in the authorized apps
    InvalidAppAuthenticationChallenge
        Unable to authenticate the app (invalid challenge)
    AppAuthHeaderNotFound
        Unable to find the required headers to authenticate the app
    InvalidBody
        The Body content isn't a dictionary nor a str
    InvalidMethod
        The method of the request is not valid for this headers

`compareSigWithBody(self, method, timestamp, nonce, appid, key, hsig, body, isjson, customsig)`
:   Compares the header signature with the computed signature for a request with body
    
    Parameters
    ----------
        method : {'POST', 'PATCH', 'PUT' }
            The method of the request, can be one of the options in brackets
        timestamp : str
            Timestamp of the request (sent through the headers)
        nonce : str
            Nonce of the request (sent through the headers)
        appid : str
            App trying to access the API (sent through the headers)
        key : str
            The key associated with the app id
        hsig : str
            The request signature (sent through the headers)
        body : str or dictionary
            This variable can either be a str or a dictionary containing the body of the request            
        isjson : bool, optional
            The body is a JSON dictionary, defaults to True
        customsig : str
            A string to build a custom signature, more information in the repo wiki. Defaults to None
    
    Returns
    -------
        bool
            True if the challenge is valid, False otherwise
    
    Raises
    ------
    InvalidBody
        The Body content isn't a dictionary nor a str
    InvalidMethod
        The method of the request is not valid for this headers

`compareSigWithoutBody(self, method, timestamp, nonce, appid, key, hsig, customsig)`
:   Compares the header signature with the computed signature for a request without body
    
    Parameters
    ----------
        method : {'GET', 'HEAD', 'DELETE' }
            The method of the request, can be one of the options in brackets
        timestamp : str
            Timestamp of the request (sent through the headers)
        nonce : str
            Nonce of the request (sent through the headers)
        appid : str
            App trying to access the API (sent through the headers)
        key : str
            The key associated with the app id
        hsig : str
            The request signature (sent through the headers)
        customsig : str
            A string to build a custom signature, more information in the repo wiki. Defaults to None
    
    Returns
    -------
        bool
            True if the challenge is valid, False otherwise
    
    Raises
    ------
    InvalidMethod
        The method of the request is not valid for this headers

`getAppKey(self, appid)`
:   Fetches the app key given an app id from the apps list in the current instance
    
    Parameters
    ----------
        appid : str
            The id of he app for which we will search the key
    
    Returns
    -------
        str
            Returns the app key if not found returns None

`AppIdNotFound(message='App ID not found')`
:   Exception that indicates that it cannot find App ID.

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException

`InvalidAppAuthenticationChallenge(message='Invalid app authentication challenge')`
:   Exception that indicates that the app authentication challenge is invalid.

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException

`InvalidBody(message='The body must be a string or a JSON dictionary')`
:   Exception indicating that the body field must be a string or a JSON dictionary.

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException

`InvalidMethod(received_method, allowed_methods)`
:   Exception indicating that the method is not allowed

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException

`NoAppsProvided(message='No apps in the authorized apps list')`
:   Exception that indicates that there are no authorized apps.

    ### Ancestors (in MRO)

    * builtins.Exception
    * builtins.BaseException