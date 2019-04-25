import csv

class ReadArpUtility:

    def __init__(self):
        pass

    def get_arp_table(self):
        # Get ARP table from /proc/net/arp
        
        with open('/proc/net/arp') as arpt:
            names = [
                'IP address', 'HW type', 'Flags', 'HW address',
                'Mask', 'Device'
            ]  # arp 1.88, net-tools 1.60

            reader = csv.DictReader(
                arpt, fieldnames=names,
                skipinitialspace=True,
                delimiter=' ')

            next(reader)  # Skip header.

            return [block for block in reader]
    
    def get_pairs_of_mac_and_ip(self):
        initial_pair_of_ip_and_mac = []
        for i in list(self.get_arp_table()): 
            mac_ip = (i['HW address'],i['IP address'])
            initial_pair_of_ip_and_mac.append(mac_ip)

        return initial_pair_of_ip_and_mac