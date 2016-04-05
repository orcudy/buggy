##Manual

**NAME**  
	buggy - creates shell scripts

**SYNOPSIS**    
	buggy [OPTION]... -s source
	
**DESCRIPTION**  
	Creates recursive shell scripts that have the ability to copy/remove arbitrary files into/out of a directory or recursively execute arbitrary code.
	
-r, --recursive  
	recursively execute script through all descendant directories

-x, --execute  
	execute *source*

-u, --undo  
	remove files equivalent to *source*
	    
-c, --copy  
	copy *source*

-s, --source  
	specify path to source file
	    
-t, --target  
	when copyiny, specifies name of new file

##Demonstration
The *programs* directory in the root directory illustrates potential source files that can be input to buggy:

1. **gpl-v3.0**: plain text files
2. **a.out**: executable files

To copy the contents of gpl-v3.0 to all subdirectories, we first need to create the appropriate script. We do this with buggy as follows:
`$ ./buggy -s programs/gpl-v3.0 -r -c > license.sh`

This creates a new shell script that will recursively copy the contents of gpl-v3.0 to all subdirectories of where the script is being executed. To execute the shell script, run the following:
`$ chmod 700 license.sh`
`$ ./license.sh`

The buggy script also has the ability to undo what was previously done. For instance, if we wanted to remove the gpl-v3.0 file from all subdirectories, we would run the following sequence:
`$ ./buggy.sh -s programs/gpl-v3.0 -r -u > undo-license.sh` 
`$ chmod 700 undo-license.sh`
`$ ./undo-license.sh`

We can also use buggy to write scripts that will execute arbititrary code. For instance, if we wanted to execute a.out in all subdirectories, we would run the following: 
`$ ./buggy.sh -s programs/a,out -r -x > main.sh` 
`$ chmod 700 main.sh`
`$ ./main.sh`

The `-s` option is the only required option in the above code, all other options can be removed and combined as necessary.

For a live demonstration, navigate to the root directory of buggy, and run `make`. This will create a sandbox which includes a nested directory and four shell scripts. The `Makefile` and this sandbox should be used to experiment with buggy.


