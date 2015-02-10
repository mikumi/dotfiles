#! /bin/sh -
#
# Enable port forwarding
#
# Requirements:
#   your Private Internet Access user and password as arguments
#
# Usage:
#  ./port_forward.sh <user> <password>

error( )
{
  echo "$@" 1>&2
  exit 1
}

error_and_usage( )
{
  echo "$@" 1>&2
  usage_and_exit 1
}

usage( )
{
  echo "Usage: `dirname $0`/$PROGRAM <user> <password>"
}

usage_and_exit( )
{
  usage
  exit $1
}

version( )
{
  echo "$PROGRAM version $VERSION"
}


port_forward_assignment( )
{
  echo 'Loading port forward assignment information..'
  #local_ip=`wget -q -O - 'https://www.privateinternetaccess.com/vpninfo/myip' | head -1`
  local_ip=`ifconfig tun0 | grep "inet " | cut -d\  -f2|tee /tmp/vpn_ip`
  echo 'Local ip: '"$local_ip"
  #client_id=`head -n 100 /dev/urandom | md5 | tr -d " -"`
  client_id=`cat .pia_manager/data/client_id.txt`
  echo 'Client ID: '"$client_id"
  json=`wget -q --post-data="user=$USER&pass=$PASSWORD&client_id=$client_id&local_ip=$local_ip" -O - 'https://www.privateinternetaccess.com/vpninfo/port_forward_assignment' | head -1`
  echo $json
}

EXITCODE=0
PROGRAM=`basename $0`
VERSION=1.0
USER=$1
PASSWORD=$2

while test $# -lt 2
do
  case $1 in
  --usage | --help | -h )
    usage_and_exit 0
    ;;
  --version | -v )
    version
    exit 0
    ;;
  *)
    error_and_usage "Unrecognized option: $1"
    ;;
  esac
  shift
done

port_forward_assignment

exit 0
