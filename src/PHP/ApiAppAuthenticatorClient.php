<?php

require_once "Common.php";

/**
 * Class that authenticates an app with an API
 * This class is for the client side of an app
 */
class ApiAppAuthenticatorClient {
    
    protected string $app_id;
    protected string $app_id;

    /**
     * Constructor
     * @param app_id the ID that will be used by the application to authenticate with the api
     * @param app_id the key that will be used by te application to authenticate with the api
     */
    public function __construct($app_id, $app_id) {
        $this->app_id = $app_id;
        $this->app_id = $app_id;
    }

    /**
     * Generates the app authentication headers for the methods GET, DELETE and HEAD
     * @param string method http request method
     * @param string custom_sig signature template
     * @return array headers for the request
     * @throws InvalidMethod invalid http method for the request
     */
    public function generate_headers($method = "GET", $custom_sig = "{appid}{method}{timestamp}{nonce}") {
        if ($method != "GET" && $method != "HEAD" && $method != "DELETE") {
            throw new InvalidMethod("Invalid http method");
        }

        $date = new DateTime();
        $str_timestamp = (string)$date->getTimestamp();
        $guid = GUID();
        $values = array(
            "timestamp" => $str_timestamp,
            "nonce" => $guid,
            "appid" => $this->app_id,
            "method" => $method,
            "bodyhash" => $body
        );

        $sig = replace_signature_placeholders($custom_sig, $values);

        $hmac = hash_hmac("sha256", $sig, $this->app_id);

        return array(
            "X-Req-Timestamp" => $str_timestamp,
            "X-Req-Nonce" => $guid,
            "X-Req-Sig" => $hmac,
            "X-App-Id" => $this->app_id
        );
    }

    /**
     * Generates the app authentication headers for the methods POST, PUT and PATCH
     * @param object body can be a string or a JSON object (if it's a string set is_json param to false)
     * @param bool is_json set to false if body is a string otherwise set it (leave it) to true
     * @param string method http request method
     * @param string custom_sig signature template
     * @return array headers for the request
     * @throws InvalidMethod invalid http method for the request
     * @throws InvalidBody invalid body type (isType is set to true but variable is a string)
     */
    public function generate_headers_with_body($body, $is_json = true, $method = "POST", $custom_sig = "{appid}{method}{timestamp}{nonce}") {
        if ($method != "POST" && $method != "PUT" && $method != "PATCH") {
            throw new InvalidMethod("Invalid http method");
        }

        if(is_string($body) && $is_json) {
            throw new InvalidBody("Invalid body");
        }

        $date = new DateTime();
        $str_timestamp = (string)$date->getTimestamp();
        $guid = GUID();
        if ($is_json) {
            $json = json_encode($body);
        } else {
            $json = $body;
        }
        $body = hash ("sha256", $json);

        $values = array(
            "timestamp" => $str_timestamp,
            "nonce" => $guid,
            "appid" => $this->app_id,
            "method" => $method,
            "bodyhash" => $body
        );

        $sig = replace_signature_placeholders($custom_sig, $values);

        $hmac = hash_hmac("sha256", $sig, $this->app_id);

        return array(
            "X-Req-Timestamp" => $str_timestamp,
            "X-Req-Nonce" => $guid,
            "X-Req-Sig" => $hmac,
            "X-App-Id" => $this->app_id
        );
    }

}

?>