#!/bin/sh
set -e
sh scripts/build/init.sh
echo "Publishing build: $BUILD_PATH"
PUBLISH_RESPONSE=$(rbxcloud experience publish \
	--filename "$BUILD_PATH" \
	--universe-id "$UNIVERSE_ID" \
	--place-id "$PLACE_ID" \
	--api-key "$RBX_API_KEY" \
	--version-type "saved" \
	--pretty
)
echo "Publish response: $PUBLISH_RESPONSE"
VERSION_NUMBER=$(echo "$PUBLISH_RESPONSE" | jq -r '.versionNumber')
echo "$VERSION_NUMBER"