"""
A module to access data gathered by the NMap utility
"""

# Python Standard Libraries
import os, subprocess, socket, json
from operator import itemgetter
from collections import defaultdict

# PST Libraries
from ClassUtils import JsonAble
import env


NAMELESS_HOST_STR = 'n/a'
CURRENT_NMAP = None


def getMac(searchName, json_filename, doScan=False):
	global CURRENT_NMAP
	if doScan:
		scan(display=False)
	else:
		load(json_filename)

	for h in CURRENT_NMAP:
		hNames = [n.lower() for n in h.names]
		sName = searchName.lower()
		if (sName in hNames) or (sName in [n.split('.')[0] for n in hNames if ('.' in n)]):
			return h.addresses['mac']


def load(json_filename):
	"""
	A function that will load a previously scanned & saved network map from file
	"""
	global CURRENT_NMAP
	hostDictList = None
	with open(json_filename, mode='r') as f:
		hostDictList = json.load(f)
	CURRENT_NMAP = [_Host().fromDict(hd) for hd in hostDictList]
	return CURRENT_NMAP


def save(json_filename, hostList=None):
	"""
	A function that will scan the network map and write it out to the given file directory.
	If the update flag is given, it will attempt to update the existing document with anything
	found that is new or different, otherwise it will be overwritten. 
	"""
	global CURRENT_NMAP
	if hostList is None:
		hostList = CURRENT_NMAP if (CURRENT_NMAP is not None) else scan(False)
	hostDictList = [h.toDict() for h in hostList]
	with open(json_filename, mode='w') as f:
		json.dump(hostDictList, f, indent=4)


def scan(display=True):
	"""
	A method that does something
	"""
	global CURRENT_NMAP
	CURRENT_NMAP = _parseNmapXML(_performScan())
	if display:
		printHostList(CURRENT_NMAP)
	return CURRENT_NMAP


def printHostList(hostList):
		header = _Host(['names'], {'type':['address']})
		n = max(header.maxNameWidth(), max([nh.maxNameWidth() for nh in hostList]))
		t = max(header.maxTypeWidth(), max([nh.maxTypeWidth() for nh in hostList]))
		a = max(header.maxAttrWidth(), max([nh.maxAttrWidth() for nh in hostList]))

		# sort hosts in ascending order (of the first host name, if there are any)
		hostList.sort(key=lambda x: ((len(x.names) == 0), x.names[0].lower() if x.names else ''), reverse=False)

		# table starts with a header
		hostTable = header.getStr(n, t, a)
		# and then a divider
		hostTable += _Host(['=' * n], {'=' * t:['=' * a]}).getStr(n, t, a)
		# and then the host list
		for nh in hostList:
			hostTable += nh.getStr(n, t, a)
		print hostTable


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


def _performScan(legacy=False):
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

	scan_option = '-sn' if legacy else '-sP'
	p = subprocess.Popen(['nmap', scan_option, my_ip_segment, '-oX', '-'],
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
		# convert the addresses dict to a printable list
		addrList = []
		for (k, vl) in self.addresses.iteritems():
			for v in vl:
				addrList.append((k, v))

		wN = wN if (wN is not None) else self.maxNameWidth()
		wT = wT if (wT is not None) else self.maxTypeWidth()
		wA = wA if (wA is not None) else self.maxAttrWidth()
		columnFmt = lambda x, y: '%' + str(x + y) + 's'
		line_fmt = '%s' + columnFmt(wN, 2) + columnFmt(wT, 2) + columnFmt(wA, 2) + '\n'

		# cleanup each entry
		self.names.sort()
		addrList.sort(cmp=None, key=itemgetter(0, 1), reverse=False)

		# print the table
		FIRST = '-'
		NOTFIRST = ' '
		ret_str = ''
		for i in range (0, max(len(self.names), len(addrList))):
			# make a mark for each host, but only on the first hostname
			mark = NOTFIRST if i else FIRST
			name = ('' if i else NAMELESS_HOST_STR) if (i >= len(self.names)) else self.names[i]
			type = '' if (i >= len(addrList)) else addrList[i][0]
			addr = '' if (i >= len(addrList)) else addrList[i][1]
			ret_str += line_fmt % (mark, name, type, addr)
		return ret_str

	def maxNameWidth(self):
		if self.names:
			return len(max(self.names, key=len))
		else:
			return len(NAMELESS_HOST_STR)

	def maxTypeWidth(self):
		return 0 if not self.addresses.keys() else len(max(self.addresses.keys(), key=len));

	def maxAttrWidth(self):
		return 0 if not self.addresses.values() else \
			len(max([max(a, key=len) for a in self.addresses.values()], key=len))

