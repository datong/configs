# This shell script is run before Openbox launches. 
# Environment variables set here are passed to the Openbox session. 

# Set a background color 
BG="" 
if which hsetroot >/dev/null; then 
BG=hsetroot 
else 
if which esetroot >/dev/null; then 
BG=esetroot 
else 
if which xsetroot >/dev/null; then 
BG=xsetroot 
fi 
fi 
fi 
test -z $BG || $BG -solid "#303030" 

#killall rox > /dev/null 2>&1
#rox -p Default &

#killall pcmanfm > /dev/null 2>&1
#pcmanfm --desktop &

killall feh > /dev/null 2>&1

feh --bg-scale ~/.wallpaper.jpg

killall tint2 > /dev/null 2>&1
tint2 &

killall wicd-client > /dev/null 2>&1
wicd-client &

killall ibus-daemon > /dev/null 2>&1
ibus-daemon -d -x &

killall conky > /dev/null 2>&1
sleep 2; conky &

#if which xcompmgr > /dev/null; then
#(sleep 8 && xcompmgr -Ss -n -Cc -fF -I-10 -O-10 -D1 -t-3 -l-4 -r4) &
#fi

#去掉电源管理&屏幕保护
sleep 3 
xset s 0
xset b 0
xset -dpms
xset b off
