#Indelible Bonobo's ~/.bash_aliases, some from
#http://ubuntuforums.org/showthread.php?t=1374947
#don't forget sux; useradd native, adduser perl
alias reload='source $HOME/.bashrc'

#fc-list lists all fonts; .ttf in /usr/share/fonts
alias fontgrep='fc-list | grep'
alias fontsread='fc-cache -fv'
alias ports='netstat -tulanp'
alias wget='wget -c'

#apt tool with sudo
alias apt-install='sudo apt-get install'
alias apt-search='apt-cache search'
alias apt-show='apt-cache show'
alias apt-purge='sudo apt-get --purge  remove'
alias apt-remove='sudo apt-get remove'
alias aptkey='sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys'

#more apt and dpkg shortcuts
alias upd8='apt-get update && apt-get dist-upgrade && apt-get autoremove && apt-get clean'
alias acm='apt-cache madison'
alias acp='apt-cache policy'
alias acs='apt-cache search'
alias aarc='auto-apt run ./configure'
alias dpkgrep='dpkg -l | grep -i'
alias dqp='dpkg-query -p'
alias dql='dpkg-query -L'
alias dqw='dpkg-query -W'
alias dqs='dpkg-query -S'
alias listfiles='dpkg-query -L'
alias findsource='dpkg-query -S'

#List including hidden files with indicator and color
alias ll='ls -al'
alias ls='ls -aF --color=always'

# Keep 1000 lines in .bash_history (default is 500)
export HISTSIZE=1000
export HISTFILESIZE=1000

# Change bash prompt
export PS1='\d \@ \[\e[32;1m\]\u\[\e[34;1m\]@\[\e[36;1m\]\H \[\e[34;1m\]\w\[\e[32;1m\] $ \[\e[0m\]'

#temperatures - install acpi first
alias temps='acpi -t'
alias astats='acpi -V'

## pass options to free ## 
alias meminfo='free -m -l -t'

#open last modified file in vim
alias Vim="vim `ls -t | head -1`"

#filesystem diskspace usage
alias dus='df -h'

#navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
alias cpuinfold='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## set some other defaults ##
alias df='df -H'
alias du='du -ch'

# Monitor logs
# alias syslog='sudo tail -100f /var/log/syslog'
# alias messages='sudo tail -100f /var/log/messages'

# List paths
alias echopath='echo -e ${PATH//:/\\n}'

# allows editing the path with each directory on a new line
nanopathd ()  
{  
    declare TFILE=/tmp/path.$LOGNAME.$$; 
    echo $PATH | sed 's/^:/.:/;s/:$/:./' | sed 's/::/:.:/g' | tr ':' '\012' > $TFILE; 
    nano $TFILE; 
    PATH=`awk ' { if (NR>1) printf ":" 
      printf "%s",$1 }' $TFILE`; 
    rm -f $TFILE; 
    echo $PATH 
}  
alias pathedit='nanopathd'

# perform 'ls' after 'cd' if successful.
cdls() {
  builtin cd "$*"
  RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    ls -al
  fi
}

# explode archive
ex () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "'$1': unrecognized file compression" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

# mount and unmount ISOs
miso () {
    [[ ! -f "$1" ]] && { echo "Provide a valid iso file"; return 1; }
    mountpoint="/media/${1//.iso}"
    sudo mkdir -p "$mountpoint"
    sudo mount -o loop "$1" "$mountpoint"

}
umiso () {
    mountpoint="/media/${1//.iso}"
    [[ ! -d "$mountpoint" ]] && { echo "Not a valid mount point"; return 1; }
    sudo umount "$mountpoint"
    sudo rm -ir "$mountpoint"

}

#mount NAS by changing private IP; install cifsutils + create .cred in root with username= password= and optionally domain= then chmod 600
mntnas () {
	umount /mnt/v1 && umount /mnt/v2
	mount -t cifs //192.168."$1"/Volume_1-1 /mnt/v1 -o user,uid=65001,rw,credentials=/root/.cred
	mount -t cifs //192.168."$1"/Volume_2-1 /mnt/v2 -o user,uid=65001,rw,credentials=/root/.cred
}

#https://lists.ubuntu.com/archives/lubuntu-users/2012-March/000678.html
alias oldkernels='dpkg -l linux-{headers,image}-[23]\* |grep ^ii |grep -v $(uname -r |sed -e "s/-generic//") |cut -c 5-40'
alias remove-oldkernels='sudo apt-get remove $(dpkg -l linux-{headers,image}-[23]\* |grep ^ii |grep -v $(uname -r |sed -e "s/-generic//") |cut -c 5-40)'
function remove-oldkernels-except () { sudo apt-get remove $(dpkg -l linux-{headers,image}-[23]\* |grep ^ii |grep -v $(uname -r |sed -e "s/-generic//") |cut -c 5-40 | grep -v $1) ; }
# This one is for folks who want to retain more than just the most recent
# kernel.  It takes a single argument which is a regex and packages
# matching the regex you supply are retained, as well as the most recent
# kernel.  So you can do remove-oldkernels-except 2.6.32-35
# and it will remove all kernel packages except that one *and* the
# currently running kernel.
#see also: http://markmcb.com/2013/02/04/cleanup-unused-linux-kernels-in-ubuntu/
#from alias.sh
cleankernels() {
    dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get purge
}

#to connect via wpasupplicant with credentials in root
wpawlan1() {
	wpa_supplicant -B -iwlan1 -c/root/.wpasupyo -Dwext && dhclient wlan1
}
wpaweth1() {
	wpa_supplicant -B -ieth1 -c/root/.wpasupyo -Dwext && dhclient eth1
}

# pings
alias ping1='ping -c 4 www.google.com'
alias ping0='ping -c 4 192.168.0.1'
alias ping2='ping -c 4 toronto.ezvoip.co'
alias ping3='ping -c 4 toronto2.ezvoip.co'
alias ping4='pinc -c 4 default.ezvoip.co'

#find file
alias f='find . |grep '

#search history
alias h='history|grep '

#search processes
alias p='ps aux |grep '

#open any file or folder with default app
alias o='xdg-open '

#python calculator
alias pc='python -i -Qnew -c "from math import *"'

#python calculator (plus numpy and matplotlib)
alias pcn='python -i -Qnew -c "from math import *;from pylab import *"'

#myip | grep 'inet addr:'
alias whatsmyip='/sbin/ifconfig -a | grep inet'
alias myipaddr='hostname -I'
alias ipuri='ip addr show'

#to recursively unzip all zip archive in the current directory and its subdirectories
alias recunzip='find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; done;'
