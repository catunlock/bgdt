#!/bin/bash
#title           :make_spritesheet.sh
#description     :This script will make a spritesheet texture from a set of images
#author		 :catunlock
#license	 :GPLv3
#date            :20170809
#usage		 :bash make_spritesheet.sh <Animation name>
#notes           :Install ImageMagick to use this script.
#bash_version    :4.3.48(1)-release
#==============================================================================

if [ "$#" -ne 2 ]; then
	echo "Illegal number of parameters\n"
	echo "Usage: ./make_spritesheet.sh <Animation name>"
	exit
fi

ANIMATION=$1

echo "Animation $ANIMATION"
COUNT=$(ls -l $ANIMATION* | wc -l)

MAX_WIDTH=0
MAX_HEIGHT=0
for i in $(ls $ANIMATION*)
do
	#SIZE=$(file $i)
	SIZE=$(file $i | tr ":" "\n" | tr "," "\n" | sed '3q;d')
	WIDTH=$(echo $SIZE | tr "x" "\n" | sed '1q;d')
	HEIGHT=$(echo $SIZE | tr "x" "\n" | sed '2q;d')

	if [ "$WIDTH" -gt "$MAX_WIDTH" ]; then
		MAX_WIDTH=$WIDTH
		echo "new $MAX_WIDTH"
	fi

	if [ "$HEIGHT" -gt "$MAX_HEIGHT" ]; then
		MAX_HEIGHT=$HEIGHT
		echo "new $MAX_HEIGHT"
	fi
done

## Delete whitespaces
MAX_WIDTH=$(echo $MAX_WIDTH | tr -d '[:space:]')
MAX_HEIGHT=$(echo $MAX_HEIGHT | tr -d '[:space:]')

RES=$(echo $(echo $MAX_WIDTH)x$MAX_HEIGHT)
echo "Resolucion para cada imagen: $RES"

TEMPDIR=$(mktemp -d)

for i in $(ls $ANIMATION*)
do
	convert $i -gravity center -background transparent -extent $RES $TEMPDIR/$i._fixed.png
done

GRID=$(echo $(echo $COUNT)x1)
montage $TEMPDIR/* -tile $GRID -background transparent -geometry +0+0 spritesheet_$ANIMATION.$RES.png



