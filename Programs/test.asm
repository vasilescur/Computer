# This is a comment!

_main:
    nop    

    # OK, let's print something! #
    li      $1, 49      # Value is gonna be ASCII 49
    li      $8, 1       # Syscall 1 = print one ASCII char
    syscall

    # ... and now, end the program (after clearing the regs!):
    li      $8, 3       # Clear registers
    syscall

    # Use a jump lol
    j       _end
    
    li      $3, 1
    li      $3, 2
    li      $3, 3
    li      $3, 4

_end:
    li      $8, F       # End program.
    syscall

    # Woot!