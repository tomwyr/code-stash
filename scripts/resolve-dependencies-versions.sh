#!/bin/bash

set -e

# Resolve gbc latest version
gbc_release_url="https://api.github.com/repos/$GBC_REPOSITORY/releases/latest"

echo "Fetching gbc latest release information"
gbc_version=$(curl -s "$gbc_release_url" | jq -r '.name')

if [ -n "$gbc_version" ] && [ "$gbc_version" != "null" ]; then
  echo "Resolved gbc version: $gbc_version"
  echo "gbc_version=$gbc_version" >> $GITHUB_OUTPUT
else
  echo "Failed to resolve gbc latest version." >&2
  exit 1
fi

# Resolve ffi package version
ffi_version=$(jq -r '.dependencies."ffi-rs"' package.json)

if [ -n "$ffi_version" ] && [ "$ffi_version" != "null" ]; then
  echo "Resolved ffi version: $ffi_version"
  echo "ffi_version=$ffi_version" >> $GITHUB_OUTPUT
else
  echo "Failed to resolve ffi version." >&2
  exit 1
fi
