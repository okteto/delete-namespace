#!/bin/sh
set -e

namespace=$1
if [ -z $namespace ]; then
  echo "Namespace name is required"
  exit 1
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /etc/ssl/certs/okteto_ca_cert.pem
   if command -v update-ca-certificates > /dev/null 2>&1; then
     mkdir -p /usr/local/share/ca-certificates
     cp /etc/ssl/certs/okteto_ca_cert.pem /usr/local/share/ca-certificates/okteto_ca_cert.crt
     update-ca-certificates
   fi
fi

log_level=$2
if [ ! -z "$log_level" ]; then
  log_level="--log-level ${log_level}"
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi


echo running: okteto namespace delete $namespace $log_level
okteto namespace delete $namespace $log_level
