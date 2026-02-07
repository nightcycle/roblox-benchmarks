#!/bin/sh
set -e
sh scripts/build/init.sh
echo "Publishing build: $BUILD_PATH"
PUBLISH_RESPONSE=$(rbxcloud experience publish \
	--filename "$BUILD_PATH" \
	--universe-id "$UNIVERSE_ID" \
	--place-id "$PLACE_ID" \
	--api-key "$API_KEY" \
	--version-type "saved" \
	--pretty
)
# extract the number after '"versionNumber":' in $PUBLISH_RESPONSE
VERSION_NUMBER=$(echo "$PUBLISH_RESPONSE" | grep -oP '"versionNumber":\s*\K\d+')
echo "$VERSION_NUMBER"