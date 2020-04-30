#!/bin/bash 

dir=`dirname $1`

function munge {
sed -e '/^---/ d' \
    -e 's/^```.*/~~~/' \
    -e 's/^title:/%title:/' \
    -e '/^layout:/ d' \
    -e 's/^##/---\
#/'\
    -e "s,\](images,\](file://$dir/images,"
}

function prepare {
    awk -f <(sed -e '0,/^#!.*awk/d' $0) $1 | munge > $tmpfile
}

tmpfile=/tmp/mdp.txt
rm -f $tmpfile

function loop {
    while sleep 1; do
        if ! [ -e $tmpfile ] || [ $1 -nt $tmpfile ]; then
            prepare $1
        fi
    done
}

prepare $1

(loop $1) &

mdp -i $tmpfile

kill %1

exit $?

#!/usr/bin/awk -f
{
  if(match($1,/^```/)) { 
    infence=!infence;
  }
  if (infence && ($1.length()==0 || match($0,/^\s+$/))) {
    # Non breaking space:
    print " ";
  } else { 
    print $0;
  }  
}
 
