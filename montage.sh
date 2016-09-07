#!/bin/bash

IFS='
'

if [ $# -ne 1 ]
then
PWD=$( pwd )
else
PWD="$1"
fi

for MOVIE in $( find .  -type f \( -iname '*.mp4' -or -iname '*.avi' -or -iname '*.wmv' -or -iname '*.flv' \) | sort )
do
  echo "MOVIE: $MOVIE"
  DIRNAME=$( dirname $MOVIE )
  BASENAME=$( basename $MOVIE )
  TN_NAME="$DIRNAME/"$BASENAME"-thumbs.jpg"
  if [ -e "$TN_NAME" ]
    then
    echo "Mar letezik: $TN_NAME"
    else
    TMP_DIR=$( mktemp -d TN_XXXXXXXXXXX )

    i=0
    while [ $i -lt 95 ] ;
    do
      PAD=$(printf "%03d" $i)
      TN_FILENAME="$TMP_DIR/$PAD.jpg"
#      echo /usr/bin/ffmpegthumbnailer -i "$MOVIE" -o $TN_FILENAME -t "$i%" -s 256
      /usr/bin/ffmpegthumbnailer -i "$MOVIE" -o $TN_FILENAME -t "$i%" -s 256
      i=$(( i + 1 ))
    done
    echo $TN_NAME
    /usr/bin/montage -mode concatenate -tile 4x $TMP_DIR/* "$TN_NAME"

    rm -rf $TMP_DIR

  fi

  echo
done
