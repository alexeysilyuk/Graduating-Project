

class arp:
    def __init__(self,allDeviceField):
        '''
        check the FLAGS field, when the value is 0x2 the station is connected and 0x0 is disconnected
        '''
        self.flagField = allDeviceField['Flags']
        self.MAC_address = allDeviceField['HW address']
        self.IP_address = allDeviceField['IP address']
        self.device = allDeviceField['Device']

    def getFlag(self):
        return self.flagField

    def getMac_address(self):
        return self.MAC_address
    
    def getIP_address(self):
        return self.IP_address
    
    def getDevice(self):
        return self.device
