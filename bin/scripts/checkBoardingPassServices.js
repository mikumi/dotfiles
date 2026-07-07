#!/usr/bin/env node

var http = require('http');

var DEFAULT_DOMAIN = "http://services.michael-kuck.com";
var BOARDING_PASS_WEBSERVICE_SUFFIX = "/boarding-pass/rest/flights/top?airline_code=KE";
var BOARDING_PASS_PATTERN = "\"airlineCode\":\"KE\"";
var OPEN_FLIGHTS_WEBSERVICE_SUFFIX = "/open-flights/rest/airlines?iata=KE";
var OPEN_FLIGHTS_PATTERN = "\"name\":\"Korean Air\"";

function urlContentContains(url, pattern) {
    http.get(url, function(res) {
        res.setEncoding('utf8');
        res.on('data', function (chunk) {
            if (chunk.indexOf(pattern) > -1) {
                console.log(url + " -> OK");
            } else {
                console.log(url + " -> FAILED");
            }
        });
    }).on('error', function(e) {
         console.log(url + " -> FAILED");
    });
}


boardingPassUrl = DEFAULT_DOMAIN + BOARDING_PASS_WEBSERVICE_SUFFIX;
openFlightsUrl = DEFAULT_DOMAIN + OPEN_FLIGHTS_WEBSERVICE_SUFFIX;

if (process.argv.length >= 3) {
    domain = process.argv[2];
    boardingPassUrl = domain + BOARDING_PASS_WEBSERVICE_SUFFIX
    openFlightsUrl = domain + OPEN_FLIGHTS_WEBSERVICE_SUFFIX
}

console.log("Checking urls...");
urlContentContains(boardingPassUrl, BOARDING_PASS_PATTERN)
urlContentContains(openFlightsUrl, OPEN_FLIGHTS_PATTERN)
