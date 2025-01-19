#!/bin/bash

set -e

# Retrieve gbc latest version
gbc_release_url="https://api.github.com/repos/$REPOSITORY/releases/latest"

echo "Fetching gbc latest release information"
version=$(curl -s $gbc_release_url | jq -r '.name')

if [ -n "$version" ]; then
  echo "Resolved gbc version: $version"
else
  echo "Failed to retrieve gbc latest version." >&2
  exit 1
fi

# Download each platform's library for the latest version
mkdir -p out/libs

for platform_suffix in "linux.so" "macos.dylib" "windows.dll"; do
  file_name="gbc-$platform_suffix"
  gbc_lib_url="https://github.com/$REPOSITORY/releases/latest/download/gbc-lib-$version-$platform_suffix"

  echo "Downloading $file_name"
  file_path="out/libs/$file_name"
  curl -s -L -o "$file_path" "$gbc_lib_url"

  if [ ! -e "$file_path" ]; then
    echo "Failed to download $file_name library." >&2
    exit 1
  fi
done
