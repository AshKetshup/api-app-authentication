Module appauth
==============

Classes
-------

`AppAuthenticationClient(appid, appkey)`: Initializes the AppAuthenticationClient
    

Parameters
----------
    appid : str
        The the id of the app which will be accessing the API
    appkey : str
        The key of the API (this should be different of the appid and shouldn't be the same for multiple app id's)
        Read more in the Wiki


## Methods

`generateHeaderWithBody(self, body, method='POST', isjson=True, customsig=None`: Generates App Authentication headers for the methods that contain a body (POST, PATCH, PUT)
        
    Parameters
    ----------
        body : str or dictionary
            This variable can either be a str or a dictionary containing the body of the request
        method : {'POST', 'PATCH', 'PUT' }, optional
            The method of the request, can be one of the options in brackets, defaults to the first one
        isjson : bool, optional
            The body is a JSON dictionary, defaults to True
        customsig : str
            A string to build a custom signature, more information in the repo wiki. Defaults to None

    Returns
    -------
        dictionary
            Required headers for the request

    Raises
    ------
    InvalidBody
        The Body content isn't a dictionary nor a str
    InvalidMethod
        The method of the request is not valid for this headers

`generateHeaderWitoutBody(self, method='GET', customsig=None)` : Generates App Authentication headers for the methods that don't contain a body (GET, HEAD, DELETE)
    
    Parameters
    ----------
        method : {'GET', 'HEAD', 'DELETE' }, optional
            The method of the request, can be one of the options in brackets, defaults to the first one
        customsig : str
            A string to build a custom signature, more information in the repo wiki. Defaults to None
    
    Returns
    -------
        dictionary
            Required headers for the request
    
    Raises
    ------
    InvalidMethod
        The method of the request is not valid for this headers

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