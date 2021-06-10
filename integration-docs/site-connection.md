# Integrating with the Site Connection endpoint

The Site Connection endpoint allows you to establish a Jetpack site-only connection to a given site remotely.

## Authentication

To interact with the Licensing API, you will need to authenticate your API requests with an access token that will be provided to you.
For more information please refer to the [main integration documentation](https://github.com/Automattic/jetpack-licensing-api/blob/master/integration-docs/README.md).

## Endpoint specification

The Licensing API has an OpenAPI schema for all of its endpoints available [here](https://github.com/Automattic/jetpack-licensing-api/blob/master/spec.yml).

## Using the Site Connection endpoint

To establish a site connection to a given site, please follow these steps:
1. Make sure Jetpack is installed and activated on the site.
2. Make an authenticated POST request to `https://public-api.wordpress.com/wpcom/v2/jetpack-licensing/site-connection`, for example using cURL:
```shell script
ACCESS_TOKEN= your access token
SITE_URL= desired fully-qualified site url e.g. https://example.org
LOCAL_USER= site administrator's user id, username, or email

RESPONSE=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-licensing/site-connection" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN" \
  -X POST \
  -F "url=$SITE_URL" \
  -F "local_user=$LOCAL_USER")
echo $RESPONSE
```

The response will be one of 3 things:
- (200) `{"code":"success","blog_id":"BLOG_ID"}` - a new site connection was established for the given blog_id.
- (200) `{"code":"already_connected","blog_id":"BLOG_ID"}` - the site is already connected and there was no need to do anything.
- (403) `{"code":"ERROR_CODE","message":"ERROR_MESSAGE","data": {...}}` - an error ocurred with a code and message values providing more information.
