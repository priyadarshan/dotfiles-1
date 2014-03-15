# Scott's .zshrc
export CLOJURESCRIPT_HOME=~/src/clojurescript
path=(. ~/src/selecta ~/opt/emacs-24.3/src ~/src/fasd $CLOJURESCRIPT_HOME/bin /usr/local/share/perl/5.18.1/auto/share/dist/Cope ~/src/cljs-watch ~/src/git-notify ~/src/youtube-dl  $path /bin /usr/bin /usr/local/bin /usr/X11R6/bin ~/bin ~/.npm/coffee-script/1.4.0/package/bin ~/.cabal/bin /usr/local/go/bin)

INFOPATH=( ~/doc/info )
export INFOPATH
# menu
zstyle ':completion:*' menu select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

autoload -U compinit
compinit

# bc otherwise I get errors on computers that don't have notify-send
function notify { if [[ -x "/usr/bin/notify-send" ]]; then; notify-send $@; fi }

## Hosts
alias ssrn='sudo shutdown -r now'
alias ssn='sudo shutdown now'

# short for say done
alias sd='notify -t 2000 -i alert "Done"'
alias alsamixer='alsamixer -g'
alias o='gnome-open'
alias ka='killall'
alias tree='tree -C'
alias df='df -h'

# Aliases
alias create-tags='/usr/bin/ctags -e -R *'
alias cm="./configure && make"
function mayberun() {if test -f $1; then $1; fi }
alias bui="mayberun ./autogen.sh && mayberun ./configure && make; notify -t 3000 'build done'"
alias smi='sudo make install && notify -t 3000 -i info "sudo make intall" "Done"'

## Lein
alias len='notify -t 2000 -i leiningen "Leiningen"'
alias lei='lein install; len "install done"'
alias lej='lein jar; len "jar done"'
alias leu='lein uberjar; len "uberjar done"'
alias lec='lein clean; len "clean done"'
alias led='lein deps; len "dep done"'
alias les='len "swank starting"; lein swank'
alias les2='len "swank starting"; lein swank-clj'

## Maven
# alias mvni='mvn clean install -Dmaven.test.skip=true'
# alias mvnt='mvn test -Dtest='

## Git
alias g='git'
function gcl { git clone $@ && notify -t 3000 -i git "Git clone completed" "$1" }
alias gl='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias gst='git status'
alias gba='git branch -all'
alias gp='git pull'
# alias gl='git log'
# alias go='git co'
alias cx='chmod +x'
alias rmr="mv -t ~/.local/share/Trash/files"
alias rmrf='rm -rf'
alias dus='du -cBM --max-depth=1 | sort -n'
alias dum='du -cBM --max-depth=1'
alias duh='du -h'
alias ll='ls -lh'
alias ls='ls --color=always -F -h'
alias c='clear'
alias ps='ps aux'
alias k9='kill -9'
alias psg='ps G'
alias s='screen'
alias sv='sudo vim'
alias em='emacs -nw -q'
alias sem='sudo emacs -nw -q'
alias smg='sudo mg'
alias f='find ./ 2> /dev/null'
alias fig-names='find | grep'
alias fig-contents='grep -ir'
alias grep='grep --color=always -i'
alias more='less'
alias recent='ls -rl *(D.om[1,10])'
alias irc2="irssi -c irc.freenode.net -n scottj"
alias mp="mpl -speed 1.6 "
alias myspace="dlmsm"

function w { wget -c $@ && notify -i info "Wget download completed" "$"}
function a { aria2c -x 10 -s 10 --min-split-size=1M -c $@ && notify -i info "aria2c download completed" "$"}
alias mkdir='mkdir -p'
alias mk='mkdir'
function cdm {mkdir -p "$1" ; cd "$1"}
alias mkc=cdm
function mvp { mkdir -p "$@[-1]"; mv "$@"; }
## Apt-get
#alias sea='apt-cache search'
sea() { apt-cache search $1 | grep -C 500 $1;}
alias sea2='sea --names-only'
seap() { apt-file search $1 | grep -C 500 $1; }
function aptn { notify --app-name=apt -t 2000 -i debian "Apt-get" $@}
function ins {sudo apt-get install -y $* &&  aptn "Installed $@"}
compdef "_deb_packages uninstalled" ins
function rem {sudo apt-get remove -y $* && aptn "Removed $@"}
compdef "_deb_packages installed" rem
alias upd='sudo apt-get update'
alias upg='sudo apt-get upgrade'
alias updg='upd; upg; aptn "update/upgrade done"'
alias arem='sudo apt-get autoremove -y'
alias arep='sudo add-apt-repository'

## Windows apt-cyg
if [[ $(uname -o) == Cygwin ]] {
        alias open=cygstart
        alias sa='eval `ssh-agent`; ssh-add'
        alias s='screen -s zsh-is-loading'
        alias sea='apt-cyg find'
        alias ins='apt-cyg install'
        alias rem='apt-cyg remove'
        alias upd='apt-cyg update'
        alias lein='lein.bat'
}

## Mac ports
if [[ $(uname) == Darwin ]] {
        alias ls="ls -G -F -h"
        alias ins="sudo port install"
        alias upd="sudo port -d selfupdate"
        alias sea="port search"
        alias rem="sudo port uninstall"
}

# Global Aliases
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'
alias -g L='|less -R'
alias -g M='|more'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g W='|wc -l'
alias -g S='|sort'

# environment settings
export EDITOR=ec
export BROWSER=conkeror
export PAGER=less
export RSYNC_RSH=/usr/bin/ssh
export COLORTERM=yes
# for bug w/ buttons in eclipse not clicking when compiz is running
# export GDK_NATIVE_WINDOWS=true
# export WORDCHARS='*?[]~=&;!#$%^(){}'
export WORDCHARS='*?[]~!#$%^(){}'
# cdpath=(~)
bindkey -e

# # See if we can use colors.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done

### Prompt $(print '%{\e[1;31m%}')
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


zle_highlight+=(special:fg=blue
    region:bg=blue,fg=white,bold
    default:bold # ,fg=yellow
    isearch:fg=magenta)

# no color
# export PS1="
# %n@%m:%~:%# "

# export PS1="
# > "

export PS1="

%{$fg_bold[black]%}>%{$reset_color%} "

# with color
# export PS1="
# %{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[green]%}%m%{$reset_color%}:%{$fg_bold[yellow]%}%~%{$reset_color%}:%# "

# export PS1="
# %{$fg_bold[yellow]$bg_bold[red]%}%n@%m%{$reset_color%}:%~%# "

# export PS1="
# %B%~%(?..[%?])%(#.#.) %b"

# %# is % or #
# %m is hostname

# export PS1="
# %B%# %b"
# export PS2='%B%_%(#.#.)%b_'
# export RPS1='%B%~%b '


# Completion, color
zstyle ':completion:*' completer _complete
ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors no=00 fi=00 di=01\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32

### Enable advanced completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

### General completion technique
#zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# kill menu extension!
zstyle ':completion:*:processes' command 'ps --forest -U $(whoami) | sed "/ps/d"'
#zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes' insert-ids menu yes select

# remove uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
   adm alias apache at bin cron cyrus daemon ftp games gdm guest \
   haldaemon halt mail man messagebus mysql named news nobody nut \
   lp operator portage postfix postgres postmaster qmaild qmaill \
   qmailp qmailq qmailr qmails shutdown smmsp squid sshd sync \
   uucp vpopmail xfs

# case insensitivity, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

# Common hostnames
if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
else
  # Older versions don't like the above cruft
  _etc_hosts=()
fi

zstyle ':completion:*' hosts $hosts
zstyle ':completion:*:my-accounts' users-hosts $my_accounts
zstyle ':completion:*:other-accounts' users-hosts $other_accounts

#Zsh options
setopt no_beep \
    share_history \
    append_history \
    inc_append_history \
    hist_ignore_space \
    hist_ignore_dups \
    hist_reduce_blanks \
    hist_verify \
    interactive_comments \
    auto_cd \
    complete_aliases \
    auto_list \
    complete_in_word \
    auto_pushd \
    # extended_glob \ # so I don't have to escape ^ in HEAD^
zle


HISTFILE=~/.zsh/history
HISTSIZE=50000
SAVEHIST=50000

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

notifyerr(){
    last_exit_code="$?";
    if [ "$last_exit_code" -ne 0 -a "$last_exit_code" -ne 130 ]; then
        command="$PREEXEC_CMD";
        if [ "$command" != "htop" ]; then
            notify -i error -a zsh-error "${PREEXEC_CMD:-Shell Command}" "error $last_exit_code";
            return -1;
        fi
    fi
}

precmd () {
    # must be first
    notifyerr
    # LASTCMD=$history[$((HISTCMD-1))]

    # BEGIN notify long running cmds
    stop=$(date +'%s')
        start=${PREEXEC_TIME:-$stop}
        let elapsed=$stop-$start
        max=${PREEXEC_MAX:-10}

        for i in ${PREEXEC_EXCLUDE_LIST:-}; do
            if [ "x$i" = "x$PREEXEC_CMD" ]; then
                max=999999;
                break;
            fi
        done

    if [ "${PREEXEC_CMD:-Shell Command}" != "s" ]; then
            if [ "$elapsed" -gt $max -a "$?" -ne 130 ]; then
            if [ $PREEXEC_CMD ]; then
                        notify -t 2000 -i warning -u low "${PREEXEC_CMD:-Shell Command}" "finished ($elapsed secs)"
            fi
            fi
    fi
    # END notify long running cmds
    if [[ $HOST == "iandi" ]]; then
        vcs_info
    fi
        my_pwd=$(print -P "%~")
        if [[ "$TERM" == "screen" ]]; then
            if [ "$TMUX" ]; then # tmux doesn't have built-in truncating
                my_pwd=${my_pwd:0:15}
            fi
                echo -ne "\ekzsh $my_pwd\e\\"
        fi
    # why always show hostname on local box?
    # if [ -n "$SSH_TTY" ] || [ "$(who am i | cut -f2  -d\( | cut -f1 -d:)" != "" ]; then
    if [ -n "$SSH_TTY" ]; then
        MAYBE_HOSTNAME="%m"
    fi
#         code=$(print -P "%?")
    # export RPS1="%t %{$fg_bold[yellow]%}$(parse_git_branch)%{$reset_color%} %{$fg_bold[red]%}%(?..[%?])%(#.#.)%{$reset_color%}%{$fg_bold[grey]%}"
    # export RPS1="${vcs_info_msg_0_} $(parse_git_branch) %(?..[%?])%(#.#.)"
    # export RPS1="${vcs_info_msg_0_} %(?..[%?])%(#.#.)"
    # export RPS1="%~ $MAYBE_HOSTNAME %(?..[%?])%(#.#.)"
    export RPS1="%{$fg_bold[black]%}%~ $MAYBE_HOSTNAME ${vcs_info_msg_0_} %{$fg[red]%}%(?..[%?])%{$reset_color%}" # %(#.#.)
    #         if [[ $code != "0" ]]; then
#             echo ok
#             export RPS1="$(parse_git_branch) %?"
#         fi

}

preexec () {

    # Screen title names
        if [[ "$TERM" == "screen" ]]; then
            # local CMD=${1}
            # echo -ne "\ek$CMD\e\\"

            local a=${${1## *}[(w)1]}  # get the command
            local b=${a##*\/}   # get the command basename
            a="${b}${1#$a}"     # add back the parameters
            a=${a//\%/\%\%}     # escape print specials
            a=$(print -Pn "$a" | tr -d "\t\n\v\f\r")  # remove fancy whitespace
            a=${(V)a//\%/\%\%}  # escape non-visibles and print specials
            if [ "$TMUX" ]; then # tmux doesn't have built-in truncating
                a=${a:0:15} # truncate
            fi

            echo -ne "\ek$a\e\\"
        fi
    # for notifying of long running commands
        export PREEXEC_CMD=`echo $1 | awk '{ print $1; }'`
        export PREEXEC_TIME=$(date +'%s')
}


# let alt backspace delete to separators. Use C-w to delete entire word regardless of separators
# backward-delete-to-slash () {
#     local WORDCHARS=${WORDCHARS//[&=-\/;.-!#%]}
#     zle .backward-delete-word
# }
# zle -N backward-delete-to-slash
bindkey "\e$terminfo[kbs]" backward-delete-word

# Print out current calendar with highlighted day
# calendar() {
#    if [[ ! -f /usr/bin/cal ]] ; then
#       echo "Please install cal before trying to use it!"
#       return
#    fi
#    if [[ "$#" = "0" ]] ; then
#       /usr/bin/cal | egrep -C 40 --color "\<$(date +%e| tr -d ' ')\>"
#    else
#       /usr/bin/cal $@ | egrep -C 40 --color "\<($(date +%B)|$(date +%e | tr -d ' '))\>"
#    fi
# }

# alias cal=calendar

# Remove useless files
clean () {
    if [ "$1" = "-r" ]; then
        find . \( -name '#*' -o -name '*~' -o -name '.*~' -o -name 'core*' \
                      -o -name 'dead*' \) -ok rm '{}' ';'
    else
        rm -i \#* *~ .*~ core* dead*
    fi
}

# Extract most types of archive
extract() {
   if [[ -z "$1" ]]; then
      print -P "usage: \e[1;36mextract\e[1;0m < filename >"
      print -P "       Extract the file specified based on the extension"
   elif [[ -f $1 ]]; then
      case ${(L)1} in
          *.tar.bz2)  tar -jxvf $1;;
          *.tar.gz)   tar -zxvf $1;;
          *.bz2)      bunzip2 $1   ;;
          *.gz)       gunzip $1   ;;
          *.jar)      unzip $1       ;;
          *.rar)      unrar x $1   ;;
          *.tar)      tar -xvf $1   ;;
          *.tbz2)     tar -jxvf $1;;
          *.tgz)      tar -zxvf $1;;
          *.zip)      unzip $1      ;;
          *.Z)        uncompress $1;;
         *)          echo "Unable to extract '$1' :: Unknown extension"
      esac
   else
      echo "File ('$1') does not exist!"
   fi
}

compctl -g '*.tar.bz2 *.tar.gz *.bz2 *.gz *.jar *.rar *.tar *.tbz2 *.tgz *.zip *.Z' + -g '*(-/)' extract

# Create a diff
mdiff() { diff -udrP "$1" "$2" > diff.$(date "+%Y-%m-%d")."$1" }

# Reset current directory to sensible permissions
saneperms() {
    find . -type d -print0 | xargs -0 chmod 755
    find . -type f -print0 | xargs -0 chmod 644
}

function cs()
{
    cd $1;
    ls --color=auto -F -h
}
#alias cd='cs'

# scp-pull username@host.com tmp
function scp-pull()
{
  ssh $1 "tar czf - $2" | tar xzvf - -C ./
}
# summarized google, ggogle, mggogle, agoogle and fm
function search()
{
    case "$1" in
        -g) ${BROWSER:-lynx} http://www.google.com/search\?q=$2
            ;;
        -u) ${BROWSER:-lynx} http://groups.google.com/groups\?q=$2
            ;;
        -m) ${BROWSER:-lynx} http://groups.google.com/groups\?selm=$2
            ;;
        -a) ${BROWSER:-lynx} http://groups.google.com/groups\?as_uauthors=$2
            ;;
        -c) ${BROWSER:-lynx} http://search.cpan.org/search\?query=$2\&mode=module
            ;;
        -f) ${BROWSER:-lynx} http://freshmeat.net/search/\?q=$2\&section=projects
            ;;
        -F) ${BROWSER:-lynx} http://www.filewatcher.com/\?q=$2
            ;;
        -G) ${BROWSER:-lynx} http://www.rommel.stw.uni-erlangen.de/~fejf/cgi-bin/pfs-web.pl\?filter-search_file=$2
            ;;
        -s) ${BROWSER:-lynx} http://sourceforge.net/search/\?type=soft\&q=$2
            ;;
        -w) ${BROWSER:-lynx} http://de.wikipedia.org/wiki/$2
            ;;
        -W) ${BROWSER:-lynx} http://en.wikipedia.org/wiki/$2
            ;;
        -d) lynx -source "http://dict.leo.org?$2" | grep -i "TABLE.*/TABLE" | sed "s/^.*\(<TABLE.*TABLE>\).*$/<HTML><BODY>\1<\/BODY><\/HTML>/" | lynx -stdin -dump -width=$COLUMNS -nolist;
;;
*)
            echo "Usage: $0 {-g | -u | -m | -a | -f | -c | -F | -s | -w | -W | -d}"
            echo "-g:  Searching for keyword in google.com"
            echo "-u:  Searching for keyword in groups.google.com"
            echo "-m:  Searching for message-id in groups.google.com"
            echo "-a:  Searching for Authors in groups.google.com"
            echo "-c:  Searching for Modules on cpan.org."
            echo "-f:  Searching for projects on Freshmeat."
            echo "-F:  Searching for packages on FileWatcher."
            echo "-G:  Gentoo file search."
            echo "-s:  Searching for software on Sourceforge."
            echo "-w:  Searching for keyword at wikipedia (german)."
            echo "-W:  Searching for keyword at wikipedia (english)."
            echo "-d:  Query dict.leo.org ;)"
            esac
}

# for i in `seq 0 400`; do wget -r -H --level=1 -k -p -erobots=off -np -N http://foo.com/$i/bar; done

# rm() { mv "$@" ~/.recycle/ }

bindkey -s "^x^f" $'ec '

function lsx() { [[ -z $BUFFER ]] && BUFFER='ls' ; zle accept-line } ; zle -N lsx ; bindkey '^M' lsx
function cdx() { [[ -z $BUFFER ]] && BUFFER='cd' ; zle accept-line } ; zle -N cdx ; bindkey '^[\\' cdx

# alt-ret runs last command
function runprev() { zle up-line-or-history ; zle accept-line } ; zle -N runprev ; bindkey '^[^M' runprev

#function myal-updir() { if [[ -z $BUFFER ]] ; then BUFFER='..' ; zle accept-line ; else zle backward-delete-char ; fi } ; zle -N myal-updir ; bindkey '^?' myal-updir
#function myal-home() { if [[ -z $BUFFER ]] ; then BUFFER='~' ; zle accept-line ; else zle backward-kill-word ; fi } ; zle -N myal-home ; bindkey '^J' myal-home

function 700s() {for i in pic*; do convert -quality '95%' -resize 700 $i 700_$i; done}
function thumbs() {for i in pic*; do convert -thumbnail x100 $i th_$i; done}
function 700-and-thumb-file() {convert -quality '95%' -resize 700 $1 700_$1; convert -thumbnail x100 $1 th_$1; }

LS_COLORS='no=00:fi=00:di=00;94:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=00;92:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
export LS_COLORS

umask 022

function conkeror-history() {
    cp /cygdrive/c/Users/scott/AppData/Roaming/conkeror.mozdev.org/conkeror/Profiles/*.default/places.sqlite /tmp/
    echo "select p.url from moz_places as p, moz_historyvisits as h where p.url not like '%googleads%' and p.id = h.place_id order by h.visit_date DESC limit 100;" | sqlite3 /tmp/places.sqlite |less
    rm /tmp/places.sqlite
}

# zsh-git stuff
# setopt promptsubst
# autoload -U promptinit
# promptinit
# prompt wunjo


bmk_file=~/.bashrc_bmk
if [ -f $bmk_file ]; then
  . $bmk_file
fi
alias bmk_reload='. $bmk_file'
alias bmk_list="sort $bmk_file | awk 'BEGIN { FS = "'"[ =]" }; { printf("%-25s%s\n", $1, $2) }'"'"
alias pg='ping google.com'
alias pg1='ping -c 1 google.com'
auth()
{
# ex: auth user@host ~/.ssh/id_rsa.pub
  ssh $1 "cat - >> ~/.ssh/authorized_keys" < $2
}

# S-f10 in emacs saves dir, F10 in zsh goes there.
do-cd-emacs() {
       LBUFFER="cd $(cat ~/.emacs.d/current-directory)"
       zle accept-line
}
zle -N do-cd-emacs
bindkey '\e[21~' do-cd-emacs #F10

# export CLASSPATH="$HOME/.jars/*"

# makes it so ins and other aliases get proper completion
unsetopt completealiases

EAT_CONFIG=development
# ^xs for incremental forward search
unsetopt flowcontrol

# async browsing, kinda
function b {(sleep 600; conkeror "$*" ) &}

bindkey "\C-w" kill-region

REPORTTIME=10

alias flash32='mv ~/.mozilla/plugins- ~/.mozilla/plugins-flash-sucks'
alias flash64='mv ~/.mozilla/plugins-flash-sucks ~/.mozilla/plugins'

# export JDK_HOME=/usr/lib/jvm/java-6-sun/
# export JAVA_HOME=/usr/lib/jvm/java-6-sun/

function forever { while true; do $*; done}

setopt promptsubst
autoload -Uz vcs_info

#precmd () { vcs_info }

zstyle ':vcs_info:*' formats '%r:%s:%b'
zstyle ':vcs_info:*' enable git cvs svn hg bzr darcs

alias redshift='redshift -l 38.87:-77.025'

alias consume='find -type f -name "*.mp3" | while read mp3; do mplayer -af scaletempo -speed 1.8 $mp3; done'

alias col='setxkbmap us -variant colemak; '
alias qwe='setxkbmap us'
alias qwf='setxkbmap us'

alias wgetdir='wget -r -nH -l1 -np'

function ranger-cd {
  before="$(pwd)"
  python2.6 ~/src/ranger/ranger.py --fail-unless-cd "$@" || return 0
  after="$(grep \^\' ~/.config/ranger/bookmarks | cut -b3-)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
# bindkey -s "\C-o" "ranger-cd^m"
bindkey -s "\C-o" "emacsclient -n .^m"


# . ~/.zsh/live-command-coloring.sh

. ~/.zsh/secret

alias slp="sudo /etc/acpi/sleep.sh sleep"

alias dashboard='watch --interval=3600 dashboard.clj -a'

# so s -x shows pids
compdef s=screen

# M-?to chdir to the parent directory (can't use M-u bc it's follow link in urxvt)
# bindkey -s '\e.' '^U..^M'

# If AUTO_PUSHD is set, Meta-p pops the dir stack
# M-p used elsewhere below
bindkey -s '^[p' '^Upopd >/dev/null; dirs -v^M'

# alt-s inserts sudo at beginning of line
insert_sudo () { BUFFER="sudo $BUFFER"; zle end-of-line }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# TODO M-l is lowercase, figure out a better binding
# insert_less () { BUFFER="less $BUFFER"; zle end-of-line; zle expand-or-complete }
# zle -N insert-less insert_less
# bindkey "^[l" insert-less

alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# see what's bound: bindkey '^p'
# or bindkey will show you what's bound to one key or all

# make xdg-open uses what gnome-open does
export DE="gnome"

alias -g ND='*(/om[1])' # newest directory
alias -g NF='*(.om[1])' # newest file

alias load-rvm='source "/home/scott/.rvm/scripts/rvm"'
[[ -s "/$HOME/.rvm/scripts/rvm" ]] && . "/$HOME/.rvm/scripts/rvm"

# Opens the github page for the current git repository in your browser
function gh() {
    giturl=$(git config --get remote.origin.url)
    if [[ "$giturl" == "" ]]; then
        echo "Not a git repository or no remote.origin.url set"
        exit 1
    fi

    giturl=${giturl/git\@github\.com\:/https://github.com/}
    giturl=${giturl/\.git//}
    echo $giturl
    gnome-open $giturl
}


insert_cat_null () { BUFFER+=" & cat > /dev/null"; zle end-of-line; }
zle -N insert-cat-null insert_cat_null
bindkey "^[;" insert-cat-null

alias naut="nautilus --no-desktop"

function hold_package {
    sudo su -c 'echo $1 hold | dpkg --set-selections'
}

alias packages-installed="dpkg --get-selections"
alias package-files="dpkg -L"

fpath=(~/src/zsh-completions $fpath)

# exec 2>>( while read X; do print "\e[91m${X}\e[0m" > /dev/tty; done & )

alias top="top -d 20 -u scott"
alias t="top -b -n 1 -c"

alias dualscreen=" xrandr --output LVDS1 --auto --output HDMI3 --right-of LVDS1 --auto --output VGA1 --off --output HDMI1 --off"
alias laptopscreen=" xrandr --output LVDS1 --auto --output HDMI3 --off --output VGA1 --off --output HDMI1 --off"
alias externalscreen=" xrandr --output LVDS1 --off --output HDMI3 --auto --output VGA1 --off --output HDMI1 --off"
alias vgaprojector="xrandr --output LVDS1 --auto --output VGA1 --right-of LVDS1 --auto --output HDMI1 --off"
alias hdmiprojector="xrandr --output LVDS1 --auto --output VGA1 --right-of LVDS1 --auto --output HDMI1 --auto"

autoload -Uz run-help-git
alias ext="aunpack"

export CONS_PLAYBACK_SPEED=1.0

alias wireless-restart="killall nm-applet; nm-applet"
alias grooveshark="google-chrome http://listen.grooveshark.com/"
alias doubleclick="/usr/bin/xte 'mouseup 2' 'mouseclick 1' 'mouseclick 1' &"
alias notmuch="emacsclient -e '(notmuch)'"
alias hangup="phone.sh terminate"
alias answer="phone.sh answer"
alias previous-song-pandora="pianoctl -"
alias next-song-pandora="pianoctl +"
alias computer="gnome-open computer:///"
# alias trash="gnome-open trash:///"
alias desktop="gnome-open ~/Desktop"
alias increase-volume="amixer sset PCM 10+ unmute"
alias decrease-volume="amixer sset PCM 10- unmute"
alias mute="amixer sset PCM mute"

# or M-0 M-.
insert-first-word () { zle insert-last-word -- -1 1 }
zle -N insert-first-word
bindkey '^[_' insert-first-word

alias aria2c-files="aria2c --bt-save-metadata --bt-metadata-only"

alias aria2c-torrent="aria2c --bt-save-metadata --conf-path=/home/scott/.aria2/torrents.conf"

bindkey -r '^[x'

# source ~/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor root)

bindkey '^[b' emacs-backward-word
bindkey '^[f' emacs-forward-word

function mana { man -P "less -p '[ ,][ ]$2'" $1 }

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

eval `dircolors`

alias feh="feh -B black -."

# eval "$(fasd --init auto)"

zle -N predict-on
listen-later() { extract-audio.sh "$1"; mv "$1".mp3 $cons/listen/; trash "$1" }

# man() {
#       env \
#               LESS_TERMCAP_md=$(printf "\e[1;31m") \
#               LESS_TERMCAP_me=$(printf "\e[0m") \
#               LESS_TERMCAP_se=$(printf "\e[0m") \
#               LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
#               LESS_TERMCAP_ue=$(printf "\e[0m") \
#               LESS_TERMCAP_us=$(printf "\e[1;32m") \
#                       man "$@"
# }

# zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==01=31}:${(s.:.)LS_COLORS}")'

alias autokey='sudo apt-get update 2> /tmp/keymissing; for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net --recv $key && gpg --export --armor $key | sudo apt-key add -; done'

# setopt menu_complete

if [ "$PS1" ] &&  [[ "$HOST" == "iandi" ]] ; then
   mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
   echo $$ > /dev/cgroup/cpu/user/$$/tasks
   echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release
fi

. ~/src/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "\e[A" history-substring-search-up
bindkey "\e[B" history-substring-search-down

# # # bind P and N for EMACS mode
# bindkey -M emacs '^P' history-substring-search-up
# bindkey -M emacs '^N' history-substring-search-down

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[p' history-beginning-search-backward-end
bindkey '^[n' history-beginning-search-forward-end

backward-isearch-with-input () {
    local tmp=$LBUFFER; LBUFFER=; \
    zle history-incremental-search-backward $tmp;
};
zle -N backward-isearch-with-input
bindkey '^[r' backward-isearch-with-input

# Say I'm in ~/Desktop/John Lennon/ and I do "mpv *", if I want to be
# able to use this command again from anywhere then I run this command on the *
expand-path()
{
    autoload -U modify-current-argument
    # modify-current-argument '${(qq)$(readlink -f ${(Q)ARG})}'
    # modify-current-argument '$(readlink -f $ARG)'
    modify-current-argument '${ARG:A:h:q}/$ARG'
}
zle -N expand-path
bindkey '^Xp' expand-path # C-x p

export ANDROID_HOME=~/Desktop/android-sdk-linux/

export TZ='America/Los_Angeles'

alias m="mpl"

# makes mouse wheel scrolling work in gtk3 apps
export GDK_CORE_DEVICE_EVENTS=1

if [[ $HOST == "iandi" ]]; then
    eval "$(hub alias -s)"
    compdef _git hub=git
fi

# selecta

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^[e" "insert-selecta-path-in-command-line"
