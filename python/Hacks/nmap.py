"""
A module to access data gathered by the NMap utility
"""

import os
import subprocess
import socket
from collections import defaultdict

from Hacks import env


def printScan(fast=True):
	"""
	A method that does something
	"""
	_NmapHost(['names'], {'type':['address']}).printHostTable(_parseNmapXML(_scan()))


def save(filepath, update=False):
	"""
	A function that will scan the network map and write it out to the given file directory.
	If the update flag is given, it will attempt to update the existing document with anything
	found that is new or different. 
	"""
	


def update():
	"""
	TODO: build a function that will update an NMap generated xml with the findings of a recent NMap
	"""
	pass


def test():
	x = _NmapHost()
	x.names.append("goofy")
	x.names.append("donald")
	x.names.append("waldo")
	x.addresses['mac'].append('ads')
	x.addresses['mac'].append('asad')
	x.addresses['ipv4'].append('1222222')
	x.addresses['ipv4'].append('1222242')
	x.addresses['ipv4'].append('1222224')
	return x


def _parseNmapXML(nmap_xml):
	"""
	Rename to something more befitting the final output type
	"""
	from xml.etree import ElementTree
	
	nmapHostList = []
	root = ElementTree.fromstring(nmap_xml)
	for host in root.iter('host'):
		item = _NmapHost()

		item.names = [hname.get('name') for hname in host.findall('./hostnames/hostname')]
		addresses = [item.addresses[haddr.get('addrtype')].append(haddr.get('addr')) for haddr in host.findall('./address')]

		# add the host to the list
		nmapHostList.append(item)
	
	return nmapHostList


def _scan(fast=True):
	"""
	Scans the local network map, and returns an XML document describing it 
	"""
# 	if os.getuid() != 0:
# 		raise Exception("This script needs to be run as root!")

	nmap_path = env.which('nmap')
	if nmap_path is None:
		raise Exception('Cannot find the nmap utility in the system path.')

	my_ip = socket.gethostbyname(socket.gethostname())
	a = my_ip.split('.')
	a = a[:-1]
	a.append('*')
	my_ip_segment = '.'.join(a)
	
	scan_type = '-sP' if fast else '-sn'
	
	p = subprocess.Popen(['nmap', scan_type, my_ip_segment, '-oX', '-'],
						stdout=subprocess.PIPE,
						stderr=subprocess.PIPE,
						close_fds=True)
	
	xmlNmap, err = p.communicate()
	return xmlNmap


class _NmapHost():
	def __init__(self, n=None, a=None):
		self.names = n if (n is not None) else []
		self.addresses = a if (a is not None) else defaultdict(list)

	def __repr__(self):
		return self.getStr()
		
	def getStr(self, wN=None, wT=None, wA=None):
		max_lines = self.maxDispLines()
		wN = wN if wN is not None else self.maxNameWidth()
		wT = wT if wT is not None else self.maxTypeWidth()
		wA = wA if wA is not None else self.maxAttrWidth()
		
		columnFmt = lambda x,y: '%' + str(x+y) + 's'
		line_fmt = columnFmt(wN,0) + columnFmt(wT,2) + columnFmt(wA,2) + '\n'
		line_num_fmt = line_fmt

		# always sort the host names
		self.names.sort()
		
		# the new idea is to iterate over the dict lists, and print the next name if we still have them
		ret_str = ''
		i = 0
		for (type, addrs) in self.addresses.iteritems():
			for addr in addrs:
				name = '' if (len(self.names)<=i) else self.names[i]
				ret_str += line_fmt % (name, type, addr)
				i += 1
		# print hostnames if we have not reached max lines
		for j in range(i, max_lines):
			ret_str += line_fmt % (self.names[i], '', '')

		return ret_str
	
	def maxDispLines(self):
		max_lines = len(self.names)
		num_addr = 0
		for (type, addr) in self.addresses.iteritems():
			num_addr += len(addr)
		return max(max_lines, num_addr)

	def maxNameWidth(self):
		if self.names:
			return len(max(self.names, key=len))
		else:
			self.names = ['~']
			return 1
	
	def maxTypeWidth(self):
		return 0 if not self.addresses.keys() else len(max(self.addresses.keys(), key=len));

	def maxAttrWidth(self):
		return 0 if not self.addresses.values() else \
			len(max([max(a, key=len) for a in self.addresses.values()], key=len))

	def printHostTable(self, nhList=None):
		n=max(self.maxNameWidth(), max([nh.maxNameWidth() for nh in nhList]))
		t=max(self.maxTypeWidth(), max([nh.maxTypeWidth() for nh in nhList]))
		a=max(self.maxAttrWidth(), max([nh.maxAttrWidth() for nh in nhList]))
		nhList.sort(key=lambda x: x.names[0].lower(), reverse=False)
		print self.getStr(n, t, a)
		for nh in nhList:
			print nh.getStr(n, t, a)
			