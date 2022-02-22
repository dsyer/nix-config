alias dos2unix=fromdos
alias unix2dos=todos

alias unat='xmodmap -e "keycode 24 = q Q at at at at"'
alias gb='setxkbmap -layout gb'

alias unstick='xdotool key --clearmodifiers keyup Control_L keyup Control_R keyup Shift_L keyup Shift_R keyup Super_L keyup Meta_L keyup Meta_R'
function ifgem() {
  if [ -f Gemfile ]; then bundle exec $*; else $*; fi
}

alias prmpt="PS1='$ '"

alias nix-shell='nix-shell --command "$(declare -p PS1 | sed -e s/=/=nix:/); return"'

if which hub > /dev/null; then
   alias git=hub
fi

alias scale='gsettings set com.canonical.Unity.Interface text-scale-factor'
alias clear="echo -ne '\033c'"

function mvn {
         dir=`pwd`
         while [ -e $dir/pom.xml ] && ! [ -e $dir/mvnw ] && ! [ -z $dir ]; do dir=${dir%/*}; done
		 if ! [ -e $dir/mvnw ] && [ -e $dir/../mvnw ]; then dir=${dir%/*}; fi
         if [ -e $dir/mvnw ]; then
              echo "Running wrapper at $dir"
              $dir/mvnw "$@"
              return $?
         fi
         echo No wrapper found, running native Maven
         `which mvn` "$@"
}

function gradle {
         dir=`pwd`
         while [ "$dir/*.gradle" != "" ] && ! [ -e $dir/gradlew ] && ! [ -z $dir ]; do dir=${dir%/*}; done
         if [ -e $dir/gradlew ]; then
              echo "Running wrapper at $dir"
              $dir/gradlew "$@"
              return $?
         fi
         echo No wrapper found, locating native Gradle
         if ! which gradle; then
           echo No native gradle found && return 1
         fi        
         `which gradle` "$@"
}
