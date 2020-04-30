#!/bin/bash

poms=$(find . -name pom.xml)

modules=()
for pom in $poms; do
    pom=${pom#./*}
    if ! [ $pom == "pom.xml" ] && [ ${pom#*/target} == $pom ]; then
        dir=${pom%*/pom.xml}
        modules+=($dir)
    fi
done

for module in "${modules[@]}"; do
    if ! [ -d .mvn ] && [ -d ${module}/.mvn ]; then
        cp -rf ${module}/.mvn .
        cp -rf ${module}/mvn* .
    fi
    rm -rf ${module}/.mvn ${module}/mvn*
done

for module in "${modules[@]}"; do
    if ! [ -f .gitignore ] && [ -f ${module}/.gitignore ]; then
        cp -rf ${module}/.gitignore .
    fi
    rm -rf ${module}/.git*
done
