. $(dirname "$0")/access_token.sh

PRODUCT= your desired product e.g. jetpack-anti-spam

LICENSE_JSON=$(curl "https://${API_HOST}/wpcom/v2/jetpack-licensing/license?product=${PRODUCT}" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN" \
  -X POST)
echo $LICENSE_JSON
