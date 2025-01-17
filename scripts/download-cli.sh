#!/bin/bash

set -e

mkdir -p out/cli

file_names=("linux" "macos" "windows.exe")

for file_name in "linux" "macos" "windows.exe"; do
  download_url="https://github.com/$REPOSITORY/releases/latest/download/gbc-$VERSION-$file_name"
  curl -s -o out/cli/gbc-$file_name "$download_url"
done
