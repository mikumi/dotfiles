#!/usr/bin/env bash

modify_pam_file() {
    local file="$1"
    if grep -q "/opt/homebrew/lib/pam/pam_reattach.so" "$file"; then
        echo "Modification already exists in $file. Skipping..."
    else
        sed -i '' '1 a\
auth       optional       /opt/homebrew/lib/pam/pam_reattach.so\
auth       sufficient     pam_tid.so\
' "$file"
        echo "Successfully modified $file"
    fi
}

# Check and modify /etc/pam.d/su
modify_pam_file "/etc/pam.d/su"

# Check and modify /etc/pam.d/sudo
modify_pam_file "/etc/pam.d/sudo"