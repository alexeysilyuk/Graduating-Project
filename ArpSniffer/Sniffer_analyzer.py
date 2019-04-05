from scapy.all import ARP, sniff
from decimal import *
import time
from datetime import datetime
import pytz
from multiprocessing import Process, Queue
from ARP_analytics import *
import sys
from requestDataHolder import reqDataHolder

q = Queue()
alreadySuspectedMACs = Queue()
list_of_already_suspected = []
_ARP_analytics = ARP_analytics()
def ARP_Sniffer_Analyzer():
    # global listOfSuspectedMAC
    
    global q
    global alreadySuspectedMACs
    global list_of_already_suspected

    p = Process(target=_ARP_analytics.analyze_ARP, args=(q,alreadySuspectedMACs,))
    p.start()

ARP_Sniffer_Analyzer()
                
def check_if_We_already_alert_about_this_MAC():
    if not alreadySuspectedMACs.empty():
        holder = alreadySuspectedMACs.get()
        print("holder")
        print(holder)
        if holder not in list_of_already_suspected:
            list_of_already_suspected.append(holder)

def getDataHolder(pkt):
        dataHolder = reqDataHolder()
        dataHolder.ip_src = pkt[ARP].psrc
        dataHolder.MAC = pkt[ARP].hwsrc
        dataHolder.setTimeAndDate()
        
        print(dataHolder)
        return dataHolder
def check_if_need_to_empty_list():
    global _ARP_analytics
    needToDelete = _ARP_analytics.checkIfNeedToEmptySuspectedList()
    if needToDelete:
        del list_of_already_suspected[:]

def arp_display(pkt):
    global list_of_already_suspected
    if pkt[ARP].op == 1:  # who-has (request)
        #print( "Request: " + str(pkt[ARP].psrc) + " is asking about " + str(pkt[ARP].pdst)) 
        # ARP spoofing is just when the device flood with response and not 
        # with a requests
        pass
        
    if pkt[ARP].op == 2:  # is-at (response)
        check_if_We_already_alert_about_this_MAC()
        print( "Response: " + str(pkt[ARP].hwsrc) + " has address " + str(pkt[ARP].psrc))
        check_if_need_to_empty_list()
        if pkt[ARP].hwsrc not in list_of_already_suspected:
            dataHolder = getDataHolder(pkt)
            q.put(dataHolder)
 
sniff(prn=arp_display, filter="arp")