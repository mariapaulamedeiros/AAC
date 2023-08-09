; Maria Paula Medeiros G. Miguel - 20180064191
; Arquitetura Avancada para Computacao - 2023.1
; Laboratorio 01 - Questao 02: Ordenar

name "ordenar"

org 100h

.DATA                    ; Reserva armazenamento para dado
    V_A DW ?             ; Double World (16 bits) sem valor (A)
    V_B DW ?             ; Double World (16 bits) sem valor (B)
    V_C DW ?             ; Double World (16 bits) sem valor (C)
    lbk    db 13,10,'$'  ; (0Dh=13) - PULAR / (0Ah=10) - INICIO
    ; mensagens que serao printadas:
    msg    db "Digite um valor de 0 a 9: ", 0Dh,0Ah, "$"
    msg_1  db "Ax = ", "$"
    msg_2  db " < Bx = ", "$"
    msg_3  db " < Cx = ", "$"
    
.CODE                    ; Inicio do programa: linhas seguintes sao instrucoes do programa
MAIN PROC                ; Inicio da execucao do programa
    MOV AX,@DATA
    MOV DS, AX           ; Registrador de 16 bits que armazena o comeco do endereco do segmento de dado
    
    MOV V_A, 0           
    MOV V_B, 0           
    MOV V_C, 0
    
    JMP valor_A          ; Recebe o valor de A            

;============================
valor_A:

; Printa a mensagem que solicita o valor:   
mov dx, offset msg       
mov ah, 9
int 21h

; Recebe o caractere que do usuario: 
mov ax, 0
int 16h

mov V_A, ax              ; Armazena o valor em A

; Printa o caractere:
mov ah, 0eh
int 10h    

jmp valor_B              ; Recebe o valor de B

;============================
valor_B: 
; Printa o Line Break:
mov dx, offset lbk
mov ah, 9
int 21h  

; Printa a mensagem que solicita o valor:
mov dx, offset msg
mov ah, 9
int 21h 

; Recebe o caractere que do usuario:
mov ax, 0
int 16h

mov V_B, ax              ; Armazena o valor em B

; Printa o caractere:
mov ah, 0eh
int 10h

jmp valor_C  

;============================
valor_C:  
; Printa o Line Break:
mov dx, offset lbk
mov ah, 9
int 21h  

; Printa a mensagem que solicita o valor:
mov dx, offset msg
mov ah, 9
int 21h 

; Recebe o caractere que do usuario:
mov ax, 0
int 16h 

mov V_C, ax              ; Armazena o valor em C

; Printa o caractere:
mov ah, 0eh
int 10h

jmp verifica             ; Verifica os valores

;============================
verifica:
mov ax, V_A              ; AX = A
mov bx, V_B              ; BX = B
mov cx, V_C              ; CX = C
            
; os valores informados no input sao armazenados no al, bl, cl
; os valores de ah, bh, ch sao aleatorios, por isso
; a comparacao foi feita usando al, bl, cl

verifica_ab:
cmp al, bl ; Se AX > BX
JG troca_ab

verifica_bc:
cmp bl, cl ; Se BX > CX
JG troca_bc

jmp apresentar_          ; Printa depois das trocas

;============================

troca_ab:
mov V_A, bx
mov V_B, ax
mov ax, V_A
mov bx, V_B

jmp verifica_bc

;============================
troca_bc:
mov V_C, bx
mov V_B, cx
mov cx, V_C
mov bx, V_B

jmp verifica_ab

;============================
apresentar_:
; Printa o Line Break:
mov dx, offset lbk
mov ah, 9
int 21h

; Printa o "Ax = ":
mov dx, offset msg_1
mov ah, 9
int 21h 

; Printa o A:
mov ah, 6
mov dx, V_A
int 21h         

; Printa o " < Bx = ":
mov dx, offset msg_2
mov ah, 9
int 21h

; Printa o B:
mov ah, 6
mov dx, V_B
int 21h       

; Printa o " < Cx = ":
mov dx, offset msg_3
mov ah, 9
int 21h 

; Printa o C:
mov ah, 6
mov dx, V_C
int 21h       
  
;============================ 
exit:
ret 

END_:
  MOV Ax,4C00H
  int 21h
  MAIN ENDP

ret