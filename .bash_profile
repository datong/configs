PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/home/arus7/bin:/pentest/exploits/msf3:/opt/java/jre/bin:/opt/tools/vmware/bin:/opt/android/tools:$PATH"
export PATH

# Kill flow control
if tty -s ; then
    stty -ixon
    stty -ixoff
fi

export LC_CTYPE=zh_CN.UTF-8
export LESS="-R"
export XMODIFIERS="@im=ibus" 
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=xim

export HISTCONTROL=erasedups:ignorespace
export HISTIGNORE="&:pwd:cd:~:[bf]g:history *:l:l[wsla]:lla:exit:\:q"

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

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s hostcomplete
shopt -s no_empty_cmd_completion
shopt -s nocaseglob

# Export default pkg-config path
PKG_CONFIG_PATH="/usr/lib/pkgconfig"
export PKG_CONFIG_PATH
# export OOO_FORCE_DESKTOP=openbox

# Firefox tweak
export MOZ_DISABLE_PANGO=1

setterm -bfreq 0


. $HOME/.bashrc

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]
then
	. startx
	logout
fi
