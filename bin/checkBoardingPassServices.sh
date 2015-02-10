#!/bin/bash

## CONSTANTS ##

if [ -z "$1" ]
  then
    BOARDING_PASS_WEBSERVICE="http://services.michael-kuck.com/boarding-pass/rest/flights/top?airline_code=KE"
	OPEN_FLIGHTS_WEBSERVICE="http://services.michael-kuck.com/open-flights/rest/airlines?iata=KE"
else
	BOARDING_PASS_WEBSERVICE="$1/boarding-pass/rest/flights/top?airline_code=KE"
	OPEN_FLIGHTS_WEBSERVICE="$1/open-flights/rest/airlines?iata=KE"
fi

YES=0 # Remeber exit code 0 is success. Don't think true=1/false=0
NO=1  # Remeber exit code != 0 is error. Don't think true=1/false=0

## FUNCTIONS ##

urlContentDoesContain () {
	local url="$1"
	local pattern="$2"
	local result=$NO

	local content=$(curl -sL "$url")
	echo -n "Checking: $url..."
	if [[ "$content" == *"$pattern"* ]]; then
		echo "OK"
		result=$YES
	else
		echo "FAILED"
		result=$NO
		echo "Result: $content"
	fi

	# echo "$content"
	return $result
}

## START MAIN ##

urlContentDoesContain "$BOARDING_PASS_WEBSERVICE" "\"airlineCode\":\"KE\""
urlContentDoesContain "$OPEN_FLIGHTS_WEBSERVICE" "\"name\":\"Korean Air\""



