#!/bin/bash

#parse options
recursive=1
execute=1
undo=1
copy=1

source_flag=1
target_flag=1
for option in $@; do
    #set source and target, when appropriate
    if [ $source_flag = 0 ]; then
	source_path=$(readlink -f $option)
	source_flag=1
	continue
    elif [ $target_flag = 0 ]; then
	target=$option
	target_flag=1
	continue
    fi

    #set appropriate flags for options
    if [ $option == "-r" ] || [ $option == "--recursive" ]; then
	recursive=0
    elif [ $option == "-x" ] || [ $option == "--execute" ]; then
	execute=0
    elif [ $option == "-u" ] || [ $option == "--undo" ]; then
	undo=0
    elif [ $option == "-c" ] || [ $option == "--copy" ]; then
	copy=0
    elif [ $option == "-s" ] || [ $option == "--source" ]; then
	source_flag=0
    elif [ $option == "-t" ] || [ $option == "--target" ]; then
	target_flag=0
    else
	echo "Unknown options: $option"
	exit
    fi
done

#error checking source and target options
if [ ! $source_path ]; then
    echo "Usage: source file needed"
    exit
fi
if [ ! $target ]; then
    target=$(basename $source_path)
fi

#write to program
cat << EOF
#!/bin/bash

#determine appropriate paths based on depth of call 
cur_path=\$(pwd)/\$(basename \$0)
self_path=\$(readlink -f \$0)
if [ \$cur_path == \$self_path ]; then
    source_path="$source_path"
else
    self_path=\$0
    source_path=\$1
fi

EOF

#create file based on options
if [ $copy = 0 ]; then
    echo "#copy"
    echo "cp \$source_path $target"
fi
if [ $execute = 0 ]; then
    echo "#execute"
    echo "(chmod 777 \$source_path; exec \$source_path)"
fi
if [ $undo = 0 ] || [ $recursive = 0 ]; then
    echo
    echo "for entry in \$(ls); do"
    if [ $undo = 0 ]; then
	echo "    #undo"
	echo "    if [ -f \$entry ] && \$(cmp -s \$entry \$source_path); then"
	echo "        rm \$entry"
	echo "    fi"
    fi
    if [ $recursive = 0 ]; then
	echo "    if [ -d \$entry ]; then"
	echo "        #recursive"
	echo "        (cd \$entry; exec \$self_path \$source_path)"
	echo "    fi"
    fi
    echo "done"
fi
echo "exit"
exit
