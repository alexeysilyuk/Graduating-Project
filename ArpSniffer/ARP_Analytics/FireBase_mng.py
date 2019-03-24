from firebase import firebase
import json
import os
import io
import random
import string
import time

class FireBaseMng():
    def __init__(self):
        self._firebase = firebase.FirebaseApplication('https://safewifi-a7dc0.firebaseio.com', None)
        
        self.path_to_username_and_password = os.path.dirname(os.path.abspath(__file__)) + '/userNameAndPass.json'
        self.userName = ''
        self.password = ''
        self.setGetUser()

        self.preventFlooding = []
        

    def get_trusted_MAC_addresses(self):
        return self._firebase.get('/Trusted MAC addresses', None).values()

    def setGetUser(self):
        if os.path.isfile(self.path_to_username_and_password) and os.access(self.path_to_username_and_password, os.R_OK):
            # checks if file exists
            with open(self.path_to_username_and_password) as data_file:
                data = json.load(data_file)
                self.userName = list(data.keys())[0]
                print('name - ' + self.userName)
                self.password = data[self.userName]
                print('pass - ' + str(self.password))
        else:
            print ("Either file is missing or is not readable, creating file...")
            with io.open(os.path.join(self.path_to_username_and_password, self.path_to_username_and_password), "w+") as db_file:
                # Generating user name and password
                N = 5 # Length of user name and pass generated
                user = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(N))
                self.userName = user
                print('user - ' + user)
                pas = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(N))
                self.password = pas
                print('pass - ' + pas)
                tempDict = {}
                tempDict[user] = pas  
                db_file.write(json.dumps(tempDict))
                os.chmod(self.path_to_username_and_password,0o777) 

    def postSuspectedMAC(self,MAC):
        data = self._firebase.get('/' + self.userName + '/Suspected MAC',None)
    
        if data is not None:
            dictOfDataBase = dict(data) 
            list_of_MACs = list(dictOfDataBase.keys())
        
        

        if MAC not in self.preventFlooding:
            self.preventFlooding.append(MAC)
        else:
            return
        print(str(MAC) + ' Suspected')

        if data == None:
            g = {str(MAC):'Suspected'}
            self._firebase.patch('/' + self.userName + '/Suspected MAC',g)
        elif(MAC not in list_of_MACs):
            g = {str(MAC):'Suspected'}
            self._firebase.patch('/' + self.userName + '/Suspected MAC',g)
        else:
            g = {str(MAC):'Suspected'}
            self._firebase.delete('/' + self.userName + '/Suspected MAC/' + MAC,None) 
            self._firebase.patch('/' + self.userName + '/Suspected MAC',g)   