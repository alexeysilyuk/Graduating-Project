
# ARP Sniffer analyzer 

To run this write:
```bash
sudo python3 ./Sniffer_analyzer.py
```

sniffer.py - Is just a sniffer that prints all the data he sees.

Sniffer_analayzer.py - Here we parse the packets and check if it is ARP packet.
Then we send it to arp analyzer.

ARP_analyzer.py - analyze_ARP gets a queue and always pop mac address from there.
Then we make statistics of how many times this MAC address is sending arp request.
The way to do the statistics is by a circular buffer.
The circular buffer is in MAC_statistics calss.
We make such class for any MAC address we get. We store there just the time tick.
When we find that some MAC address sends too many arp we send an alert via the firebase.

FireBase_mng.py - 
* Checks if this router already signs up in the server, by checking if e have our username and password in the file.
* If this API asked to post then he makes new JSON or removes and reposted it


