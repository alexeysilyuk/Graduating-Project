#!/usr/bin/python

import sys
from firebase import firebase

def _help():
    print('--post')
    print('For posting new item to database')
    print('--path')
    print('Path in the database for post or get')
    print('--key')
    print('Key in database (just in post)')
    print('--value')
    print('Value of this key (just in post)')
    print('')
    print('Example for post:')
    print('sudo python3 ./fire.py --post --path "/a/b/c" --key "yu" --value "kk"')
    print('')
    print('Example for get:')
    print('sudo python3 ./fire.py --get --path "5HA4Q""')

arr = list(sys.argv)

postFlag = False
getFlag = False
key = None
value = None
path = None

for i in range(0,len(arr)):
    if arr[i] == '--post':
        postFlag = True
    if arr[i] == '--get':
        getFlag = True
    if arr[i] == '--path':
        i += 1
        path = arr[i]
    if arr[i] == '--key':
        i += 1
        key = arr[i]
    if arr[i] == '--value':
        i += 1
        value = arr[i]
    if arr[i] == '--help' or arr[i] == '-h':
        _help()
        
f = firebase.FirebaseApplication('https://safewifi-a7dc0.firebaseio.com', None)
if postFlag == True:
    g = {str(key): str(value)}
    f.patch(str(path),g)

if getFlag == True:
    sys.stdout.write( str(f.get(path,None)) )

