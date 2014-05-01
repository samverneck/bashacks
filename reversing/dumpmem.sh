dumpmem()
{
    local USAGE="Creates file on disk with memory contents of a process.\n
   dumpstack <pid> <outfile>
   dumpheap <pid> <outfile>\n
   Category  : Reverse Engineering.\n
   Parameters:
        -h      : Help.
        pid     : The PID of the process.
        outfile : Output file.\n
        root is required\n
   Output:
   root # dumpstack 15125 pilha.dump
   root # dumpheap 15125 heap.dump"

    [ $# -le 1 -o "$1" == '-h' -o "${EUID}" -ne 0 ] && {
        echo -e "${USAGE}"
        return 1
    }
 
    local stack_addr=$(grep -m 1 "$1" /proc/$2/maps |
	            cut -d' ' -f1 | sed 's/^/0x/; s/-/ 0x/')

	test -n "$stack_addr" && \
	        echo "dump memory "$3" $stack_addr" | gdb --pid $2 &> /dev/null
}

alias dumpstack='dumpmem stack'
alias dumpheap='dumpmem heap'