#!/usr/bin/env -S NODE_ENV=production node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Epoch <-> Human-Readable Date
// @raycast.mode silent
// @raycast.refreshTime 1000s
// @raycast.packageName Conversions
//
// Optional parameters:
// @raycast.icon ⏱
// @raycast.needsConfirmation false
// @raycast.argument1 { "type": "text", "placeholder": "Date or timestamp (optional)", "optional": true }
//
// Documentation:
// @raycast.description Convert between human-readable dates and epoch timestamps.
// @raycast.author Michael Kuck
// @raycast.authorURL https://github.com/mikumi

const { spawnSync } = require("child_process");

// Test Strings:
// 1639633253000
// 1639633253
// Thu, 16 Dec 2021 05:40:53 GMT

const argument = process.argv[2];
const input = argument ? argument.trim() : _pbpaste().trim();
const stringType = _getStringType(input);

if (stringType === 'epoch_millis') {
  const date = new Date(parseInt(input));
  const result = _formatISOWithTimezone(date);
  _pbcopy(result);
  console.log(result);
  return;
} else if (stringType === 'epoch') {
  const date = new Date(parseInt(input) * 1000);
  const result = _formatISOWithTimezone(date);
  _pbcopy(result);
  console.log(result);
  return;
}

const timestamp = Date.parse(input);
if (isNaN(timestamp)) {
  console.log("Provide a valid date or timestamp");
  return;
}
_pbcopy(timestamp.toString());
console.log(timestamp);


// ============================================================
// == Private
// ============================================================

function _pbpaste() {
  return spawnSync('pbpaste').stdout.toString();
}

function _pbcopy(text) {
  spawnSync('pbcopy', [], { input: text });
}

function _getStringType(string) {
  if (string.match(/^\d{13}$/)) {
    return 'epoch_millis';
  } else if (string.match(/^\d{10}$/)) {
    return 'epoch';
  } else {
    return 'text';
  }
}

function _formatISOWithTimezone(date) {
  const offset = -date.getTimezoneOffset();
  const sign = offset >= 0 ? '+' : '-';
  const hours = Math.floor(Math.abs(offset) / 60).toString().padStart(2, '0');
  const minutes = (Math.abs(offset) % 60).toString().padStart(2, '0');

  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  const hour = date.getHours().toString().padStart(2, '0');
  const minute = date.getMinutes().toString().padStart(2, '0');
  const second = date.getSeconds().toString().padStart(2, '0');

  return `${year}-${month}-${day}T${hour}:${minute}:${second}${sign}${hours}${minutes}`;
}
