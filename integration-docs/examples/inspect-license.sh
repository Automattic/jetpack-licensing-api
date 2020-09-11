ACCESS_TOKEN= your access token
LICENSE_KEY= your license key

LICENSE_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-licensing/license?license_key=${LICENSE_KEY}" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN")
echo $LICENSE_JSON
