#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title World
# @raycast.mode inline
# @raycast.refreshTime 60s
# @raycast.packageName Time

# Optional parameters:
# @raycast.icon 🕐

# Get current time in different timezones
SF_TIME=$(TZ=America/Los_Angeles date "+%I:%M %p")
NY_TIME=$(TZ=America/New_York date "+%I:%M %p")
DE_TIME=$(TZ=Europe/Berlin date "+%I:%M %p")
TW_TIME=$(TZ=Asia/Taipei date "+%I:%M %p")

# Calculate time differences relative to DE
SF_HOUR=$(TZ=America/Los_Angeles date "+%-H")
NY_HOUR=$(TZ=America/New_York date "+%-H")
DE_HOUR=$(TZ=Europe/Berlin date "+%-H")
TW_HOUR=$(TZ=Asia/Taipei date "+%-H")

# Calculate differences (considering day wrap)
SF_DIFF=$((($DE_HOUR - $SF_HOUR + 24) % 24))
NY_DIFF=$((($DE_HOUR - $NY_HOUR + 24) % 24))
TW_DIFF=$((($TW_HOUR - $DE_HOUR + 24) % 24))

echo "🇹🇼🇭🇰 $TW_TIME (+$TW_DIFF)  🇩🇪 $DE_TIME  🗽 $NY_TIME (-$NY_DIFF)  🌁🍁 $SF_TIME (-$SF_DIFF)"
