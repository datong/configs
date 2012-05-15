PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/home/d/bin:/pentest/exploits/msf3:/opt/jdk1.6/bin:/opt/android/tools:/opt/tools/webserver/php/bin:/opt/nessus/bin:/opt/nessus/sbin:/opt/tools/webserver/mysql/bin:$PATH"
export PATH

# Kill flow control
if tty -s ; then
    stty -ixon
    stty -ixoff
fi

test -r .dir_colors && eval "export $(dircolors -b .dir_colors)"

#export LANG=c
export LC_CTYPE=zh_CN.UTF-8
export LESS="-R"
export XMODIFIERS="@im=ibus" 
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=xim

export BROWSER="chromium"
export EDITOR="vim"
export PAGER="less"

export MOST_SWITCHES="-s"
export MOST_EDITOR="$EDITOR"
export SLANG_EDITOR="$EDITOR"

export LESS="-FXRS"
export LESSHISTFILE="/tmp/.lesshst"
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;46;37m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

export MPD_HOST=127.0.0.1
export MPD_PORT=6600

#shopt -s cdspell
#shopt -s checkwinsize
#shopt -s cmdhist
#shopt -s dirspell
#shopt -s histappend
#shopt -s hostcomplete
#shopt -s no_empty_cmd_completion
#shopt -s nocaseglob

# Export default pkg-config path
PKG_CONFIG_PATH="/usr/lib/pkgconfig"
export PKG_CONFIG_PATH
# export OOO_FORCE_DESKTOP=openbox

# Firefox tweak
export MOZ_DISABLE_PANGO=1

setterm -bfreq 0


# Make framebuffer colors look like in X
#if [ "$TERM" = "linux" ]; then
#    echo -en "\e]P0222222" #black
#    echo -en "\e]P8222222" #darkgrey
#    echo -en "\e]P1803232" #darkred
#    echo -en "\e]P9982b2b" #red
#    echo -en "\e]P25b762f" #darkgreen
#    echo -en "\e]PA89b83f" #green
#    echo -en "\e]P3aa9943" #brown
#    echo -en "\e]PBefef60" #yellow
#    echo -en "\e]P4324c80" #darkblue
#    echo -en "\e]PC2b4f98" #blue
#    echo -en "\e]P5706c9a" #darkmagenta
#    echo -en "\e]PD826ab1" #magenta
#    echo -en "\e]P692b19e" #darkcyan
#    echo -en "\e]PEa1cdcd" #cyan
#    echo -en "\e]P7ffffff" #lightgrey
#    echo -en "\e]PFdedede" #white
#    clear #for background artifacting
#fi

#export GREP_COLOR='00;38;5;226'
export GREP_COLORS='mt=38;5;0;48;5;190:fn=38;5;104:ln=38;5;214:se=38;5;242:bn=38;5;226'


#Java:
export JAVA_HOME=/opt/jdk1.6
export JRE_HOME=/opt/jdk1.6/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH

export MAVEN_HOME=/opt/maven
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$MAVEN_HOME/bin:/opt/android/sdk/tools:$PATH

