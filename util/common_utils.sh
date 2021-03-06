#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

function fileHistogram() {
	echo "upper limit: # files between this and prior limit"
	sudo find . -type f -not -path "*/.zfs/*" -not -path "*/.recycle/*" -print0 \
		| xargs -0 sudo ls -l													\
		| awk '{																\
				n=int(log($5)/log(2));											\
				if (n<10) n=10;													\
				size[n]++														\
			}																	\
			END {																\
				for (i in size) printf("%d %d\n", 2^i, size[i])					\
			}'																	\
		| sort -n																\
		| awk 'function human(x) {												\
				x[1]/=1024;														\
				if (x[1]>=1024) {												\
					x[2]++;														\
					human(x)													\
				}																\
			}																	\
			{																	\
				a[1]=$1;														\
				a[2]=0;															\
				human(a);														\
				printf("%3d%s: %6d\n", a[1],substr("KMGTPEZY",a[2]+1,1),$2) }'
}


if [ -n "$(type -t column)" ] ; then
	alias tcat="column -ts $'\t'"
	function tless () {
		column -ts $'\t' "$@" | less -S ;
	}

	alias ccat="column -ts ,"
	function cless () {
		column -ts , "$@" | less -S ;
	}
fi

if [ -z "$(type -t md5sum)" ] && [ -n "$(type -t openssl)" ] ; then
	alias md5sum='openssl md5'
fi


if [ -n "$(type -t lsof)" ] ; then
	function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi

if [ -n "$(type -t curl)" ] ; then
	alias myPublicIP='curl ipinfo.io/ip'
fi

if [ -n "$(type -t ifconfig)" ] ; then
# XXX: this alias may be overridden by one defined in python_utils.sh
	alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

	if [ -n "$(type -t nmap)" ] ; then

		function lanmacs () {
			local myips=`myip`
			for ip in $myips ; do
				local a=`cut -f1-3 -d"." <(echo $ip)`
				local seg=$a".*"
				echo "-------------------------------------------------------------------------"
				echo "Finding Hosts in LAN segment: "$seg
				echo "-------------------------------------------------------------------------"
				sudo nmap -sP $seg
			done
		}

		function scanip() {
			sudo nmap -sP $1
		}
	fi
fi

# a colorized code-syntax highlighter that operates like less
# XXX: other options are LESSPIPE + GNU's source highlight
#		http://www.gnu.org/software/src-highlite/source-highlight.html#Using-source_002dhighlight-with-less
# or other options:
#		http://superuser.com/questions/71588/how-to-syntax-highlight-via-less
if [ -d "/usr/share/vim" ] ; then
	# this version requires that full VIM be installed, instead of the lite version found in default OS distros
	_VIM_LESS_SH="$(find /usr/share/vim -mindepth 3 -maxdepth 3 -type f -name "less.sh")"
	if [ -n "$_VIM_LESS_SH" ] ; then
		alias vless="$_VIM_LESS_SH"
	fi
	unset _VIM_LESS_SH
fi

if [ -n "$(type -t grep)" ] && [ -n "$(type -t sed)" ] && [ -n "$(type -t tr)" ] ; then

	# find out if we have a GNU or BSD grep
	_GREP_TYPE=$(grep --version | head -n1 | tr '[A-Z]' '[a-z]')

	case $_GREP_TYPE in
		*"gnu grep"*)
			function numPtreeFiles() {
				#(lsof -p `pstree -p $1 | grep -o "[0-9]*" | tr '\n' ','` 2>/dev/null) | awk '{print $2}' | tail -n +2 | uniq -c

				while true
				do
					(lsof -p `pstree -p $1 | grep -o "[0-9]*" | tr '\n' ','` 2>/dev/null) | awk '{print $2}' | tail -n +2 | uniq -c
					echo "-----------"
					sleep 1
				done
			}
			;;

		*"bsd grep"*)
			function numPtreeFiles() {
				echo "does not work yet because OSx grep has shitty regex support!"
				# pstree -p $1 | grep -o "[0-9]*"
				return 1
			}
			;;
		*)
			function numPtreeFiles() {
				echo "unrecognized grep command"
				return 1
			}
			;;
	esac
	unset _GREP_TYPE
fi
