#!/bin/bash

set -e

file_name="gbc-$GBC_PLATFORM_SUFFIX"
gbc_lib_url="https://github.com/$GBC_REPOSITORY/releases/latest/download/gbc-lib-$GBC_VERSION-$GBC_PLATFORM_SUFFIX"

echo "Downloading $file_name ($gbc_lib_url)"
file_path="out/$file_name"
curl -s -L -o "$file_path" "$gbc_lib_url"

if [ ! -e "$file_path" ]; then
  echo "Failed to download $file_name library." >&2
  exit 1
fi
