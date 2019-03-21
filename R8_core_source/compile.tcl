# TCL ModelSim compile script
# Pay atention on the compilation order!!!



# Sets the compiler
#set compiler vlog
set compiler vcom







#########################
### Source files list ###
#########################

# Source files listed in hierarchical order: botton -> top
set sourceFiles {
	../src/R8_pkg.vhd
	../src/RegisterNbits.vhd
	../src/RegisterFile.vhd
	../src/ALU.vhd
	../src/DataPath.vhd
	../src/ControlPath.vhd
	../src/R8.vhd
	../src/Util_package.vhd
	../src/Memory.vhd
	./R8_tb.vhd
}

set top R8_tb




####################
### work library ###
####################

# Creats the work library if it does not exist
if { ![file exist work] } {
	vlib work
	vmap work work
}




###################
### Compilation ###
###################

if { [llength $sourceFiles] > 0 } {
	
	foreach file $sourceFiles {
		if [ catch {$compiler $file} ] {
			puts "\n*** ERROR compiling file $file :( ***" 
			return;
		}
	}
}




################################
### Lists the compiled files ###
################################

if { [llength $sourceFiles] > 0 } {
	
	puts "\n*** Compiled files:"  
	
	foreach file $sourceFiles {
		puts \t$file
	}
}


puts "\n*** Compilation OK ;) ***"

#vsim $top
#set StdArithNoWarnings 1

