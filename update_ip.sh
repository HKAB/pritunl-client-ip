#!/bin/bash
while true; do
    output=$(pritunl-client list)
    state=$(echo "$output" | awk -F '|' 'NR==4 {gsub(/^[ \t]+|[ \t]+$/, "", $4); print $4}')

    if [ "$state" = "Inactive" ]; then
        pritunl-client start $YOUR_ID --mode=ovpn -p $YOUR_PASSWORD

        while true; do
        output=$(pritunl-client list)
            ip_address=$(echo "$output" | awk -F '|' 'NR==4 {gsub(/^[ \t]+|[ \t]+$/, "", $8); print $8}')
            # Check if the IP address is not empty
            if [ "$ip_address" != "-" ] && [ "$ip_address" != "" ]; then
                # Update ip.txt with the extracted IP address
                readme="# pritunl-client-ip\n Script to update Client Address IP each time my server reset\n Current IP: $ip_address"
                echo -e "$readme" > README.md

                # Commit and push to GitHub (replace with your repository URL)
                git add README.md
                git commit -m "Update IP address"
                git push origin main

                # Exit the loop if IP address is not empty
                break
            else
                sleep 3
            echo "Wait 3 secs for IP change"
            fi
        done
    else
        echo "Already connected to VPN! Sleep 60 secs"
        sleep 60
    fi
done
