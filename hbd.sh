#!/bin/bash
# Copyright (C) 2020 Job Bautista
# Licensed under the Eiffel Forum License 2.
# See the EFL-2.0 file for the full license text.

./hbdmusic.sh &

NAME=$1
AGE=$2
function hb {
	printf "Hap"
	sleep 0.5
	printf "py "
	sleep 0.25
	printf "birth"
	sleep 0.25
	printf "day "
	sleep 0.25
}

sleep 0.5
hb
printf "to "
sleep 0.5
printf "you!""\n"
sleep 1

hb
sleep 0.5
printf "$NAME!""\n"
sleep 1

hb
printf "\n"
hb
printf "\n""Ha"
sleep 0.5
printf "p"
sleep 0.5
printf "py "
sleep 0.25
printf "birth"
sleep 0.25
printf "day "
sleep 0.25
printf "to "
sleep 0.5
printf "you!""\n\n"
sleep 1

echo "Happy $AGE birthday $NAME!"
echo "Written by Job Bautista"
