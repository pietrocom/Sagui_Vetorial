# Implementação da Arquitetura Sagui (Vetorial e VLIW)

**Disciplina:** CI112 - Arquitetura de Computadores
**Período:** 2025/1
**Instituição:** Universidade Federal do Paraná (UFPR)
**Autores:**
* Pietro Comin (GRR20241955)
* Pedro Takeo Shima

---

## 🧠 1. Sobre o Projeto

Este trabalho acadêmico consiste no projeto e implementação de duas versões de uma arquitetura de processador de 8 bits, a **ISA Sagui**: uma **VLIW (Very Long Instruction Word)** e uma **Vetorial (SIMD)**. O objetivo foi aplicar os conceitos de arquitetura de computadores na prática, desde o design do datapath e sinais de controle até a implementação funcional e programação em Assembly.

Todo o desenvolvimento, incluindo o design do caminho de dados, ULAs e a lógica de controle, foi realizado utilizando a ferramenta de simulação **Logisim Evolution**.

## 💻 2. Ferramentas Utilizadas

* **Logisim Evolution:** Utilizado para o design, implementação e simulação de todos os circuitos lógicos dos processadores.
* **Documentação:** Elaboração de diagramas de datapath, tabelas de sinais de controle e relatórios para documentar as decisões de projeto.

---

## 📜 3. Arquitetura Sagui VLIW

A versão VLIW (Very Long Instruction Word) da arquitetura Sagui foi projetada para explorar o paralelismo em nível de instrução, executando múltiplas operações independentes em um único ciclo de clock.

### Visão Geral
* **Palavra de Instrução:** 32 bits, dividida em 4 "lanes" ou slots de 8 bits cada.
* **Slots de Operação:**
    * 1 slot para operações de **Dados** (Load/Store/Move).
    * 1 slot para operações de **Controle de Fluxo** (Branch/Jump).
    * 2 slots para operações de **ULA** (Aritméticas/Lógicas).
* **Dependências:** O modelo assume que um compilador inteligente seria responsável por agrupar instruções independentes, evitando hazards de dados na mesma palavra de instrução.
* **Arquitetura de Memória:** Harvard, com memórias separadas para dados e instruções, dado que o tamanho da instrução (32 bits) é maior que o do dado (8 bits).

*(Consulte o relatório em PDF para os diagramas visuais do datapath e da ULA).*

### Formato das Instruções (8 bits)

As operações dentro dos slots de 32 bits seguem dois formatos principais:

* **Tipo R (Registrador):**
    ```
    | 7:4 (Op) | 3:2 (Ra) | 1:0 (Rb) |
    ```
* **Tipo I (Imediato):**
    ```
    | 7:4 (Op) | 3:0 (Imm) |
    ```

### Set de Instruções (ISA VLIW)

| Categoria | Opcode | Mnemônico | Operação                                |
| :-------- | :----- | :-------- | :-------------------------------------- |
| **Controle** | `0000` | `brzr`    | `if (R[ra] == 0) PC = R[rb]`          |
|           | `0001` | `brzi`    | `if (R[0] == 0) PC = PC + Imm`        |
|           | `0010` | `jr`      | `PC = R[rb]`                            |
| **Dados** | `0100` | `ld`      | `R[ra] = M[R[rb]]`                      |
|           | `0101` | `st`      | `M[R[rb]] = R[ra]`                      |
|           | `0110` | `movh`    | `R[0] = {Imm, R[0](3:0)}`               |
|           | `0111` | `movl`    | `R[0] = {R[0](7:4), Imm}`               |
| **Aritmética** | `1000` | `add`     | `R[ra] = R[ra] + R[rb]`                 |
|           | `1001` | `sub`     | `R[ra] = R[ra] - R[rb]`                 |
| **Lógica** | `1011` | `or`      | `R[ra] = R[ra] \| R[rb]`                |
|           | `1100` | `not`     | `R[ra] = !R[rb]`                        |
|           | `1101` | `slr`     | `R[ra] = R[ra] << R[rb]`                |
|           | `1110` | `srr`     | `R[ra] = R[ra] >> R[rb]`                |
| **NOP** | `1111` | `nop`     | No Operation                            |

### ✨ Instruções Adicionais Implementadas (VLIW)

Para aumentar a funcionalidade e facilitar a programação, foram criadas as seguintes instruções:

* **`svpc` (Save PC):** Salva o valor atual do Program Counter (PC) em um registrador. Essencial para calcular endereços de retorno e saltos relativos de forma eficiente.
* **`and` (Logical AND):** Executa a operação lógica AND entre dois registradores, complementando o conjunto de instruções lógicas da ULA.

---

## 🚀 4. Arquitetura Sagui Vetorial

A versão Vetorial explora o paralelismo em nível de dados (SIMD - Single Instruction, Multiple Data), onde uma única instrução opera sobre um vetor de dados simultaneamente através de múltiplos Elementos de Processamento (PEs).

### Visão Geral
* **Estrutura:** Composta por uma unidade escalar (Scalar Processing Element - SPE) e quatro unidades vetoriais (Vector Processing Elements - VPEs).
* **Modo de Operação:** A cada ciclo, ou a unidade escalar atua ou as unidades vetoriais atuam, mas nunca ambas ao mesmo tempo. A instrução determina qual parte do processador fica ativa.
* **Seleção de Bloco:** Instruções com prefixo `s.` (ex: `s.add`) ativam o SPE, enquanto a parte vetorial recebe um NOP. Instruções com prefixo `v.` (ex: `v.add`) ativam os VPEs.

*(Consulte o relatório em PDF para os diagramas visuais do datapath e da ULA).*

### Formato das Instruções (8 bits)
O formato das instruções é idêntico ao da VLIW, sendo do Tipo R ou Tipo I.

### Set de Instruções (ISA Vetorial)

#### Instruções Escalares (SPE)
| Opcode | Mnemônico | Operação                        |
| :----- | :-------- | :------------------------------ |
| `0000` | `s.ld`    | `SR[ra] = M[SR[rb]]`            |
| `0001` | `s.st`    | `M[SR[rb]] = SR[ra]`            |
| `0010` | `s.movh`  | Move High para registrador escalar |
| `0011` | `s.movl`  | Move Low para registrador escalar  |
| `0100` | `s.add`   | `SR[ra] = SR[ra] + SR[rb]`      |
| `0101` | `s.sub`   | `SR[ra] = SR[ra] - SR[rb]`      |
| `0110` | `s.and`   | `SR[ra] = SR[ra] & SR[rb]`      |
| `0111` | `s.brzr`  | `if (SR[ra] == 0) PC = SR[rb]`  |

#### Instruções Vetoriais (VPE)
| Opcode | Mnemônico | Operação                          |
| :----- | :-------- | :-------------------------------- |
| `1000` | `v.ld`    | `VR[ra] = M[VR[rb]]` (em paralelo) |
| `1001` | `v.st`    | `M[VR[rb]] = VR[ra]` (em paralelo) |
| `1010` | `v.movh`  | Move High para registradores vetoriais |
| `1011` | `v.movl`  | Move Low para registradores vetoriais  |
| `1100` | `v.add`   | `VR[ra] = VR[ra] + VR[rb]`         |
| `1101` | `v.sub`   | `VR[ra] = VR[ra] - VR[rb]`         |

### ✨ Instruções Adicionais Implementadas (Vetorial)

* **`s.sll` (Scalar Shift Logical Left):** Instrução do tipo R que desloca os bits do registrador `r[a]` para a esquerda `r[b]` vezes.
* **`sv.lr` (Scalar to Vectorial Load Register):** Carrega o conteúdo de um registrador escalar (`r[b]`) para um registrador vetorial (`r[a]`), facilitando a comunicação e inicialização de dados entre as unidades.

---

## 🛠️ 5. Programas de Teste em Assembly

Para validar ambas as arquiteturas, foi desenvolvido um programa de teste que realiza a soma de dois vetores de 12 posições (`R = A + B`), com `A = {0..11}` e `B = {20..31}`. Os códigos demonstram o uso de laços, manipulação de memória e as instruções específicas de cada processador.

### Código de Teste (VLIW)
```assembly
movl 15 ;; primeiro loop zera três espaços a mais (indica o fim mais claramente)
add r2 r0
brzr r2 r3 ;; COMEÇO PRIMEIRO LOOP (ZERA espaço de memória)
movl 1
sub r2 r0 ;; i--
st r1 r2 ;; zera na posição do primeiro vetor
movl 12
add r2 r0 ;; desloca 12
st r1 r2 ;; zera na posição do segundo vetor
add r2 r0 ;; desloca 12
st r1 r2 ;; zera na posição do terceiro vetor
sub r2 r0
sub r2 r0 ;; retira deslocamento
movl 2 ;; endereço de retorno para jr
svpc r3 r3 ;; salva PC para retorno - 2
add r3 r0
add r3 r0
jr r0, r0 ;; FIM PRIMEIRO LOOP
movl 12
sub r1 r1
sub r3 r3
add r2 r0 ;; reg reiniciados
movh 0 ;; COMEÇO SEGUNDO LOOP (carrega A e B)
movl 2 ;; ajusta PC de branch em r3
add r3 r0
brzr r2 r3
movl 1
sub r2 r0
st r2 r2 ;; carrega em A
movl 12 ;; desloca
add r1 r2
add r2 r0
movl 4
movh 1
add r1 r0
st r1 r2 ;; carrega em B
sub r1 r1
movh 0
movl 12
sub r2 r0
movl 4
movh 1
svpc r3 r3
jr r0, r0 ;; FIM SEGUNDO LOOP
movl 0
movl 12
sub r1 r1
sub r3 r3
add r2 r0 ;; reg reiniciados
movh 0 ;; COMEÇO TERCEIRO LOOP (soma A e B)
movl 2
add r3 r0
brzr r2 r3
sub r3 r3
movl 1
sub r2 r0
ld r3 r2 ;; recebe valor de A[i]
movl 12
add r2 r0
ld r1 r2 ;; recebe valor de B[i]
add r1 r3 ;; A[i] + B[i]
add r2 r0
st r1 r2 ;; guarda no terceiro vetor
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
```

### Código de Teste (Vetorial)
```assembly
v.add r2, r0 ; vr[r2] = {0, 1, 2, 3}
s.movl 4   ; sr[r1] = 4
s.add r2, r1 ; sr[r2] = 4

init_A:
    s.movl 3
    s.sub r3, r1
    s.movh 1
    s.movl 4   ; sr[r1] = 20
    s.brzr r3, r1 ; se r3 == 3 pula para o init_B
    s.movh 0
    s.movl 3   ; manipulacao do laco
    s.add r3, r1 ; sr[r3] recupera seu valor original
    v.st r2, r3
    s.movh 0
    s.movl 1   ; sr[r1] = 1
    s.add r3, r1 ; sr[r3] = sr[r3] + 1
    sv.lr r3, r3 ; vr[r3] = sr[r3]
    sv.lr r1, r2
    v.add r2, r1 ; vr[r2] = vr[r2] + 4
    s.movl 3
    s.brzr r0, r1 ; pula para init_A

init_B:
    v.movh 0
    v.movl 8
    v.add r2, r1  ; vr[r2] = {20, 21, 22, 23}
    s.movh 0
    s.movl 3
    s.add r3, r1 ; sr[r3] = 3
    s.movh 0
    s.movl 6
    s.sub r3, r1
    s.movh 3
    s.movl 0
    s.brzr r3, r1 ; se r3 == 6 pula para o soma_AB
    s.movh 0
    s.movl 6   ; manipulacao do laco
    s.add r3, r1 ; sr[r3] recupera seu valor original
    v.st r2, r3
    s.movh 0
    s.movl 1   ; sr[r1] = 1
    s.add r3, r1 ; sr[r3] = sr[r3] + 1
    sv.lr r3, r3 ; vr[r3] = sr[r3]
    sv.lr r1, r2
    v.add r2, r1 ; vr[r2] = vr[r2] + 4
    s.movh 1
    s.movl 10
    s.brzr r0, r1 ; pula para init_B

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
    s.brzr r0, r1 ; HALT
```

## 📂 6. Estrutura do Repositório

* **/logisim-projects:** Contém os arquivos `.circ` com a implementação dos processadores Vetorial e VLIW.
* **/report:** Contém o relatório final do projeto em formato PDF, com todos os diagramas, tabelas de controle e detalhes da implementação.
* **README.md:** Este arquivo.

---