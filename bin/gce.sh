#!/usr/bin/env bash

set -e # exit on error

# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately via brew.
TEMP=$(/opt/homebrew/opt/gnu-getopt/bin/getopt -o vdm: --long name:,machine:,gpucount:,gpu:,project:,region:,zone:,serviceaccount:,help,preemptible,disktype:,disksize: \
              -n 'gce' -- "$@")

usage() {
  echo "Usage: --name <instance name>
       --machine <machine type>
       --disktype <disk type>
       --disksize <disk size in GB>
       --project <project-id>
       --region <region>
       --zone <zone>
       --serviceaccount <service account email>
       [ --gpucount <gpu count> ]
       [ --gpu <gpu type> ]
       <action>"
}


if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"

INSTANCE_NAME=""
MACHINE_TYPE="" # eg. "n1-standard-4" (15GB RAM) or "n1-standard-8" (30GB RAM) or "custom-8-16384" (8 cores, 16GB ram)
PROJECT=""
REGION=""
ZONE=""
SERVICE_ACCOUNT=""
DISK_TYPE="pd-balanced"
DISK_SIZE="64"
GPU_COUNT="1"
MISC_OPTIONS=""

while true; do
  case "$1" in
    --help ) usage; exit 0 ; shift ;;
    --name ) INSTANCE_NAME="$2"; shift 2 ;;
    --machine ) MACHINE_TYPE="$2"; shift 2 ;;
    --disktype ) DISK_TYPE="$2"; shift 2 ;;
    --disksize ) DISK_SIZE="$2"; shift 2 ;;
    --project ) PROJECT="$2"; shift 2 ;;
    --region ) REGION="$2"; shift 2 ;;
    --zone ) ZONE="$2"; shift 2 ;;
    --serviceaccount ) SERVICE_ACCOUNT="$2"; shift 2 ;;
    --gpucount ) GPU_COUNT="$2"; shift 2 ;;
    --gpu )
      MISC_OPTIONS="$MISC_OPTIONS --accelerator=count=$GPU_COUNT,type=$2"; shift 2 ;;
    --preemptible )
      MISC_OPTIONS="$MISC_OPTIONS --no-restart-on-failure --preemptible"; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

ACTION=$1

if [[ $INSTANCE_NAME == "" ]]; then echo "--name is required" >&2 ; exit 1 ; fi
if [[ $PROJECT == "" ]]; then echo "--project is required" >&2 ; exit 1 ; fi
if [[ $REGION == "" ]]; then echo "--region is required" >&2 ; exit 1 ; fi
if [[ $ZONE == "" ]]; then echo "--zone is required" >&2 ; exit 1 ; fi

if [[ $ACTION == "" ]]; then echo "<action> name is required" >&2 ; exit 1 ; fi

echo ""
echo ACTION="$ACTION"
echo ""
echo "Parameters:"
echo INSTANCE_NAME="$INSTANCE_NAME"
echo PROJECT="$PROJECT"
echo REGION="$REGION"
echo ZONE="$ZONE"
echo SERVICE_ACCOUNT="$SERVICE_ACCOUNT"

shutdown () {
  echo "Shutting down instance"
  time gcloud compute instances stop "$INSTANCE_NAME" --project="$PROJECT" --zone="$ZONE"

  echo "Removing previous snapshot"
  time gcloud compute snapshots delete "$INSTANCE_NAME" --project="$PROJECT" --quiet

  echo "Taking snapshot of disk"
  time gcloud compute disks snapshot "$INSTANCE_NAME" --project="$PROJECT" --snapshot-names="$INSTANCE_NAME" --zone="$ZONE" --storage-location="$REGION"

  echo "Removing compute instance"
  time gcloud compute instances delete "$INSTANCE_NAME" --quiet --project="$PROJECT" --zone="$ZONE"
}

start() {
  if [[ $MACHINE_TYPE == "" ]]; then echo "--machine is required" >&2 ; exit 1 ; fi
  if [[ $SERVICE_ACCOUNT == "" ]]; then echo "--serviceaccount is required" >&2 ; exit 1 ; fi

  echo MACHINE_TYPE="$MACHINE_TYPE"
  echo DISK_TYPE="$DISK_TYPE"
  echo DISK_SIZE="$DISK_SIZE"
  echo MISC_OPTIONS="$MISC_OPTIONS"

  echo "Creating instance based on snapshot"
  time gcloud compute instances create "$INSTANCE_NAME" \
    --project="$PROJECT" \
    --zone="$ZONE" \
    --machine-type="$MACHINE_TYPE" \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --maintenance-policy=TERMINATE \
    --service-account="$SERVICE_ACCOUNT" \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --tags=mkg \
    --create-disk=auto-delete=yes,boot=yes,device-name="$INSTANCE_NAME",mode=rw,size="$DISK_SIZE",source-snapshot=projects/mk-accel-stream/global/snapshots/"$INSTANCE_NAME",type=projects/mk-accel-stream/zones/asia-east1-a/diskTypes/"$DISK_TYPE" \
    --reservation-affinity=any \
    $MISC_OPTIONS
}

if [[ $ACTION == "up" ]]; then
  start
elif [[ $ACTION == "down" ]]; then
  shutdown
else
  echo "must specify \"up\" or \"down\""
fi
