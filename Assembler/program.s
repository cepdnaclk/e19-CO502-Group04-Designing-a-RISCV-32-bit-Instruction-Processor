# Example RISC-V program using RV32I + RV32M + FENCE instructions

    LUI   x1, 0x10000         # Load upper immediate to x1 (e.g., base address)
    ADDI  x2, x0, 10          # x2 = 10
    ADDI  x3, x0, 20          # x3 = 20

loop:
    MUL   x4, x2, x3          # x4 = x2 * x3
    DIV   x5, x4, x2          # x5 = x4 / x2
    REM   x6, x4, x3          # x6 = x4 % x3

    BEQ   x5, x6, done        # if x5 == x6 jump to done

    LW    x7, 0(x1)           # load word from address in x1 to x7
    ADDI  x7, x7, 1           # increment x7
    SW    x7, 0(x1)           # store x7 back to memory

    FENCE  iorw,iorw          # fence to order memory accesses

    JAL   x0, loop            # jump back to loop

done:
    FENCE.I                   # instruction fence (flush pipeline)
    ADDI  x10, x0, 0          # set x10 = 0 (exit code)
