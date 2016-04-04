#!/bin/bash

if (("$#" == 0)); then
    path_to_self=$(pwd)
    for file in $(ls); do
	if [ -d $file ]; then
	    cat <<EOF > $file/.gitignore
*~
.DS_Store
EOF
	    (cd $file; exec $path_to_self/$(basename $0) $path_to_self)&
	fi
    done
    exit
fi

for file in $(ls); do
    if [ -d $file ]; then
	cat <<EOF > $file/.gitignore
*~
.DS_Store
EOF
	(cd $file; exec $1/$(basename $0) $1)&
    fi
done
exit
	
