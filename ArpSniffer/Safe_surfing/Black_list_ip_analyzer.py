from multiprocessing import Process, Queue
from firebase import firebase
import socket 

class blackListAnalyze():
    def __init__(self):
        self.blackList = TheBlackList()
        self._firebase = firebase.FirebaseApplication('https://safewifi-a7dc0.firebaseio.com', None)
        self.savedIP = {}

    def analyze_IP(self,q): 
        while True:
            popped = q.get() 
            if popped == 'Stop':
                break

            if popped[1] not in self.savedIP.keys():

                # print('keys - ' + str(self.savedIP.keys()))

                # print('src' + str(popped[0]))
                # print('dest' + str(popped[1]))
                
                try:
                    host_name , alias, addresslist = socket.gethostbyaddr(str(popped[1]))
                    host_ip = socket.gethostbyname(host_name) 
                    print('')
                    print("Hostname :  ",host_name) 
                    print("IP : ",host_ip)
                    print('')
                except:
                    pass
                self.savedIP[popped[1]] = ''
                

    def get_black_list_IPs(self):
        self.blackList.Chatting = self._firebase.get('/Black_List_Web_Site/Chatting',None)
        self.blackList.Porn = self._firebase.get('/Black_List_Web_Site/Porn',None)
        self.blackList.Gambling = self._firebase.get('/Black_List_Web_Site/Gambling',None)

class TheBlackList():
    def __init__(self):
        self.Gambling = []
        self.Porn = []
        self.Chatting = []
