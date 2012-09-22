#!/usr/bin/python2
import re,urllib2
import subprocess

myip = re.search('\d+\.\d+\.\d+\.\d+',urllib2.urlopen("http://www.ip138.com/ip2city.asp").read()).group(0)
ip = "~/bin/ip.py" + " " + myip
print "Local IP:" + myip
subprocess.call(ip, shell=True)
