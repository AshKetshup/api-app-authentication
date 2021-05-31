<?php

require_once "Common.php";

class ApiAppAuthenticator {
    
    protected string $appid;
    protected string $appkey;

    public function __construct($appid, $appkey)
    {
        $this->appid = $appid;
        $this->appkey = $appkey;
    }

    function generateHeaders($method = "GET", $customSig = "{appid}{method}{timestamp}{nonce}") {
        $date = new DateTime();
        $str_timestamp = (string)$date->getTimestamp();
        $guid = GUID();
        $values = [
            "timestamp" => str_timestamp,
            "nonce" => GUID(),
            "appid" => $this->appid,
            "method" => $method
        ];

        $sig = replaceSignaturePlaceholders($customSig, $values);

        $hmac = hash_hmac ("sha256", $sig, $this->appkey);

        return [ 
            { "X-Req-Timestamp", $str_timestamp },
            { "X-Req-Nonce", $guid },
            { "X-Req-Sig", $hmac },
            { "X-App-Id", $this->appid }
        ];
    }

    function generateHeadersWithBody($body, $isJson = true, $method = "POST", $customSig = "{appid}{method}{timestamp}{nonce}") {
        $date = new DateTime();
        $str_timestamp = (string)$date->getTimestamp();
        $guid = GUID();
        if ($isJson) {
            $json = json_encode($body);
        } else {
            $json = $body;
        }
        $body = hash ("sha256", $json);

        $values = [
            "timestamp" => str_timestamp,
            "nonce" => $guid,
            "appid" => $this->appid,
            "method" => $method,
            "bodyhash" => $body
        ];

        $sig = replaceSignaturePlaceholders($customSig, $values);

        $hmac = hash_hmac ("sha256", $sig, $this->appkey);

        return [ 
            { "X-Req-Timestamp", $str_timestamp },
            { "X-Req-Nonce", $guid },
            { "X-Req-Sig", $hmac },
            { "X-App-Id", $this->appid }
        ];
    }

}

?>