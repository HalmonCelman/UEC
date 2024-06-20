    LDA R2 1
    LDB R2 0
    LDA R0 0
    LDB R0 0
    LDA R1 4
    LDB R1 0
    BN0 0
    ADD R0 R0 R2
    LDA R5 0x95
    LDB R5 0x3A
        LDA R4 0x56
        LDB R4 0x04
        SUB R4 R4 R2
        B1 2
        BR -2
    SUB R5 R5 R2
    B1 2
    BR -7
    NOP
    SUB R1 R1 R2
    B1 -16
    BR -14