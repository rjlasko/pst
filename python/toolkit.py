#!/usr/bin/env python


def wakeHost(hostname, nmap_file):
	from Hacks import nmap
	from wakeonlan import wol
	
	for mac in nmap.getMac(hostname, nmap_file):
		wol.send_magic_packet(mac)


def getLocalIps():
	d = getInterfaceIpDict()
	for (ifaceName, addresses) in d.iteritems():
		for addy in addresses:
			if addy not in (None,'127.0.0.1'):
				print addy

def getInterfaceIPs():
	for (ifaceName, addys) in getInterfaceIpDict().iteritems():
		print '%s: %s' % (ifaceName, ', '.join(addys) if addys[0] is not None else '')


def getInterfaceIpDict():
	from netifaces import interfaces, ifaddresses, AF_INET
	ipDict = {}
	for ifaceName in interfaces():
		ipDict[ifaceName] = [i['addr'] for i in ifaddresses(ifaceName).setdefault(AF_INET, [{'addr':None}])]
	return ipDict
