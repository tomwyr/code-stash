#!/bin/bash

set -e

# Rename CLI
CLI_SOURCE=".build/release/$CLI_FILE_NAME"
CLI_TARGET=".build/gbc-$VERSION-$PLATFORM$EXECUTABLE_EXT"
cp "$CLI_SOURCE" "$CLI_TARGET"
chmod +x "$CLI_TARGET"
echo "cli_path=$CLI_TARGET" >> $GITHUB_OUTPUT

# Rename library
LIB_SOURCE=".build/release/$LIBRARY_FILE_NAME"
LIB_TARGET=".build/gbc-lib-$VERSION-$PLATFORM$LIBRARY_EXT"
cp "$LIB_SOURCE" "$LIB_TARGET"
chmod +x "$LIB_TARGET"
echo "lib_path=$LIB_TARGET" >> $GITHUB_OUTPUT
