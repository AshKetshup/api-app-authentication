<?php

/**
 * Generates a UUIDv4
 * @return string UUIDv4
 */
function GUID()
{
    if (function_exists('com_create_guid') === true)
    {
        return trim(com_create_guid(), '{}');
    }

    return sprintf('%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}

/**
 * Replaces the signature template with the values
 * @param string signature the signature template
 * @param array values to be replaced in the signature
 * @return string the signature with the propper values replaced
 */
function replace_signature_placeholders($signature, $values) {
    $sig = $signature;
    foreach(array_keys($values) as $key){
        $sig = str_replace("{" . $key . "}", $arr[$key], $sig);
    }
    return $sig;
}

/**
 * Exception for InvalidBody
 */
class InvalidBody extends Exception { }

/**
 * Exception for InvalidMethod
 */
class InvalidMethod extends Exception { }

/**
 * Exception for missing headers
 */
class MissingHeaders extends Exception { }

/**
 * Exception when there are no authorized apps
 */
class NoAuthorizedApps extends Exception { }

/**
 * Exception when the app id can't be found in the authorized apps array
 */
class AppIdNotFound extends Exception { }

?>