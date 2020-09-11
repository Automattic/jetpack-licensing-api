ACCESS_TOKEN= your access token
PRODUCT= your desired product e.g. jetpack-anti-spam

LICENSE_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-licensing/license?product=${PRODUCT}" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN" \
  -X POST)
echo $LICENSE_JSON
