from ReadArp import ReadArpUtility
import subprocess
import time
import sys, getopt, os 

turnLog = False
def log(string,printThis = False):
        if turnLog or printThis:
                print(string)


receiverEmail="mrdolbyking@gmail.com" 
def sendEmail(attack_type,data):
	# add subject to mail text
	subject = "Subject: "+attack_type+" attack detected"
	command = "echo "+subject+" > email.txt"
	os.system(command)
	
	# add message to mail text
	os.system("echo ' ' >> email.txt")
	command = "echo " + data + " >> email.txt"
	os.system(command)
	# send mail text to receiver
	command="cat email.txt | sendmail "+receiverEmail
	os.system(command) 
	log("Report email sent!")

def ping_all():
        while True: 
                log('Pinging everyones',True)    
                arpUtil = ReadArpUtility()
                bashCommand = "fping -g " + arpUtil.get_pairs_of_mac_and_ip()[0][1] + '/24' + ' -q'
                log('Bash command:')
                log(bashCommand)
                process = subprocess.Popen(bashCommand.split(), stdout=subprocess.DEVNULL)
                output, error = process.communicate()
                log('output:')
                log(output)
                log('Error:')
                log(error)
                log('Pinging finished',True)
                time.sleep(20)