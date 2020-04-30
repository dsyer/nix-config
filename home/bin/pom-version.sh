#!/bin/bash

#MAVEN_HOME=~/Programs/apache-maven-3.3.1
#time $MAVEN_HOME/bin/mvn -Dexec.executable="echo" -Dexec.args='${project.version}' -q -o --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec
sed '\!<parent!,\!</parent!d' $1 | grep '<version' | head -1 | sed -e 's/.*<version>//' -e 's!</version>.*$!!'
