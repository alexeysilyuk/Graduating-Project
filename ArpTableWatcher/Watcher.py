import time
from ReadArp import ReadArpUtility  
from arp import arp
from arpAnaliytic import arpAnaliytics
from utility import *
import _thread

def main():
    # get all connected IPs in local
    # And start it in a new thread 
    _thread.start_new_thread(ping_all, ())
    log('Pinging everyones',True)    

    ArpUtil = ReadArpUtility()
    initial_pair_of_ip_and_mac = ArpUtil.get_pairs_of_mac_and_ip()
    
    arpAnal = arpAnaliytics()
    arpAnal.updateDataBase(initial_pair_of_ip_and_mac)

    log(initial_pair_of_ip_and_mac)

    while True:
        time.sleep(1)
        newListOfArpTable = ArpUtil.get_pairs_of_mac_and_ip()
        arpAnal.updateDataBase(newListOfArpTable)




main()