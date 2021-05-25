import time
import uuid
import hashlib
import json
import hmac

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

class AppAuthenticationClient(object):
    def __init__(self, appid, appkey):
        self._appid = appid
        self._appkey = appkey

    
    def generateHeaderWithBody(self, body, method="POST", isjson=True, customsig=None):
        r"""Generates App Authentication headers for the methods that contain a body (POST, PATCH, PUT)

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
        """

        allowed = False
        allowed_methods = ("POST", "PATCH", "PUT")
        for m in allowed_methods:
            if m == method:
                allowed = True
                break
        if not allowed:
            raise InvalidMethod(method, allowed_methods)

        timestamp = (str(int(time.time)))
        nonce = str(uuid.uuid4())
        if isjson:
            bodyhash = hashlib.sha256(json.dumps(body).encode('utf-8')).hexdigest()
        else:
            if isinstance(body, str):
                bodyhash = hashlib.sha256(json.dumps(body).encode('utf-8')).hexdigest()
            else:
                raise InvalidBody()

        if customsig is None:
            sig = "{appid}{method}{timestamp}{nonce}{bodyhash}".format(
                appid = self._appid, 
                timestamp = timestamp, 
                nonce = nonce,
                bodyhash = bodyhash
            )
        else:
            sig = customsig.format(
                appid = self._appid,
                timestamp = timestamp,
                nonce = nonce,
                bodyhash = bodyhash
            )

        hmacsha256 = hmac.new(key=self._appkey.encode(), msg=sig.encode(), digestmod=hashlib.sha256)

        return {
            "X-Req-Timestamp": timestamp,
            "X-Req-Nonce": nonce,
            "X-Req-Sig": hmacsha256,
            "X-App-Id": self._appid
        }


    def generateHeaderWitoutBody(self, method="GET", customsig=None):
        r"""Generates App Authentication headers for the methods that don't contain a body (GET, HEAD, DELETE)

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
        """

        allowed = False
        allowed_methods = ("GET", "HEAD", "DELETE")
        for m in allowed_methods:
            if m == method:
                allowed = True
                break
        if not allowed:
            raise InvalidMethod(method, allowed_methods)

        timestamp = (str(int(time.time)))
        nonce = str(uuid.uuid4())

        if customsig is None:
            sig = "{appid}{method}{timestamp}{nonce}".format(
                appid = self._appid, 
                timestamp = timestamp, 
                nonce = nonce
            )
        else:
            sig = customsig.format(
                appid = self._appid,
                timestamp = timestamp,
                nonce = nonce
            )

        hmacsha256 = hmac.new(key=self._appkey.encode(), msg=sig.encode(), digestmod=hashlib.sha256)

        return {
            "X-Req-Timestamp": timestamp,
            "X-Req-Nonce": nonce,
            "X-Req-Sig": hmacsha256,
            "X-App-Id": self._appid
        }