#!/bin/bash

set -e

echo "Building and releasing for $VSCE_TARGET"

packages_array=($FFI_PACKAGES)

# Reinstall core package without platform implementations.
npm r ffi-rs && npm i "ffi-rs@$ffi_version" --no-optional

# Install platform specific packages.
for package in "${packages_array[@]}"; do
  npm i --force "$package@$FFI_VERSION"
done

# Package and publish the extension.
vsce package -t "$VSCE_TARGET"
vsce publish -t "$VSCE_TARGET" -p $VSCE_AUTH_TOKEN

# Restore ffi packages to the initial state.
for package in "${packages_array[@]}"; do
  npm r "$package" 
done
npm i ffi-rs
