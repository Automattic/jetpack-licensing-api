# Jetpack Licensing API Integration Documentation

## Glossary

- **Issue a license**: To create a new license record. After issuing, a license is ready to be used (attached, revoked, inspected, etc).
- **Revoke a license**: To make it so that an issued license cannot be used ever again regardless of whether it was attached to a site or not. Once a license is revoked it cannot be attached again and the provisioned product is removed from the Jetpack site.
- **Set/unset a license**: To set the jetpack_license option containing a license key string on a WordPress instance using update_option(). This process offers no guarantees that the license is valid until it is actually attached.
- **Attach a license**: A license is associated to a user and site. From that point onwards the license belongs to the user that first connected jetpack on the site and is linked to that site.
- **Detach a license**: The process of unlinking an attached license from a specific site (the owner user remains the same). This should be done in order to be able to attach a license to a site other than the one it was previously attached to.
- **Inspect a license**: Become aware of a license’s capabilities, validity, specs, etc.

## Authentication

TBD

## Endpoints

The Licensing API has an OpenAPI schema for all of its endpoints available [here](https://github.com/Automattic/jetpack-licensing-api/blob/master/spec.yml).

## Integration step-by-step guide

To integrate with the Jetpack Licensing API and issue licenses for your customers you can follow these steps:

### 1. TBD (partner?)

### 2. TBD (partner key via start API?)

### 3. Issue one or more licenses

A license has to be issued for every paid Jetpack plan or product that has to be enabled for a given site. To issue a license you have to make a `POST` request to the `/wpcom/v2/jetpack-licensing/license` endpoint like so:
```shell script
PARTNER_ID= your partner id
PARTNER_SECRET= your partner secret
PRODUCT= desired product e.g. jetpack-anti-spam
API_HOST=public-api.wordpress.com

# Get access token.
ACCESS_TOKEN_JSON=$(curl https://$API_HOST/oauth2/token \
  --silent \
  -d "grant_type=client_credentials&client_id=$PARTNER_ID&client_secret=$PARTNER_SECRET&scope=jetpack-partner")

# Parse access token from response.
ACCESS_TOKEN=$(echo $ACCESS_TOKEN_JSON | jq -r ".access_token")

# Use access token to issue license.
LICENSE_JSON=$(curl "https://${API_HOST}/wpcom/v2/jetpack-licensing/license?product=${PRODUCT}" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN" \
  -X POST)
echo $LICENSE_JSON
```
The response will be a JSON object of the newly generated license that looks something like this:
```json
{"id":1,"license_key":"jetpack-anti-spam_xZjtE12WIVwBus4n2wbIrYcIM","issued_at":"2020-09-08 16:14:58","revoked_at":null}
```
During normal usage you will only need to store the `license_key` value for the next step.

### 4. Attach one or more licenses to a site

To attach one or more licenses to a site you need to store their license keys as an array in the WordPress `jetpack_licenses` option:
```php
update_option(
    'jetpack_licenses',
    array(
        'jetpack-anti-spam_xZjtE12WIVwBus4n2wbIrYcIM',
        'jetpack-backup-daily_WZjtE12wYc2wBuIM4nIVsxbIr',
    )
);
```
or if you prefer to use WP CLI:
```shell script
wp option update jetpack_licenses '["jetpack-anti-spam_xZjtE12WIVwBus4n2wbIrYcIM","jetpack-backup-daily_WZjtE12wYc2wBuIM4nIVsxbIr"]' --format=json
```
_Note: WP CLI usage requires that license keys are formatted as JSON._

Upon updating the license keys, Jetpack will automatically attach them to the site. If Jetpack is not connected, the licenses will be automatically attached whenever the end user connects Jetpack.
