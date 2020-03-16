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

msg=$1
a=$2
b=$3
k=0

result=""
while [ $k -ne ${#1} ]
do
	char=${1:k:1}
	val=$((`ord $char`-65))
	dec=`chr $((($val*$a+$b) % 26 + 65))`
	if [ "$char" == " " ]
	then
		result=$result" "
	else
		result=$result"$dec"
	fi
	k=$(($k+1))
done
printf "$result\n"
