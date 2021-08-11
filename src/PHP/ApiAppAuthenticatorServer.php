<?php

require_once "Common.php";

class ApiAppAuthenticatorServer {

    protected $authorized_apps;

    /**
     * Constructor
     * @param array authorized_apps the authorized apps to access this api, the array must be a associative array with app id as key and app key as value
     */
    public function __construct($authorized_apps) {
        $this->authorized_apps = $authorized_apps;
        if (sizeof($authorized_apps) <= 0) {
            throw new NoAuthorizedApps();
        }
    }

    /**
     * Authenticates the app with the api for the methods GET, HEAD and DELETE
     * @param array headers an associative array containing the headers
     * @param string method the request method
     * @param string custom_sig the signature template
     */
    public function authenticate_app($headers, $method = "GET", $custom_sig = "{appid}{method}{timestamp}{nonce}") {
        if ($method != "GET" && $method != "HEAD" && $method != "DELETE") {
            throw new InvalidMethod("Invalid http method");
        }

        if (!headers_present($headers)) {
            throw new MissingHeaders();
        }

        $appid = $headers["X-App-Id"];
        $timestamp = $headers["X-Req-Timestamp"];
        $nonce = $headers["X-Req-Nonce"];
        $hsig = $headers["X-Req-Sig"];        

        if (!array_key_exists($appid, $this->authorized_apps)) {
            throw new AppIdNotFound();
        }

        $key = $this->authorized_apps[$appid];

        $values = array(
            "timestamp" => $timestamp,
            "nonce" => $nonce,
            "appid" => $appid,
            "method" => $method
        );
        $sig = replace_signature_placeholders($custom_sig, $values);

        $hmac = hash_hmac("sha256", $sig, $key);

        return $hmac === $hsig;

    }

    /**
     * Authenticates the app with the api for the methods GET, HEAD and DELETE
     * @param array headers an associative array containing the headers
     * @param object body the body of the request can be a json object or a string, if it's a string set is_json to false
     * @param bool is_json if the body is a string set this param to false
     * @param string method the request method
     * @param string custom_sig the signature template
     */
    public function authenticate_app_with_body($headers, $body, $is_json = true, $method = "GET", $custom_sig = "{appid}{method}{timestamp}{nonce}{bodyhash}") {
        if ($method != "GET" && $method != "HEAD" && $method != "DELETE") {
            throw new InvalidMethod("Invalid http method");
        }

        if (!headers_present($headers)) {
            throw new MissingHeaders();
        }

        if(is_string($body) && $isJson) {
            throw new InvalidBody("Invalid body");
        }

        $appid = $headers["X-App-Id"];
        $timestamp = $headers["X-Req-Timestamp"];
        $nonce = $headers["X-Req-Nonce"];
        $hsig = $headers["X-Req-Sig"];        

        if (!array_key_exists($appid, $this->authorized_apps)) {
            throw new AppIdNotFound();
        }

        $key = $this->authorized_apps[$appid];

        $json = NULL;
        if ($is_json) {
            $json = json_encode($body);
        } else {
            $json = $body;
        }

        $body = hash ("sha256", $json);

        $values = array(
            "timestamp" => $timestamp,
            "nonce" => $nonce,
            "appid" => $appid,
            "method" => $method,
            "bodyhash" => $body
        );
        $sig = replace_signature_placeholders($custom_sig, $values);

        $hmac = hash_hmac("sha256", $sig, $key);

        return $hmac === $hsig;

    }

    /**
     * Checks if all headers are present
     * @param array headers the headers for the request, the array must be a associative array with the header name as key and header value as value
     * @return bool true if all required headers are present, false otherwise
     */
    private function headers_present($headers) {
        if (!array_key_exists("X-Req-Timestamp", $arr)) {
            return false;
        }
        if (!array_key_exists("X-Req-Nonce", $arr)) {
            return false;
        }
        if (!array_key_exists("X-Req-Sig", $arr)) {
            return false;
        }
        if (!array_key_exists("X-App-Id", $arr)) {
            return false;
        }
        return true;
    }

}

?>
