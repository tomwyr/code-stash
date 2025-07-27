#!/bin/bash

PROPERTIES_FILE=android/key.properties

echo "storeFile=${ANDROID_STORE_FILE}" >>$PROPERTIES_FILE
echo "storePassword=${ANDROID_STORE_PASSWORD}" >>$PROPERTIES_FILE
echo "keyAlias=${ANDROID_KEY_ALIAS}" >>$PROPERTIES_FILE
echo "keyPassword=${ANDROID_KEY_PASSWORD}" >>$PROPERTIES_FILE

echo $ANDROID_ENCODED_KEYSTORE | base64 -d >android/app/$ANDROID_STORE_FILE
