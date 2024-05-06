#!/bin/bash

# Function to send email
send_email() {
    local recipient="$1"
    local cc="$2"
    local subject="$3"
    local message="$4"

    # SMTPeter settings
    local smtp_server="smtp.office365.com"
    local smtp_user="37663968@mynwu.ac.za"
    local smtp_password=""
    local from_address="37663968@mynwu.ac.za"

    # Email data
    local email_data="From: $from_address
To: $recipient
Cc: $cc
Subject: $subject

$message"

    # Send email via SMTPeter using curl
    curl --ssl-reqd --url "$smtp_server" \
         --mail-from "$from_address" \
         --mail-rcpt "$recipient" \
         --mail-rcpt "$cc" \
         --user "$smtp_user:$smtp_password" \
         --upload-file <(echo "$email_data")
}

# Main function
main() {
    # Email details
    local subject="Email Personalisation - Test Run"
    local message="Good day, this is just a test run."

    # File containing recipient emails
    local recipient_file="recipient_list.txt"
    local cc_file="cc_list.txt" # File containing CC emails

    # Check if recipient file exists
    if [ ! -f "$recipient_file" ]; then
        echo "Recipient file '$recipient_file' not found."
        exit 1
    fi

    # Check if cc file exists
    if [ ! -f "$cc_file" ]; then
        echo "CC file '$cc_file' not found."
        exit 1
    fi

    # Read recipient emails from file
    mapfile -t recipients < "$recipient_file"

    # Read cc emails from file
    mapfile -t cc < "$cc_file"

    # Loop through recipients
    for recipient in "${recipients[@]}"; do
        # Remove leading and trailing whitespace
        recipient=$(echo "$recipient" | tr -d '[:space:]')

        # Loop through cc list
        for cc_recipient in "${cc[@]}"; do
            # Remove leading and trailing whitespace
            cc_recipient=$(echo "$cc_recipient" | tr -d '[:space:]')

            # Send email
            send_email "$recipient" "$cc_recipient" "$subject" "$message"
        done
    done
}

# Execute main function
main
