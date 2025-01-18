#!/bin/bash

set -e

# Retrieve gbc latest version
gbc_release_url="https://api.github.com/repos/tomwyr/git-branch-cleaner/releases/latest"
version=$(curl -s $gbc_release_url | jq -r '.name')

if [ -n "$version" ]; then
  echo "Resolved gbc version: $version"
else
  echo "Failed to retrieve gbc latest version." >&2
  exit 1
fi

# Download each platform's library for the latest version
mkdir -p out/cli

file_names=("gbc-linux.so" "gbc-macos.dylib" "gbc-windows.dll")
for file_name in $file_names; do
  download_url="https://github.com/$REPOSITORY/releases/latest/download/gbc-lib-$version-$file_name"

  echo "Downloading $file_name"
  file_path="out/cli/$file_name"
  curl -s -o "$file_path" "$download_url"

  if [ ! -e "$file_path" ]; then
    echo "Failed to download $file_name gbc library." >&2
    exit 1
  fi
done
