import sys, getopt, os 

def sendEmail(attack_type,data,email):
	# add subject to mail text
	subject = "Subject: "+attack_type+" attack detected"
	command = "echo "+subject+" > email.txt"
	os.system(command)
	
	# add message to mail text
	os.system("echo ' ' >> email.txt")
	command = "echo "+data+" >> email.txt"
	os.system(command)
	# send mail text to receiver
	command="cat email.txt | sendmail "+email
	os.system(command) 
	print "Report email sent!"
def main(argv):
	attack_type=''
	data=''
	email=''
	try:
		opts, args = getopt.getopt(argv,"t:d:e:")
	except getopt.GetoptError:
		print 'ananyzer.py -d <domain>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == "-t":
			attack_type = arg
		elif opt == "-d":
			data = arg
		elif opt == "-e":
			email = arg
		else:
			print 'incorrect argument'
	sendEmail(attack_type,data,email) 
if __name__ == "__main__":
	main(sys.argv[1:])
