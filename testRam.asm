_main:

    li      $1, 6
    li      $2, 2

    sw      $1, $2
    #nop

    lw      $4, $2

    li      $8, f
    syscall