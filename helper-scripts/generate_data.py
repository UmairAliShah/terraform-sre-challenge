
import csv
import random
import string
import time

total_entries=random.randint(10, 1000)
titles = ['Mr', 'Ms', 'Dr', 'Lt']
ts = time.localtime(time.time())
filename = "userdata_%d%d%d-%d:%d:%d.csv" % (ts.tm_year, ts.tm_mon, ts.tm_mon, ts.tm_hour, ts.tm_min, ts.tm_sec)

def get_name(size=10, chars=string.ascii_uppercase + string.digits):
    fname = ''.join(random.choice(chars) for _ in range(size))
    lname = ''.join(random.choice(chars) for _ in range(size))
    return fname,lname

with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter=',')
    csvwriter.writerow(['Title', 'First Name', 'Last Name', 'Status', 'Email', 'Age'])
    i=0
    while i <= total_entries:
        i += 1
        fname,lname = get_name(random.randint(10, 50))
        email="{}.{}@example.com".format(fname, lname)
        age=random.randint(18, 60)
        csvwriter.writerow([random.choice(titles), fname, lname, random.randint(0,1), email, age])

print("File : {}".format(filename))
print("CSV file generated with {} entries!".format(total_entries))
