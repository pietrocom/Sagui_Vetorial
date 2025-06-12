movl 15   ;; primeiro loop zera tres espaços a mais (inidica o fim mais claramente)
add r2 r0
brzr r2 r3   ;; COMEÇO PRIMEIRO LOOP (ZERA espaço de memória)
movl 1
sub r2 r0   ;; i--
st r1 r2   ;; zera na posição do primeiro vetor
movl 12 
add r2 r0   ;; desloca 12
st r1 r2   ;; zera na posição do segundo vetor
add r2 r0   ;; desloca 12
st r1 r2   ;; zera na posição do terceiro vetor
sub r2 r0
sub r2 r0  ;; retira deslocamento
movl 2 ;; endereço de retorno para jr
svpc r3 r3  ;; salva PC para retorno - 2
add r3 r0
add r3 r0
jr r0, r0   ;; FIM PRIMEIRO LOOP
movl 12
sub r1 r1
sub r3 r3
add r2 r0    ;; reg reiniciados
movh 0    ;; COMEÇO SEGUNDO LOOP (carrega A e B)
movl 2    ;; ajusta PC de branch em r3
add r3 r0
brzr r2 r3
movl 1
sub r2 r0
st r2 r2    ;; carrega em A
movl 12    ;; desloca
add r1 r2
add r2 r0
movl 4
movh 1
add r1 r0
st r1 r2     ;; carrega em B
sub r1 r1
movh 0
movl 12
sub r2 r0
movl 4
movh 1
svpc r3 r3
jr r0, r0   ;; FIM SEGUNDO LOOP
movl 0
movl 12
sub r1 r1
sub r3 r3
add r2 r0    ;; reg reiniciados
movh 0     ;; COMEÇO TERCEIRO LOOP (soma A e B)
movl 2
add r3 r0
brzr r2 r3
sub r3 r3 
movl 1
sub r2 r0 
ld r3 r2    ;; recebe valor de A[i]
movl 12  
add r2 r0 
ld r1 r2    ;; recebe valor de B[i]
add r1 r3   ;; A[i] + B[i]
add r2 r0   
st r1 r2    ;; guarda no terceiro vetor
sub r3 r3 
sub r1 r1
sub r2 r0 
sub r2 r0
movl 13
movh 2
svpc r3 r3
jr r0, r0 ;; FIM TERCEIRO LOOP
movl 2
sub r2 r2
svpc r2 r2
add r2 r0
jr r2 r2 ;; HALT