#!/bin/bash

set -e

mkdir -p out/cli

file_names=("gbc-linux.so" "gbc-macos.dylib" "gbc-windows.dll")

for file_name in file_names; do
  download_url="https://github.com/$REPOSITORY/releases/latest/download/gbc-lib-$VERSION-$file_name"
  curl -s -o out/cli/$file_name "$download_url"
done
