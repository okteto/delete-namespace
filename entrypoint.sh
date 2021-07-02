#!/bin/sh
set -e

namespace=$1
if [ -z $namespace ]; then
  echo "Namespace name is required"
  exit 1
fi

if [[ ! -z "$CUSTOM_CERTIFICATE" ]]; then
  echo "Custom certificate is provided"
  echo "$CUSTOM_CERTIFICATE" > /usr/local/share/ca-certificates/custom_certificate_crt
  update-ca-certificates
fi

echo running: okteto delete namespace $namespace
okteto delete namespace $namespace
