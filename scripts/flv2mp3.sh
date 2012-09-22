#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $0 list_of_flv_files"
  exit 1
fi

mplayer -ao pcm  -vc dummy  -vo  null "$1"
lame -h audiodump.wav -b 32 "$1"".mp3"  --tt "$title" --ta "$author"
rm -f audiodump.wav
