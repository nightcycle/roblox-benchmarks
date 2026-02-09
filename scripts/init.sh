#!/bin/sh
set -e

rokit install

choco install jq -y # if this yields forever, use an admin terminal outside of your IDE
jq --version # restart your terminal if this errors

choco install gh -y # if this yields forever, use an admin terminal outside of your IDE
gh --version # restart your terminal if this errors, otherwise check that C:\Program Files\GitHub CLI is in your path

git submodule update --init --recursive

sh scripts/build/init.sh

file-util run