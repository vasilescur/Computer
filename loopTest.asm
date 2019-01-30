# This is a test of conditional jumps by creating a simple loop.
# The program should output the numbers 1-5.

_main:
    # for ($2 = 0; $2 < 5; )
    li      $1, 31      # Current character (ASCII 49 (0x31) = '1')
    li      $2, 0       # How many we've done
    li      $3, 5       # How many we want to do

_loop:
    # Print the current character
    li      $8, 1       # Syscall 1 = print ASCII char
    syscall

    # Increment
    addi    $1, 1       # Increment the character
    addi    $2, 1       # Increment the counter

    # Test and branch
    cmp     $2, $3      # Compare registers $2 and $3

    jlt     _loop        # if ($2 < $3) -> j loop
    

    jeq     _end
    

_end:
    li      $8, f       # Syscall f = halt clock
    syscall