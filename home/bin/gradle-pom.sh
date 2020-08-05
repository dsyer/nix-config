#!/bin/bash

build=$1 # the directory containing a build.gradle or the build.gradle
if [ "${build}" == "" ]; then build=$(pwd)/build.gradle; fi
if [ "${build%*.gradle}" == "${build}" ]; then
    if echo "${build%}" | grep -q '\/$'; then
        build=$(echo ${build} | sed -e 's,/$,,')
    fi
    build=${build}/build.gradle;
fi
if ! [ -e ${build} ]; then build=${build}.kts; fi
if ! [ -e ${build} ]; then
	echo could not locate build.gradle
	exit 1
fi
build=${build#./*}
dirname=`dirname $build`

if grep -q buildscript $build; then
	oldstyle=1
else
	# Might be wrong but you have to start somewhere
	oldstyle=0
fi

function gradle {
         dir=`pwd`
         while [ "$dir/*.gradle*" != "" ] && ! [ -e $dir/gradlew ] && ! [ -z $dir ]; do dir=${dir%/*}; done
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

if [ "$oldstyle" == "1" ]; then
	if ! grep -q maven $build; then
		sed -i -e '/^plugins {/a apply plugin: "maven-publish"' $build
		cat >> $build << EOF

publishing {
	publications {
		mavenJava(MavenPublication) {
			from components.java
		}
	}
}
EOF
	fi
	# Older versions of Gradle had a "maven-publish" plugin with a "generatePom" task, even older had "maven" with "install"
	(cd $dirname; gradle generatePomFileForMavenJavaPublication || gradle generatePom || gradle install) > /dev/null 2>&1
	[ -e ${dirname}/build/publications/mavenJava/pom-default.xml ] && cat ${dirname}/build/publications/mavenJava/pom-default.xml
	[ -e ${dirname}/build/poms/pom-default.xml ] && cat ${dirname}/build/poms/pom-default.xml
else
	if ! grep -q maven $build; then
		sed -i -e '/^plugins {/a id "maven-publish"' $build
		cat >> $build << EOF

publishing {
	publications {
		mavenJava(MavenPublication) {
			from components.java
		}
	}
}
EOF
	fi
	(cd $dirname; gradle generatePomFileForMavenPublication > /dev/null 2>&1)
	cat ${dirname}/build/publications/maven/pom-default.xml
fi
