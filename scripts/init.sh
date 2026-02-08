#!/bin/sh
set -e
rokit install
choco install jq # if this yields forever, use an admin terminal outside of your IDE
jq --version
sh scripts/build/init.sh
file-util run