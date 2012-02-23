#!/bin/bash
# Screencast script.
# Copyright (c) Michal Witkowski 2009
# License: GPL 3
# ver 0.1

OUTPUT=""
WINID=""
FPS=15
WIDTH=0
HEIGHT=0
SIZE_X=0
SIZE_Y=0
PRESET='lossless_slow'
CODEC='x264'


usage()
{
cat << EOF
usage: $0 options -o output_file

Captures screen using FFMpeg and encodes it to the given codec.

OPTIONS:
   -h      Show this message
   -o      Output file. Container can be mp4, mkv or avi. 
   -p      Encode preset to use. (def: 'lossless_slow', see /usr/share/ffmpeg/)
   -c      Codec to use (def: 'x264', ['x264']) 
   -i      Window ID to capture (see xwininfo)
   -r      Frame Rate (FPS) (def: 15)
   -f      Capture full screen
EOF
}

while getopts “hfp:c:r:o:i” OPTION
do
    case $OPTION in
    h)
        usage
        exit 1 ;;
    f)
        WINID="root" ;;
    p)
        PRESET=$OPTARG ;;
    c) 
        CODEC=$OPTARG ;;
    i)  
        WINID=$OPTARG ;;
    r)  
        FPS=$OPTARG ;;
    o)  
        OUTPUT=$OPTARG ;;
    ?)
        usage
        exit 1 ;;
     esac
done

if [[ -z $OUTPUT ]] ; then
    echo "Output file required" >&2
    usage
    exit 1
fi

function capture_window() {
    if [[ "$WINID" == "" ]]; then
        echo "(???) Please select window to capture. After that press 'q' to finish capture"
        wininfo=`LANG="" xwininfo | tr '\n' ' '`
    elif [[ "$WINID" == "root" ]]; then
        echo "(!!!) Will capture whole screen. This will be incredibly slow!"
        wininfo=`LANG="" xwininfo -root | tr '\n' ' '`
    else
        wininfo=`LANG="" xwininfo -id $WINID | tr '\n' ' '`
        
    fi
    regex='Width: *([0-9]+).*Height: *([0-9]+).*Corners: *\+([0-9]+)\+([0-9]+)'
    if [[ "$wininfo" =~ $regex ]]
    then
        WIDTH=${BASH_REMATCH[1]}
        HEIGHT=${BASH_REMATCH[2]}
        POS_X=${BASH_REMATCH[3]}
        POS_Y=${BASH_REMATCH[4]}
    else
        echo "xwininfo returned wrong Data: "
        echo $wininfo
        echo "Exiting."
        exit 1
    fi
    SIZE_X=$(( $WIDTH / 16 * 16))
    SIZE_Y=$(( $HEIGHT / 16 * 16))
    if [[ "$SIZE_X" != "$WIDTH" ]]; then
        echo "(!!!) Width $WIDTH is not a multiple of 16. Truncated to $SIZE_X";
    fi;
    if [[ "$SIZE_Y" != "$HEIGHT" ]]; then
        echo "(!!!) Height $HEIGHT is not a multiple of 16. Truncated to $SIZE_Y";
    fi;
    echo "(***) Final capture dimensions: "
    echo "      POS_X=$POS_X POS_Y=$POS_Y"
    echo "      SIZE_X=$SIZE_X  SIZE_Y=$SIZE_Y"
}

# Capture the window
capture_window

# Windows x264 VMF settings for lossless
#LIBx264='-cfr 0.0 
#    -flags2 +dct8x8 
#    -partitions +parti4x4+parti8x8-partp4x4+partp8x8+partb8x8 
#    -refs 1 
#    -me_method umh
#    -g 250
#    -subq 7
#    -sc_threshold 40
#    -bf 0
#    -coder 1
#'
LIBx264="-vpre main -vpre $PRESET -crf 0"

ffmpeg -r $FPS -v 1  \
    -s ${SIZE_X}x${SIZE_Y} -an \
    -f x11grab -i :0.0+${POS_X},${POS_Y} -vcodec libx264 ${LIBx264} \
    -threads 0 ${OUTPUT} 

#ffmpeg -r 15  \
#    -s ${SIZE_X}x${SIZE_Y} -an \
#    -f x11grab -i :0.0+${POS_X},${POS_Y} -vcodec -vcodec flashsv \
#     ${OUTPUT}
