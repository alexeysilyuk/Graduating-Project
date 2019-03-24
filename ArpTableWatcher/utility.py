from ReadArp import ReadArpUtility
import subprocess


turnLog = True
def log(string,printThis = False):
    if turnLog and printThis:
        print(string)


def ping_all():
    arpUtil = ReadArpUtility()
    bashCommand = "fping -g " + arpUtil.get_pairs_of_mac_and_ip()[0][1] + '/24' + ' -q'
    log('Bash command:')
    log(bashCommand)
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.DEVNULL)
    output, error = process.communicate()
    log('out put:')
    log(output)
    log('Error:')
    log(error)
    log('Pinging finished',True)