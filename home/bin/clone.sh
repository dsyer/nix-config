#!/bin/bash

if [ $# -lt 2 ]; then
    cat <<EOF

Create a new Eclipse project based on an existing template.  Usage

$ clone.sh [-clean] input output name

where 

  * -clean (optional) signals that the output directory should be deleted first
    (otherwise it must be empty or non-existent)
  * input is an existing Eclipse project dir
  * output is the location you want to create a new one in
  * name is the new name of the project (if different to the directory name)

EOF
    exit 1
fi

CLEAN=
if [ "$1" == "-clean" ]; then
    CLEAN=$1; shift
fi

INPUT=$1; shift
OUTPUT=$1; shift
if [ ! "$1" == "" ]; then
    NAME=$1; shift
else
    NAME=`basename $OUTPUT`
fi

if [ ! -d $INPUT ]; then
    echo Input directory $INPUT does not exist
    exit 1
fi

if [ -n "$CLEAN" ]; then
    if [ -d $OUTPUT ]; then
        rm -rf $OUTPUT
    fi
elif [ -d $OUTPUT ]; then
    echo Output directory already exists.  Use -clean to remove it.
    exit 1
fi

mkdir -p $OUTPUT

# make it a nice clean directory (TODO: make this optional)

# copy the files
cp -rf $INPUT/* $OUTPUT
cp -rf $INPUT/.??* $OUTPUT 2>/dev/null || :

# remove VCS meta data if there is any
find $OUTPUT -name .svn -exec rm -rf {} \; 2> /dev/null
find $OUTPUT -name .git -exec rm -rf {} \; 2> /dev/null

# make a temporary file with an awk script in it
cat > clone.awk <<EOF
# replace a one-line XML element at the top level

BEGIN { 

      open = 0 
      if (name=="") {
            name = "clone"
      }
      if (element=="") {
            element = "name"
      }

      pattern = sprintf("(.*<%s>)(.*)(</%s>.*)", element, element)

}
{
      # count the XML open and close tags
      if (\$0 ~ /<[a-zA-Z]/) { open += 1; }
      if (\$0 ~ /<\/[a-zA-Z]/) { open -= 1; }

      # look for the specified element and replace its content
      if (\$0 ~ pattern && open==1) { 
	  gsub(">.*</",">"name"</")
      }
      print

}
EOF

if [ -e $OUTPUT/.project ]; then
    awk -f clone.awk -v name=$NAME $OUTPUT/.project > clone.foo; mv clone.foo $OUTPUT/.project
fi

if [ -e $OUTPUT/pom.xml ]; then
    awk -f clone.awk -v name=$NAME -v element=artifactId $OUTPUT/pom.xml > clone.foo; mv clone.foo $OUTPUT/pom.xml
    awk -f clone.awk -v name=$NAME -v element=name $OUTPUT/pom.xml > clone.foo; mv clone.foo $OUTPUT/pom.xml
fi

rm clone.awk

if [ -e $OUTPUT/.settings/org.eclipse.wst.common.component ]; then
	sed -e 's/.*<wb-module.*-name=".*/    <wb-module deploy-name="'$NAME'">/' $OUTPUT/.settings/org.eclipse.wst.common.component > clone.foo; mv clone.foo $OUTPUT/.settings/org.eclipse.wst.common.component
	sed -e 's,.*<property name="context-root" value=".*,        <property name="context-root" value="'$NAME'"/>,' $OUTPUT/.settings/org.eclipse.wst.common.component > clone.foo; mv clone.foo $OUTPUT/.settings/org.eclipse.wst.common.component
fi

if [ -e $OUTPUT/src/main/resources/META-INF/MANIFEST.MF ]; then
    for f in $OUTPUT/src/main/resources/META-INF/MANIFEST.MF; do
        sed -e "s/\(Bundle-SymbolicName: \).*/\1$NAME/" $f > clone.foo; mv clone.foo $f
    done
fi

# If there is a Bundlor template there with the same name as the artifact, tranform it
if [ -e $OUTPUT/src/main/resources/META-INF/*.mf ]; then
    for f in $OUTPUT/src/main/resources/META-INF/*.mf; do
        sed -e "s/\(Bundle-SymbolicName: \).*/\1$NAME/" $f > $OUTPUT/src/main/resources/META-INF/$NAME.mf
    done
fi




