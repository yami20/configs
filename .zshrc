ssh-add -A 2> /dev/null
export PERL_CPANM_OPT="--mirror http://cpan.metacpan.org --mirror http://denapan.dena.jp"
bindkey '^[[3~' delete-char

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

bindkey "^[[3~" delete-char
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/dev/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/.local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export GO111MODULE=on
eval "$(jenv init -)"
export PATH=/usr/local:$PATH
export PATH="$HOME/.plenv/bin:$PATH"
export PATH="$PATH:$HOME/.nodebrew/current/bin"
export PATH="$PATH:$HOME/Develop"
export PATH="$PATH:/usr/local/bin"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

export PROTOHOME="$HOME/go/src/github.com/yami20/proto-sales"
# eval "$(plenv init -)"

export PATH=$PATH:/usr/local/mysql/bin

# gcloud
export PATH="$PATH:$HOME/Develop/google-cloud-sdk/bin"

# jEnv
export JENV_ROOT="$HOME/.jenv"
if [ -d "${JENV_ROOT}" ]; then
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi

PROMPT="%n> "

fpath=(~/.zsh/completion /usr/local/share/zsh/functions $fpath)
# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  if [ -n "`git status 2>&1 | grep 'not a git repository'`" ]; then
	  return
  fi

  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  echo "[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
#RPROMPT="%/% @%D %T"
RPROMPT='%/% `rprompt-git-current-branch`@%T'
setopt ALWAYS_LAST_PROMPT

autoload -U compinit

# eval "$(rbenv init -)"
alias ss="svn status"
alias sc="svn commit"
alias sup="svn update"
alias gitclean="git branch --merged | grep -v '*' | grep -v master | xargs -I MERGED_BRANCH git branch -d MERGED_BRANCH"
alias ulid="cd /Users/mitsuo.sugaya/go/src/github.com/ulid; go run cmd/ulid/main.go ; cd -"

alias scr="screen"
alias sr="screen -r"

alias ll="ls -lh"
alias la="ls -alh"
alias cp="cp -v -i"
alias mv="mv -v -i"
alias rm="rm -v"

alias df="df -hT"
alias dush="du -sh"

alias his="history | grep "
alias ff='find . -name $*'
#PHPUnit
alias pu="phpunit --colors"

alias cdj="cd $HOME/git/pfsys-Justice"
alias cdp="cd $HOME/git/whiteberg_portal"
alias cdps="cd $HOME/git/whiteberg_portal/api/src"
alias cdc="cd $HOME/git/whiteberg_core"
alias cdcs="cd $HOME/git/whiteberg_core/api/src"
alias cdc="cd $HOME/git/coralreef"
alias cdca="cd $HOME/git/whiteberg_sales/api/src"
alias cdi="cd $HOME/git/whiteberg_insurer"
alias cdia="cd $HOME/git/whiteberg_insurer/api/src"

function gr() {
        command grep -r --color $1 ./
}

function gocache() {
  go clean -cache
  go mod tidy
}


function stringIcon() {
  if [ $# -ne 3 ]
  then
    size="1"
    input="te\nst"
    output="output"
  else
    size="$1"
    input="$2"
    output="$3"
  fi
  command convert -size 128x128 -background white -fill black -font /System/Library/Fonts/ヒラギノ角ゴシック\ W${size}.ttc label:${input} ${output}_128x128.png
}

function exifIcon() {
  command convert -size 128x128 -background white -fill black -font  /System/Library/Fonts/ヒラギノ角ゴシック\ W8.ttc label:"いぐ\nじふ" exif_128x128.jpg
}

function icon() {
  input="./$1"
  output="${input}_128x128.png"
  command convert -resize 128x128 ${input} ${output}
}
[ -f $HOME/perl5/perlbrew/etc/bashrc ] && source $HOME/perl5/perlbrew/etc/bashrc
__prompt () {
    local perl=
    [ -z $PERLBREW_PERL ] || perl=$(echo $PERLBREW_PERL)
    PS1="[pl:${perl:-"system"}] \u@\h:\w> "
}

function retrieve_id_token() {
  res=`echo "$1" | awk -F 'id_token=' '{print $2}' | awk -F '&' '{print $1}'`
  echo "==="
  echo $res
  echo "==="
}
function sqlproxy() {
  # $1 = env $2 = db
  conf="$HOME/git/taxi-fms-ope/conf/secrets/${1}.yaml"
  handle_="${2}_w"
  handle=`echo ${handle_} | tr '[:lower:]' '[:upper:]'`
  echo $handle
  instance="db-${2}"

  echo "===="
  grep "${handle}" ${conf}
  echo "===="
  cloud_sql_proxy -dir=/cloudsql -instances=dena-auto-taxifms-${1}-gcp:asia-northeast1:${instance}
}

function fujidev() {
  docker-machine start dev
  eval "$(docker-machine env dev)"
}

function dockerclean() {
  docker ps -a -q | xargs docker rm -f
}

function pasgen() {
  openssl rand -hex $1
}

function dockerstop() {
	if [ -z "$1" ]; then
		echo "image name must given"
	else
		docker ps | grep "$1"  | cut -d' ' -f1 | head | xargs -I{} docker stop {}
	fi
}

function naup() {
  cd ~/git/fujiyama-development
  docker-compose up -d --no-recreate account
  docker-compose run karasuma perl script/setup_local_db.pl reset
  docker-compose run karasuma perl script/setup_local_idp_data.pl
  docker-compose run karasuma perl script/manage_terms.pl --no-sleep
  docker-compose run karasuma perl script/manage_static_terms.pl --no-sleep
  docker-compose run donguri perl script/setup_account_keys.pl
  docker-compose run karasuma perl script/setup_internal_clients.pl --name karasuma,toba,nintendo_network,kujo
  docker-compose run karasuma perl script/setup_dummy_clients_for_friend_recommendation_debug.pl --exec
  cd -
}

function compare_perl() {
  base_perlbrewhash=`git show $1:.perlbrewhash`
  current_perlbrewhash=`cat .perlbrewhash`
  echo "perlbrew diff between current & $1"
  echo "$base_perlbrewhash -> $current_perlbrewhash"
  (cd ../perlbrew/ && git remote update && git diff --name-only $base_perlbrewhash $current_perlbrewhash)
}

function local_datastore() {
    gcloud beta emulators datastore start --host-port=localhost:8484
}

PROMPT_COMMAND=__prompt

ssh-add -K ~/.ssh/id_rsa

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mitsuo.sugaya/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mitsuo.sugaya/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mitsuo.sugaya/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mitsuo.sugaya/dev/google-cloud-sdk/completion.zsh.inc'; fi
