v.add r2, r0    ; vr[r2] = {0, 1, 2, 3}
s.movl 4        ; sr[r1] = X4
s.add r2, r1    ; sr[r2] = 4

init_A:
    s.movl 3
    s.sub r3, r1
    s.movh 1
    s.movl 4        ; sr[r1] = 20

    s.brzr r3, r1   ; se r3 == 3 pula para o init_B

    s.movh 0
    s.movl 3        ; manipulacao do laco

    s.add r3, r1    ; sr[r3] recupera seu valor original

    v.st r2, r3     ; M[ r3 ] = r2

    s.movh 0
    s.movl 1        ; sr[r1] = 1

    s.add r3, r1    ; sr[r3] = sr[r3] + 1
    sv.lr r3, r3    ; vr[r3] = sr[r3]

    sv.lr r1, r2    ; vr[r1] = 4

    v.add r2, r1   ; vr[r2] = vr[r2] + 4

    s.movl 3        ; sr[r3] = 3

    s.brzr r0, r1   ; pula para init_A

v.movh 0
v.movl 8
v.add r2, r1        ; vr[r2] = {20, 21, 22, 23} 
s.movh 0
s.movl 3
s.add r3, r1        ; sr[r3] = 3

init_B:
    s.movh 0
    s.movl 6
    s.sub r3, r1
    s.movh 3
    s.movl 0       ; sr[r1] = fim do loop (45)

    s.brzr r3, r1   ; se r3 == 6 pula para o soma_AB

    s.movh 0
    s.movl 6        ; manipulacao do laco

    s.add r3, r1    ; sr[r3] recupera seu valor original

    v.st r2, r3     ; M[ r3 ] = r2

    s.movh 0
    s.movl 1        ; sr[r1] = 1

    s.add r3, r1    ; sr[r3] = sr[r3] + 1
    sv.lr r3, r3    ; vr[r3] = sr[r3]

    sv.lr r1, r2    ; vr[r1] = 4

    sv.add r2, r1   ; vr[r2] = vr[r2] + 4

    s.movh 1
    s.movl 10        ; sr[r3] = init_B (26)

    s.brzr r0, r1   ; pula para init_B

soma_AB:
    v.movh 0
    v.movl 0
    v.ld r2, r1
    v.movl 3
    v.ld r3, r1
    v.add r2, r3
    v.movl 6
    v.st r2, r1

    v.movh 0
    v.movl 1
    v.ld r2, r1
    v.movl 4
    v.ld r3, r1
    v.add r2, r3
    v.movl 7
    v.st r2, r1

    v.movh 0
    v.movl 2
    v.ld r2, r1
    v.movl 5
    v.ld r3, r1
    v.add r2, r3
    v.movl 8
    v.st r2, r1

s.movh 4
s.movl 7
s.brzr r0, r1