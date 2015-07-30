
import socket

from Hacks import nmap;
from wakeonlan import wol;


def wakeHost(hostname, nmap_file):
	for mac in nmap.getMac(hostname, nmap_file):
		wol.send_magic_packet(mac)

def getLocalIp():
	print socket.gethostbyname(socket.gethostname())