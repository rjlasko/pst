"""
A module to access data gathered by the NMap utility
"""

# Python Standard Libraries
import os, subprocess, socket
from collections import defaultdict

# PST Libraries
from ClassUtils import JsonAble
import env


def testList(fast=True):
	"""
	A method that does something
	"""
	x = testHost("goofy")
	y = testHost("doofy")
	z = [x, y]
	printHostList(z)

	t = [a.toDict() for a in z]

	import json

	tJ = json.JSONEncoder(indent=4).encode(t)
	print tJ
	tD = json.JSONDecoder().decode(tJ)
	print tD
	t_ = [_Host().fromDict(a) for a in tD]
	printHostList(t_)


def testHost(firstName):
	x = _Host()
	x.names.append(firstName)
	x.names.append("1")
	x.names.append("2")
	x.addresses['mac'].append('ads')
	x.addresses['mac'].append('asad')
	x.addresses['ipv4'].append('1222222')
	x.addresses['ipv4'].append('1222242')
	x.addresses['ipv4'].append('1222224')
	return x


def printScan(fast=True):
	"""
	A method that does something
	"""
	printHostList(_parseNmapXML(_scan()))


def printHostList(hostlist):
		header = _Host(['names'], {'type':['address']})
		n = max(header.maxNameWidth(), max([nh.maxNameWidth() for nh in hostlist]))
		t = max(header.maxTypeWidth(), max([nh.maxTypeWidth() for nh in hostlist]))
		a = max(header.maxAttrWidth(), max([nh.maxAttrWidth() for nh in hostlist]))

		hostlist.sort(key=lambda x: x.names[0].lower(), reverse=False)

		hostTable = header.getStr(n, t, a)
		hostTable += _Host(['=' * n], {'=' * t:['=' * a]}).getStr(n, t, a)
		for nh in hostlist:
			hostTable += nh.getStr(n, t, a)
		print hostTable


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


def _parseNmapXML(nmap_xml):
	"""
	Generates an _HostList from a NMap XML document
	"""
	from xml.etree import ElementTree

	nmapHostList = list()
	root = ElementTree.fromstring(nmap_xml)
	for host in root.iter('host'):
		item = _Host()
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


class _Host(JsonAble):
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

		columnFmt = lambda x, y: '%' + str(x + y) + 's'
		line_fmt = '%s' + columnFmt(wN, 2) + columnFmt(wT, 2) + columnFmt(wA, 2) + '\n'
		line_num_fmt = line_fmt

		# always sort the host names
		self.names.sort()

		# the new idea is to iterate over the dict lists, and print the next name if we still have them
		FIRST = '-'
		NOTFIRST = ' '
		ret_str = ''
		i = 0
		for (type, addrs) in self.addresses.iteritems():
			for addr in addrs:
				# make a mark for each host, but only on the first hostname
				mark = NOTFIRST if i else FIRST
				name = '' if (len(self.names) <= i) else self.names[i]
				ret_str += line_fmt % (mark, name, type, addr)
				i += 1
		# print any remaining hostnames if we have not reached max_lines
		for j in range(i, max_lines):
			ret_str += line_fmt % (FIRST, self.names[i], '', '')

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

