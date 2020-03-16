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

function invMod() {
	r1=$1
	r2=$2

	p1=0
	p2=1
	q1=1
	q2=0
	k=-2

	k=$(($k+1))

	while [ $r2 -ne 0 ]
	do
		k=$(($k+1))
		a=$(($r1/$r2))

		temp=$r2
		r2=$(($r1%$r2))
		r1=$temp

		temp=$p2
		p2=$(($a*$p2+$p1))
		p1=$temp

		temp=$q2
		q2=$(($a*$q2+$q1))
		q1=$temp
	done

	if [ $r1 -eq 1 ]
	then
		res=$(( (-1)^k * $p1))
		while [ $res -lt 0 ]
		do
			res=$(($res+$2))
		done
		printf $res
	else
		return 1
	fi
}

function decrypt() {
	msg=$1
	a=$2
	b=$3
	k=0
	p=26
	inv=`invMod $a $p`

	result=""
	while [ $k -ne ${#1} ]
	do
		char=${1:k:1}
		val=$((`ord $char`-65))
		cal=$(( ($val-$b)*$inv % $p))
		while [ $cal -lt 0 ]
		do
			cal=$(($cal+$p))
		done
		dec=`chr $(($cal+65))`
		if [ "$char" == " " ]
			then
				result=$result" "
		else
			result=$result"$dec"
		fi
		k=$(($k+1))
	done
	printf "$result\n"
}

function encrypt(){
	msg=$1
	a=$2
	b=$3
	k=0
	p=26

	result=""
	while [ $k -ne ${#1} ]
	do
		char=${1:k:1}
		val=$((`ord $char`-65))
		dec=`chr $((($val*$a+$b) % $p + 65))`
		if [ "$char" == " " ]
			then
				result=$result" "
		else
			result=$result"$dec"
		fi
		k=$(($k+1))
	done
	printf "$result\n"
}

function main() {
	read -p "(e)ncrypt or (d)ecrypt? " resp

	read -p "Message (CAPS): " msg
	read -p "A value: " a
	read -p "B value: " b

	if [ "$resp" == "e" ]
	then
		encrypt "$msg" $a $b
	elif [ "$resp" == "d" ]
	then
		decrypt "$msg" $a $b
	fi 
}

main
