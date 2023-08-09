; Maria Paula Medeiros G. Miguel - 20180064191
; Arquitetura Avancada para Computacao - 2023.1
; Laboratorio 01 - Questao 01: Fibonacci

name "fibonacci"

org 100h
     .DATA                  ; Reserva armazenamento para dado
        NUM  DW ?           ; Double World (16 bits) sem valor (c)
        NUM1 DW ?           ; Double World (16 bits) sem valor (a)                    
        lbk    db 13,10,'$' ; (0Dh=13) - PULAR / (0Ah=10) - INICIO
        numstr db '$$$$$$'  ; Reservando o espaco para 6 caracteres
        inicio db 'Sequencia Fibonacci ate 16 bits:', 13,10,'$' 

     .CODE                  ; Inicio do programa: linhas seguintes sao instrucoes do programa
     MAIN PROC              ; Inicio da execucao do programa 
          MOV AX,@DATA
          MOV DS,AX         ; Registrador de 16 bits que armazena o comeco do endereco do segmento de dado

          MOV NUM,  0       ; c = 0 
          MOV NUM1, 1       ; a = 1
               
          MOV AH, 9 
          MOV DX, offset inicio
          INT 21H
          
     START: 

         CMP NUM, 65535     ; Se NUM <= 2^(16) - 1 (65535) ... (compara)
         JBE PRINT          ; ... (JBE = jump if bellow or equal)          
         
         JMP END_           ; (JMP = jump)
         
;------------------------------------------
     PRINT:
     ; Converte o numero para string:
         mov  si, offset numstr
         mov  ax, NUM
         call number2string ; Retorna uma string do numero

     ; Printa a String:
         mov  ah, 9
         mov  dx, offset numstr
         int 21h     

     ; Printa o line break:
         mov  ah, 9
         mov  dx, offset lbk
         int 21h                    
         
         mov DX, NUM        ; 
         cmp NUM1, dx       ; Se NUM1 < NUM ... (compara)
         jb END_            ; ... (JB = jump if bellow)
                
     ; Logica Fibonacci:
         xor cx, cx            
         xor bx, bx            
         mov cx   , NUM     ; cx = c (NUM)
         mov bx   , NUM1    ; bx = a (NUM1)
         mov NUM  , bx      ; c = a
         add NUM1 , cx      ; a = a + c 
         
         jmp START          ; vai pro label start (o que permite que o loop aconteca)
         
     END_:
         mov Ax,4C00H
         int 21h
         MAIN ENDP          ; final da funcao principal

;------------------------------------------
; CONVERTE UM NUMERO PARA STRING
;
; Algoritmo : 
; Extrai os digitos um por um e armazena eles na pilha,
; depois extrai na ordem inversa para construir a string.
;
; parametros: 
; AX = numero a ser convertido
; SI = ponteiro onde a string sera armazenada

number2string PROC 
  call dollars              ; preenche a string com '$' (veja mais abaixo)
  mov  bx, 10               ; os digitos sao extraidos dividindo por 10
  mov  cx, 0                ; contador (c)
l:       
  mov  dx, 0                ; necessario para dividir por BX
  div  bx                   ; DX:AX / 10 = AX:quociente DX:resto
  push dx                   ; preserva o digito extraido pra depois
  inc  cx                   ; c++
  cmp  ax, 0                ; Se o numero e diferente de zero ... (compara)
  jne  l                    ; ... (JNE = jump if not equal)
   
;NOW RETRIEVE PUSHED DIGITS.
cycle2:  
  pop  dx        
  add  dl, 48               ; converte o digito para caractere (HEX)
  mov  [ si ], dl
  inc  si
  loop cycle2  

  ret
number2string ENDP       

;------------------------------------------
; PREENCHE VARIAVEL COM '$'
;
; Usado para converter numeros para string,
; porque a string vai ser printada.
;
; parametros:
; SI = ponteiro onde a string sera armazenada

dollars PROC                  
  mov  cx, 5
  mov  di, offset numstr
dollars_loop:      
  mov  bl, '$'
  mov  [ di ], bl
  inc  di
  loop dollars_loop

  ret
dollars ENDP  

;------------------------------------------

 END MAIN               ; finaliza o codigo do programa