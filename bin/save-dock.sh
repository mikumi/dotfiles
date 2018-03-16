#!/bin/sh
dockutil --list | sed 's/.*\(file:\/\/.*persistent-[^\s]*\).*/\1/g' | \
        sed 's/file\:\/\/\//dockutil --add "\//g' | \
        sed 's/%20/ /g' | \
        sed 's/.app\//.app" --no-restart/g' | \
        sed 's/\s*persistent-app//g' | \
        sed 's/\/[[:space:]]*persistent-other/" --view fan --display stack --no-restart/g'
