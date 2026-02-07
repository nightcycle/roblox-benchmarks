#!/bin/sh
set -e
echo "Building project..."

: "${PROJECT:=default.project.json}"
echo "Using project file: $PROJECT"
: "${BUILD_PATH:=build.rbxl}"
echo "Using build path: $BUILD_PATH"
: "${SOURCEMAP:=sourcemap.json}"
echo "Using sourcemap path: $SOURCEMAP"

rojo build "$PROJECT" -o "$BUILD_PATH"
rojo sourcemap "$PROJECT" --output "$SOURCEMAP"
echo "Build complete."

# remove data directory