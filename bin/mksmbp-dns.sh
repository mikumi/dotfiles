#!/bin/bash
set -e

# The host name for which you want to change the DNS IP address
hostname=
# The AWS id for the zone containing the record, obtained by logging into aws route53
zoneid=
# The name server for the zone, can also be obtained from route53
nameserver=
# Optional -- Uncomment to use the credentials for a named profile
export AWS_PROFILE=

# Get your external IP address using opendns service
# newip=`dig +short myip.opendns.com @resolver1.opendns.com`
newip=`dig TXT +short o-o.myaddr.l.google.com @ns1.google.com`
newip="${newip%\"}" # strip quotes
newip="${newip#\"}" # strip quotes
if [[ ! $newip =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]
then
    echo "Could not get current IPV6 address: $newip"
    exit 1
fi

# Get the IP address record that AWS currently has, using AWS's DNS server
oldip=`dig AAAA +short "$hostname" @"$nameserver"`
if [[ ! $oldip =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]
then
    echo "Could not get old IPV6 address: $oldip"
    exit 1
fi

# Bail if everything is already up to date
if [ "$newip" == "$oldip" ]
then
    exit 0
fi

# aws route53 client requires the info written to a JSON file
tmp=$(mktemp /tmp/dynamic-dns.XXXXXXXX)
cat > ${tmp} << EOF
{
    "Comment": "Auto updating @ `date`",
    "Changes": [{
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "ResourceRecords":[{ "Value": "$newip" }],
            "Name": "$hostname",
            "Type": "AAAA",
            "TTL": 60
        }
    }]
}
EOF

echo "Changing IP address of $hostname from $oldip to $newip"
aws route53 change-resource-record-sets --hosted-zone-id $zoneid --change-batch "file://$tmp"

exit
return

rm "$tmp"