#!/bin/bash
# Original from bashtris/korobeiniki.sh by Copyright (C) 2012 Daniel Suni
# Modified by Copyright (C) 2020 Job Bautista
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Default playback method is ALSA (aplay). If ALSA is not found, the script
# will then find for a /dev/dsp -type OSS device.

declare -r FPS=8000
declare -r VOLUME=$'\xc0' # Max volume = \xff
declare -r MUTE=$'\x80' # Middle of the scale = No volume (\x00 would also be max vol)

# Notes in hertz
declare -r g3=391.9954

declare -r a4=440
declare -r bb4=466.1638
declare -r b4=493.8833
declare -r c4=523.2511
declare -r db4=554.3653
declare -r d4=587.3295
declare -r e4=659.2551
declare -r f4=698.4565
declare -r g4=783.9909

declare -r s=7999 # silence

# Note durations ha = half, qu = quarter, et.c.
declare -r ha=8
declare -r qu=4
declare -r ss=0 # Will be translated to a very short non-zero duration.

function note { # $1 = pitch (Hz) $2 = duration (bytes)
	mute_bytes_num=$(echo "$FPS / $1 - 1" | bc) # bc rounds off the variables
	note_bytes="$VOLUME`yes $MUTE | tr -d '\n' | head -c $mute_bytes_num`" # Create 1 oxxx...-sequence
	yes $note_bytes | tr -d '\n' | head -c $2 # Create as many bytes of concatenated sequences as needed.
}

# Smaller value = faster tempo
declare -r TEMPO=800

function tune { # $1 = List of notes in the format pitch(Hz):duration(note)
	for n in $1 ; do
		pitch=`echo $n | sed 's/:.*//'`
		duration=`echo $n | sed 's/.*://'`
		((duration*=TEMPO))
		if [ $duration -eq 0 ] ; then
			duration=50
		fi
		echo -n "`note $pitch $duration`"
	done
}

mainmelody1="$g3:$qu $s:$ss $g3:$qu $a4:$qu $s:$ss $g3:$qu $s:$ss"
hb1="$c4:$qu $s:$ss $b4:$ha"
hb2="$db4:$qu $s:$ss $c4:$ha"
mainmelody2="$g3:$qu $s:$ss $g3:$qu $g4:$qu $s:$ss $e4:$qu $s:$ss"
hb3="$c4:$qu $s:$ss $b4:$qu $s:$ss $a4:$qu"
end="$f4:$qu $s:$ss $f4:$qu $s:$ss $e4:$qu $s:$ss $c4:$qu $s:$ss $d4:$qu $c4:$ha"

cr_main1=`tune "$mainmelody1"`
cr_main2=`tune "$mainmelody2"`
cr_hb1=`tune "$hb1"`
cr_hb2=`tune "$hb2"`
cr_hb3=`tune "$hb3"`
cr_end=`tune "$end"`

MUSIC="$cr_main1$cr_hb1$cr_main1$cr_hb2$cr_main2$cr_hb3$cr_end"
end2="$cr_main2$cr_hb3$cr_end"

if which aplay &>/dev/null ; then
	( echo -n "$MUSIC$MUSIC$end2" | aplay ) &>/dev/null
elif [ -c /dev/dsp ] ; then
	( echo -n "$MUSIC$MUSIC$end2" > /dev/dsp ) &>/dev/null
elif [ -c /dev/dsp1 ] ; then
	( echo -n "$MUSIC$MUSIC$end2" > /dev/dsp1 ) &>/dev/null
else
	echo "Neither OSS nor ALSA is installed on your system. Exiting."
	sleep 1
	exit 1
fi
