# Led blinking program idea

## **It seems that there is an error in specification of micro**

- SUB command instead of:
> R[WA]=R[RB]-R[RA]
- is doing
> R[WA] = R[RA] - R[RB]
- example
```
# we want to substract R2 from R4
1442 is correct form from specification
BUT isn't working
1424 works
```

1. **setup starting memory**
```
    LDA R2 1        # R2 holds 1
    LDB R2 0
    LDA R0 0        # Led OFF
    LDB R0 0
```
2. **setup downcounter - ctr**
```
    LDA R1 4 # blink 2 times
    LDB R1 0
```
3. **if key isn't pressed stay here**
```
    BN0 0
```
4. **change led state**
```
    ADD R0 R0 R2 # add 1 - last bit will change everytime
```
5. **wait 500ms - 50M ticks**
```
    # we need some loop inside loop
    LDA R5 LOW(x)
    LDB R5 HIGH(x)
    :loop1
        LDA R4 LOW(y)
        LDB R4 HIGH(y)
        SUB R4 R4 R2   # substract one
        B1 2
        BR -2
        # if R4 isn't 0 then go back to sub
    SUB R5 R5 R2       # out loop
    B1 2
    BR :loop1
    NOP
```
> cycles:
> - setup outer loop: 2
> - inside loop1: 2 for setup and 3 cycling(-1 for every x)
> - 5 for sub and branch again(-1 at the end)
> - 1 for nop(no solution without this)
> formula: 4x+3yx+2 = 50M
> possible soultions:
```
x=10002 y=1665
x=14997 y=1110 <- i've picked this one
```
6. ctr--
```
SUB R1 R1 R2    # sub 1 from ctr
```
7. if ctr = 0 go to 2. if not, go to 4.
```
B1 :.2 #go to point 2
BR :.4 #go to point 4
```
