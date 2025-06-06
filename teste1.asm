; essa versao do codigo soma os vetores
; A = {0,1,2,3,4,5,6,7,8,9,10,11}
; B = {12,13,14,15,16,17,18,19,20,21,22,23}

v.add r2, r0    ; vr[r2] = {0, 1, 2, 3}
s.movl 4        ; sr[r1] = X4
s.add r2, r1    ; sr[r2] = 4

init_AB:
    s.movl 6
    s.sub r3, r1
    s.movh 1
    s.movl 4        ; sr[r1] = 20

    s.brzr r3, r1   ; se r3 == 6 pula para o fim_loop

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

    s.movl 3        ; sr[r3] = 3

    s.brzr r0, r1   ; pula para init_AB

fim_loop:
    v.sub r2, r2
    v.sub r3, r3
    s.sub r3, r3

soma_AB:

    s.movh 0
    s.movl 3
    s.sub r3, r1
    s.movh 2
    s.movl 13        ; sr[r1] = 45

    s.brzr r3, r1   ; se r3 == 3 pula para o fim_loop

    s.movh 0
    s.movl 3        ; manipulacao do laco

    s.add r3, r1    ; sr[r3] recupera seu valor original

    sv.lr r3, r3    ; vr[r3] = sr[r3]
    v.ld r2, r3     ; vr[r3] = M[ r3 ]
    v.movl 3
    v.add r3, r1    ; vr[r3] = vr[r3] + 3
    v.ld r3, r3     ; vr[r3] = M[ r3 ]

    v.add r2, r3    ; soma dos 4 termos dos vetores

    sv.lr r3, r3    ; vr[r3] = sr[r3]
    v.movl 6
    v.add r3, r1    ; faz o calculo da base mais o deslocamento
    st r2, r3       ; armazena a soma

    s.movh 1
    s.movl 8        ; sr[r1] = 24

    s.brzr r0, r1   ; pula para init_AB

s.brzr r3, r1       ; halt
