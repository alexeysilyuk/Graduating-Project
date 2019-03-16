#!/bin/bash
while read line; do

    ## Reset variables on new network
    [[ "$line" =~ Cell || "$line" == "" ]] && {

        # If no WPA encryption info was found though "Encryption" was "On", then we have WEP
        [[ "$encryption" == "" && "$enc" =~ On ]] && encryption = "WEP"

        # If we already found one network then echo its information
        [[ "$network" != "" ]] && echo "$network"
        network=""
        encryption=""
    }

    ## Test line content and parse as required
    [[ "$line" =~ Address ]] && mac=${line##*ss: }
       ## The ESSID is the last line of the basic channel data, so build information string now
    [[ "$line" =~ ESSID ]] && {
        essid=${line##*ID:}
        network="$mac $essid"  # output after ESSID
    }

done < <(iwlist wlan0 scan 2>/dev/null )
