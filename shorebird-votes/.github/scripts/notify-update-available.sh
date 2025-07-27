#!/bin/bash

curl -X POST https://cloud.appwrite.io/v1/functions/$APPWRITE_NOTIFY_UPDATE_AVAILABLE_ID/executions \
  -H "Content-Type: application/json" \
  -H "X-Appwrite-Project: ${APPWRITE_PROJECT_ID}" \
  -H "X-Appwrite-Key: ${APPWRITE_NOTIFY_UPDATE_AVAILABLE_KEY}"
