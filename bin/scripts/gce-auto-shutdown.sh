#!/bin/bash

threshold=${1:-1}
intervals=${2:-30}
sleep_time=${3:-60}

function require() {
  if ! which $1 >/dev/null; then
    echo "This script requires $1, aborting ..." >&2
    exit 1
  fi
}
require gcloud
require python3
require curl

if ! curl -s -i metadata.google.internal | grep "Metadata-Flavor: Google" >/dev/null; then
  echo "This script only works on GCE VMs, aborting ..." >&2
  exit 1
fi

COMPUTE_METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
VM_PROJECT=$(curl -s "${COMPUTE_METADATA_URL}/project/project-id" -H "Metadata-Flavor: Google" || true)
VM_NAME=$(curl -s "${COMPUTE_METADATA_URL}/instance/hostname" -H "Metadata-Flavor: Google" | cut -d '.' -f 1)
VM_ZONE=$(curl -s "${COMPUTE_METADATA_URL}/instance/zone" -H "Metadata-Flavor: Google" | sed 's/.*zones\///')

count=0
while true; do
  load=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $3 }')
  if python3 -c "exit(0) if $load >= $threshold else exit(1)"; then
    echo "Resetting count ..." >&2
    count=0
  else
    ((count+=1))
    echo "Idle #${count} at $load ..." >&2
  fi
  if ((count>intervals)); then
    if who | grep -v tmux 1>&2; then
      echo "Someone is logged in, won't shut down, resetting count ..." >&2
    else
      echo "Suspending ${VM_NAME} ..." >&2
      runuser -l michael -c "gcloud beta compute instances suspend ${VM_NAME} --project ${VM_PROJECT} --zone ${VM_ZONE}"
    fi
    count=0
  fi
  sleep $sleep_time
done
