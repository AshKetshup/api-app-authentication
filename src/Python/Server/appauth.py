import hashlib
import json
import hmac

class AppIdNotFound(Exception):
    """Exception that indicates that it cannot find App ID."""    
    def __init__(self, message="App ID not found"):
        self.message = message
        super().__init__(self.message)
        

class AppAuthHeaderNotFound(Exception):
    """Exception that indicates that it cannot find Auth Header."""
    def __init__(self, message="App authentication header not found"):
        self.message = message
        super().__init__(self.message)
        

class InvalidAppAuthenticationChallenge(Exception):
    """Exception that indicates that the app authentication challenge is invalid."""
    def __init__(self, message="Invalid app authentication challenge"):
        self.message = message
        super().__init__(self.message)

class NoAppsProvided(Exception):
    """Exception that indicates that there are no authorized apps."""
    def __init__(self, message="No apps in the authorized apps list"):
        self.message = message
        super().__init__(self.message)

class InvalidBody(Exception):
    """Exception indicating that the body field must be a string or a JSON dictionary."""    
    def __init__(self, message="The body must be a string or a JSON dictionary"):
        self.message = message
        super().__init__(self.message)

class InvalidMethod(Exception):
    """Exception indicating that the method is not allowed"""
    def __init__(self, received_method, allowed_methods):
        self.message = "The method {} isn't allowed. Allowed methods are {}".format(received_method,", ".join(allowed_methods))
        super().__init__(self.message)


class AppAuthenticationServer(object):
    def __init__(self, apps):
        r"""Initializes the AppAuthenticationServer

        Parameters
        ----------
            apps : array of tuples
                The array of apps allowed to access this API, the tuple should contain the (appid, appkey)

        Raises
        ------
        NoAppsProvided
            There are no authorized apps in the list
        """
        if len(apps) <= 0:
            raise NoAppsProvided()
        self._apps = apps

    
    def authenticateApp(self, headers, method="GET", body=None, isjson=True, customsig=None):
        r"""Tries to authenticate an app with the API

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
        """
        try:
            appid = headers["X-App-Id"]
            appkey = self.getAppKey(appid)
            timestamp = headers["X-Req-Timestamp"]
            nonce = headers["X-Req-Nonce"]
            sig = headers["X-Req-Sig"]

            if appkey is None:
                raise AppIdNotFound()

            if body is None:
                if self.compareSigWithoutBody(method, timestamp, nonce, appid, appkey, sig, customsig):
                    return True
            else:
                if self.compareSigWithBody(method, timestamp, nonce, appid, appkey, sig, body, isjson, customsig):
                    return True

            raise InvalidAppAuthenticationChallenge()
        except KeyError:
            raise AppAuthHeaderNotFound()

    def getAppKey(self, appid):
        r"""Fetches the app key given an app id from the apps list in the current instance

        Parameters
        ----------
            appid : str
                The id of he app for which we will search the key

        Returns
        -------
            str
                Returns the app key if not found returns None
        """
        for app in self._apps:
            if app[0] == appid:
                return app[1]
        return None

    def compareSigWithBody(self, method, timestamp, nonce, appid, key, hsig, body, isjson, customsig):
        r"""Compares the header signature with the computed signature for a request with body

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
        """

        allowed = False
        allowed_methods = ("POST", "PATCH", "PUT")
        for m in allowed_methods:
            if m == method:
                allowed = True
                break
        if not allowed:
            raise InvalidMethod(method, allowed_methods)

        if isjson:
            bodyhash = hashlib.sha256(json.dumps(body).encode('utf-8')).hexdigest()
        else:
            if isinstance(body, str):
                bodyhash = hashlib.sha256(json.dumps(body).encode('utf-8')).hexdigest()
            else:
                raise InvalidBody()

        if customsig is None:
            sig = "{appid}{method}{timestamp}{nonce}{bodyhash}".format(
                appid = appid,
                method = method,
                timestamp = timestamp, 
                nonce = nonce,
                bodyhash = bodyhash
            )
        else:
            sig = customsig.format(
                appid = appid,
                method = method,
                timestamp = timestamp,
                nonce = nonce,
                bodyhash = bodyhash
            )

        hmacsh256 = hmac.new(
            key=key.encode('utf-8'), 
            msg=sig.encode('utf-8'), 
            digestmod=hashlib.sha256
        )

        return hmacsh256.hexdigest() == hsig


    def compareSigWithoutBody(self, method, timestamp, nonce, appid, key, hsig, customsig):
        r"""Compares the header signature with the computed signature for a request without body

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
        """

        allowed = False
        allowed_methods = ("GET", "HEAD", "DELETE")
        for m in allowed_methods:
            if m == method:
                allowed = True
                break
        if not allowed:
            raise InvalidMethod(method, allowed_methods)

        if customsig is None:
            sig = "{appid}{method}{timestamp}{nonce}".format(
                appid = appid,
                method = method,
                timestamp = timestamp, 
                nonce = nonce
            )
        else:
            sig = customsig.format(
                appid = appid,
                method = method,
                timestamp = timestamp,
                nonce = nonce
            )

        hmacsh256 = hmac.new(
            key=key.encode('utf-8'), 
            msg=sig.encode('utf-8'), 
            digestmod=hashlib.sha256
        )

        return hmacsh256.hexdigest() == hsig