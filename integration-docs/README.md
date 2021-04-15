# Jetpack Licensing API Integration Documentation

## Table of Contents

- [Glossary](#glossary)
- [Authentication](#authentication)
- [Endpoints](#endpoints)
- [Integration step-by-step guide](#integration-step-by-step-guide)

## Glossary

- **Issue a license**: To create a new license record. After issuing, a license is ready to be used (assigned, revoked, inspected, etc).
- **Revoke a license**: To make it so that an issued license cannot be used ever again regardless of whether it was assigned to a site or not. Once a license is revoked it cannot be assigned again and the provisioned product is removed from the Jetpack site.
- **Set/unset a license**: To set the `jetpack_licenses` option containing a license key string on a WordPress instance using `update_option()`. This process offers no guarantees that the license is valid until it is actually assigned.
- **Assign a license**: A license is associated to a user and site. From that point onwards the license belongs to the user that first connected jetpack on the site and is linked to that site.
- **Unassign a license**: The process of unlinking an assigned license from a specific site (the owner user remains the same). This should be done in order to be able to assign a license to a site other than the one it was previously assigned to.
- **Inspect a license**: Become aware of a license’s capabilities, validity, specs, etc.

## Authentication

To interact with the Licensing API, you will need to authenticate with an access token that will be provided to you by the Jetpack Infinity team. The access token needs to be passed via the `Authorization` request header like so:
```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

## Endpoints

The Licensing API has an OpenAPI schema for all of its endpoints available [here](https://github.com/Automattic/jetpack-licensing-api/blob/master/spec.yml).

## Integration step-by-step guide

To integrate with the Jetpack Licensing API and issue licenses for your customers you can follow these steps:

### 1. Create a WordPress.com user

You will first need to create a [WordPress.com](https://wordpress.com/) user to represent your organization. Once you have your account please reach out to the Jetpack Infinity team with the registered user email and we will provide you with an access token which is required for all Licensing API endpoints.

### 2. Issue one or more licenses

A license has to be issued for every paid Jetpack plan or product that you wish to enable for a given site. To issue a license you have to make a `POST` request to the `/wpcom/v2/jetpack-licensing/license` endpoint like so:
```shell script
ACCESS_TOKEN= your access token
PRODUCT= desired product e.g. jetpack-anti-spam

LICENSE_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-licensing/license?product=${PRODUCT}" \
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

### 3. Set one or more licenses on a site

To set one or more licenses on a site you need to store their license keys as an array in the WordPress `jetpack_licenses` option:
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

Upon updating the license keys, Jetpack will automatically assign them to the site. If Jetpack is not connected, the licenses will be automatically assigned whenever the end user connects Jetpack.

### 4. Connect Jetpack

Once you've set one or more licenses on a test site, we highly recommend that you connect that site to confirm that the products you have issued licenses for are assigned correctly.

1. If you've set the licenses after connecting Jetpack, skip to step 4. If you've set the licenses before connecting Jetpack continue to step 2.
2. You will be shown the following Call to Action in your WordPress dashboard:
![Screenshot 2021-04-15 at 16 40 13](https://user-images.githubusercontent.com/22746396/114878875-5ac9c900-9e09-11eb-92b5-3f0768f5a81d.png)
3. Click on "Set up Jetpack" and complete the connection process. When you're done, you will be redirected to the Jetpack Dashboard.
4. Visit `Jetpack -> Dashboard` and click on the `My Plan` tab.
5. The products you've set licenses for should now show up in the list, for example:
![Screenshot 2021-04-15 at 16 43 57](https://user-images.githubusercontent.com/22746396/114879361-cad84f00-9e09-11eb-8d24-60e9f750cc0c.png)

By following these steps you will have ensured that you've issued and set the licenses correctly.
