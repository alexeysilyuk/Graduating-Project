import socket
from general import *
from networking.ethernet import Ethernet
from networking.ipv4 import IPv4
from networking.icmp import ICMP
from networking.tcp import TCP
from networking.udp import UDP
from networking.pcap import Pcap
from networking.http import HTTP
from uuid import getnode as get_mac
from decimal import *
import time
from multiprocessing import Process, Queue
from ARP_Analytics.ARP_analytics import *
from Safe_surfing.Black_list_ip_analyzer import blackListAnalyze
import sys

TAB_1 = '\t - '
TAB_2 = '\t\t - '
TAB_3 = '\t\t\t - '
TAB_4 = '\t\t\t\t - '

DATA_TAB_1 = '\t   '
DATA_TAB_2 = '\t\t   '
DATA_TAB_3 = '\t\t\t   '
DATA_TAB_4 = '\t\t\t\t   '

mac = get_mac()
my_mac_address = ':'.join(("%012X" % mac)[i:i+2] for i in range(0, 12, 2))

def ARP_Sniffer_Analyzer():
    global listOfSuspectedMAC
    pcap = Pcap('ARP capture.pcap')
    conn = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.ntohs(3))

    _ARP_analytics = ARP_analytics()
    q = Queue()
    
    alreadySuspectedMACs = Queue()
    list_of_already_suspected = []

    p = Process(target=_ARP_analytics.analyze_ARP, args=(q,alreadySuspectedMACs,))
    p.start()

    while True:
        Biggest_buffer_we_can_afford  = 65535
        raw_data, addr = conn.recvfrom(Biggest_buffer_we_can_afford)
        pcap.write(raw_data)
        eth = Ethernet(raw_data)
        if eth.src_mac == my_mac_address:
            continue

        def check_if_We_already_alert_about_this_MAC():
            if not alreadySuspectedMACs.empty():
                holder = alreadySuspectedMACs.get()
                if holder not in list_of_already_suspected:
                    list_of_already_suspected.append(holder)

        #ARP packet
        if eth.original_proto == 2054:
            if eth.src_mac != 'FF:FF:FF:FF:FF:FF':
                check_if_We_already_alert_about_this_MAC()

                if eth.src_mac not in list_of_already_suspected:
                    q.put(eth.src_mac)
                    print(eth.src_mac)
            continue

ARP_Sniffer_Analyzer()

