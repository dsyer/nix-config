#!/bin/bash

if [ "$1" == "-a" ]; then
	format="asciidoctor"
	shift
elif [ "$1" == "-m" ]; then
	format="markdown"
	shift
fi

input=${1:-/dev/stdin}
staging=$(mktemp)
if [ "${format}" == "asciidoctor" ]; then
	cat $input | sed -e 's/^/|/' -e 's/,/|,/g' > $staging
elif [ "${format}" == "markdown" ]; then
	temp=$(mktemp)
	cat $input > $temp
	head -1 $temp > $staging
	head -1 $temp | sed -e 's/[^, ]/-/g' >> $staging
	sed -e '1d' $temp >> $staging
	sed -i -e 's/^/|/' -e 's/,/|,/g' $staging
	rm $temp
else
	cat $input > $staging
fi
cat $staging | sed -e 's/, /,/g' | tr ',' ' ' | column -t
rm $staging

