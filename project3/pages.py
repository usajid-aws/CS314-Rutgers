import sys       
import subprocess
import re

# Calls the R system specifying that commands come from file commands.R
# The commands.R provided with this assignment will read the file named
# data and will output a histogram of that data to the file pageshist.pdf
def runR( ):
    res = subprocess.call(['R', '-f', 'commands.R'])

# log2hist analyzes a log file to calculate the total number of pages
# printed by each user during the period represented by this log file,
# and uses R to produce a pdf file pageshist.pdf showing a histogram
# of these totals.  logfilename is a string which is the name of the
# log file to analyze.
#
def log2hist(logfilename):
    
    file = open(logfilename, 'r')
    users = {}
    print_count = []
    count = 0
    for line in file:
    	if('user' not in line):
    		continue
    	else:
    		#extract name from line
    		
    		user_name = re.search(r'user:\s+(\w+)', line).group(1)
    		page_count = re.search(r'pages:\s+(\d+)', line).group(1)
    		#print("page_count: ",page_count)
    		if(user_name in users):
    			users[user_name] += int(page_count)
    		else:
    			users[user_name] = int(page_count)
            
    '''   
    for i in users.values():
    	print(i)
    '''
    data = open('data', 'w+')

    #adds all the pagecounts from user dict
    for pageCount in users.values():
    	data.write('%d\n' % pageCount)

    data.close()
    file.close()

    runR()

    return

if __name__ == '__main__':
    log2hist(sys.argv[1])   # get the log file name from command line

# line above may be changed to log2hist("log") to make the file name
#    always be log

