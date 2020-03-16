#!/bin/bash

# This gets the character for a corresponding ASCII value
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

# This gets the ASCII value of a character
ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


for i in {1..26}
do
  result="<$i> "
	k=0
	while [ $k -ne ${#1} ]
	do
		char=${1:k:1}
		val=`ord $char`
		dec=`chr $((($val+$i-65) % 26 + 65))`
		if [ "$char" == " " ]
		then
			result=$result" "
		else
			result=$result"$dec"
		fi
		k=$(($k+1))
	done
	printf "$result\n"
done
