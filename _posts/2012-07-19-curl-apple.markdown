Date: 19 Jul 2012
Categories: development
Summary: With *curl* and *grep" I can send an email with the offer.
Read more: Show me more

# Sent an email when the iMac is at a specified price

The other day a friend asked me to let him know if I saw a special offer of iMac. I don't wanna be watching every little time so I made a script.

	#!/bin/bash

	FILE=/root/no_mess
	URL="http://store.apple.com/es/browse/home/specialdeals/mac/imac/27"
	PRICE="1.395"
	
	if [ ! -f $FILE ]
	then
	
		LINE=`curl -s $URL | grep "${PRICE}"`
		
		if [ -n "${LINE}" ]
		then
			echo "Go to $URL" | mail -s "Ok let's go" my.personal@email.com > $FILE
		fi
	
	fi

All that remains is to incorporate to the Cron.