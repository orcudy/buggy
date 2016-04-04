#!/bin/bash

#parse options
recursive=1
execute=1
undo=1
source_flag=1
target_flag=1
target=target.sh
for option in $@; do
    #set source and target, when appropriate
    if [ $source_flag = 0 ]; then
	source_path=$(readlink -f $option)
	source=$(cat $source_path)
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
    elif [ $option == "-s" ] || [ $option == "--source" ]; then
	source_flag=0
    elif [ $option == "-t" ] || [ $option == "--target" ]; then
	target_flag=0
    else
	echo "Unknown options: $option"
	exit
    fi
done

if [ ! -n $source ]; then
    echo "Usage: source file needed"
    exit
fi

#write to program
cat << EOF
#!/bin/bash

#determine appropriate paths based on depth of call 
cur_path=\$(pwd)/\$(basename \$0)
self_path=(readlink -f \$0)
if [ cur_path == self_path ]; then
    source_path=$source_path
else
    self_path=\$0
    source_path=\$1
fi

#begin interesting part
for entry in \$(ls); do
    if [ -d \$entry ]; then
EOF

#undo option
if [ \$undo = 0 ]; then
    cat << 'EOF'
if [ -f \$entry ] && $(cmp -s \$entry \$source_path); then
    rm \$entry
fi
EOF
else
    cat << SOURCE
cat << 'EOF' > \$entry/$target
$source
EOF
SOURCE
fi

#execute option
if [ $execute = 0 ]; then
    echo "(exec \$entry/$target)"
fi

#recursive option
if [ \$recursive = 0 ]; then
    echo "(cd \$entry; exec \$self_path \$source_path)"
fi
echo "    fi"
echo "done"
echo "exit"
exit
