## Concept

This was implemented by me a couple years back during some of my university projects and been used by colleagues of mine.

It follows the concept of authorizing an APP with an API using identity/key, unlike the Key Authentication method, this method does not transmit the key through the network, therefore it's up to the Client app developer to keep the key secure.

For each request is created a unique signature which is transmitted in the header along the required values to create said signature, the only value that isn't transmitted is the key therefore it's not possible to recreate the signature. This algorithm also protects against changes in the request body since the signature includes a hash of the body.

## In depth

For each request it's generated the following fields:
* Timestamp: The unix time of the request
* Nonce: An UUID string
* Body Hash: For requests with a body, a hash, using SHA-256, is created

We then create a signature using HMAC-SHA256, the string that will generate the hash, by default, is `{appid}{method}{timestamp}{nonce}{bodyhash}` or for methods without body `{appid}{method}{timestamp}{nonce}` to create the HMAC we will use a strong Key hard to guess

We now have everything to transmit in the headers
```json
{
    "X-Req-Timestamp": "timestamp",
    "X-Req-Nonce": "nonce",
    "X-Req-Sig": "hmacsha256",
    "X-App-Id": "appid"
}
```

Now on the server side we grab all these headers, check if the AppID is in our database, if not, the app is not authorized, if it is we get the associated key (remember that the key wasn't transmitted through the headers).

Now we have the key (that was stored in the database) and the headers, we just calculate the HMAC-SHA256 using all these elements, if they match the app is authorized, otherwise either the request is corrupted (invalid method, tempered body (if it's a request with a body), tempered headers) or the app is not authorized.

If we think that a Key was compromised we can just remove it from the database and the app automatically becomes unauthorized.