import os 
import csv
import time
from datetime import datetime
import pytz

class reqDataHolder():
    def __init__(self):
        self.hour = None
        self.date = None
        # self.day_in_week = None
        # self.day_in_month = None
        # self.month = None
        # self.year = None
        # self.minutes = None
        # self.seconde = None
        self.id = None
        self.MAC = None
        self.ip_src = None
        self.udp_src_port = None
        self.ip_dst = None
        self.udp_dst_port = None
        self.queryName = None
        self.computerName = None

        #check if dir exist if not create it
        def check_dir():
            try:
                with open('history.csv', 'rb') as csvfile:
                    pass
            except:
                with open('history.csv', 'wb') as csvfile:
                    pass
        check_dir()

    def __repr__(self):
        return self.getData()
    def __str__(self):
        return str(self.getData())

    def setTimeAndDate(self):
        self.date = time.strftime("%d/%m/%y")
        now =  datetime.now(tz=pytz.timezone('Israel'))
        self.time = str(now.hour) +':'+ str(now.minute)

    def getData(self):
        return [self.ip_src,self.MAC,self.date,self.time]

    def reportToCsvFile(self):
        line = [self.ip_src,self.MAC,self.date,self.time]
        with open('history.csv', 'a') as f:
            writer = csv.writer(f)
            writer.writerow(line)