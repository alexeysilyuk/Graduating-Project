import io
import json
import os
from utility import *
import time
import csv
from fireBase import *

class arpAnaliytics():


    def __init__(self):
        self.path_to_analiytic_json = os.path.dirname(os.path.abspath(__file__)) + '/ARPanaliytic.json'
        self.path_to_blacklist_MAC_addresses = os.path.dirname(os.path.abspath(__file__)) + '/Blacklist_MAC_addresses.csv'

        self.check_if_cash_file_is_exist_if_not_created()
        self.check_if_blacklist_file_not_created()
        self.suspected_MACs = []

    def Alert_for_suspected_MAC_address(self,s_MAC,s_IP,victimIP):
        saveMACin_blacklist(s_MAC)
            

    def updateDataBase(self,listOf_ip_and_mac):
        if os.path.isfile(self.path_to_analiytic_json) and os.access(self.path_to_analiytic_json, os.R_OK):
            
            with open(self.path_to_analiytic_json) as data_file:
                data_loaded = json.load(data_file)
                log(data_loaded)

            infected_IP = False

            #if not the first time
            if data_loaded != {}:
                for i in range(0,len(listOf_ip_and_mac)):
                    newList = list(listOf_ip_and_mac[i])
                
                    for j in data_loaded:
                        # If the MAC is the same but ip is defferent.
                        if newList[0] == j[0] and newList[1] != j[1]:
                            self.Alert_for_suspected_MAC_address(newList[0],newList[1],j[1])
                            infected_IP = True
                            print('Alert')
                    if (newList in data_loaded) or (infected_IP == True):
                        infected_IP = False
                        pass
                    elif newList[0] != '00:00:00:00:00:00':
                        print(newList)
                        data_loaded.append(newList)
                        self.updateLocalDataBase(data_loaded)
                    infected_IP = False
                log(data_loaded,True)
            else:
                listWithoutZeros = []
                for i in listOf_ip_and_mac:
                    if i[0] != '00:00:00:00:00:00':
                        listWithoutZeros.append(i)
                self.updateLocalDataBase(listWithoutZeros)

    def updateLocalDataBase(self,listOf_ip_and_mac):
        with open(self.path_to_analiytic_json, 'w') as f:
            json.dump(listOf_ip_and_mac, f, ensure_ascii=False)

    def check_if_blacklist_file_not_created(self):
        if os.path.isfile(self.path_to_blacklist_MAC_addresses) and os.access(self.path_to_blacklist_MAC_addresses, os.R_OK):
            with open(self.path_to_blacklist_MAC_addresses, 'w+') as csvfile:
                filewriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
                os.chmod(self.path_to_blacklist_MAC_addresses,0o777)
            

    def check_if_cash_file_is_exist_if_not_created(self):
        
        log(self.path_to_analiytic_json)

        # if os.path.isfile(self.path_to_analiytic_json) and os.access(self.path_to_analiytic_json, os.R_OK):
        #     # checks if file exists
        #     log ("File exists and is readable")
        #     os.chmod(self.path_to_analiytic_json,0o777)
        # else:
        #     log ("Either file is missing or is not readable, creating file...")
        with io.open(os.path.join(self.path_to_analiytic_json, self.path_to_analiytic_json), "w+") as db_file:
            db_file.write(json.dumps({}))
            os.chmod(self.path_to_analiytic_json,0o777) 