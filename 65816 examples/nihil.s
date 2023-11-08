; -----------------------------------------------------------------------------
;   File: nihil.s
;   Description: Your very first SNES game!
; -----------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816                           ; this is 65816 code
.i16                            ; X and Y registers are 16 bit
.a8                             ; A register is 8 bit
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   This is were the magic happens
;-------------------------------------------------------------------------------
.segment "CODE"
.proc   ResetHandler            ; program entry point
        sei                     ; disable interrupts
        clc                     ; clear the carry flag...
        xce                     ; ...and switch to native mode

        lda #$81                ; enable...
        sta $4200               ; ...non-maskable interrupt

        ; Increment the value of X twice
        ;inx
        ;inx

        jmp GameLoop            ; initialisation done, jump to game loop
.endproc

.proc   GameLoop                ; The main game loop
        
        ;-------------------- test -----------
        ;inx
        ;inx

        ;lda #100

        ;ERROR ldy #0 ERROR

        ;iny
        ;iny

        ;jmp compare
        ;jmp simpleAddition
        jmp someSimpleGameLogic

        
        jmp GameLoop                   ; jump to beginning of main game loop
.endproc

compare:
    ; simple example for comparing two values
    clc                 ; clear the carry flag
    lda #$80            ; load the value $80/128 into A
    cmp #$40	        ; compare A to $40/64, this will set the C(arry) flag since $80 >= $40
    bcs GreaterThan     ; if the C(arry) flag is set, jump to GreaterThan label
    
    sta $0001	        ; this code will never be executed
    jmp GameLoop

GreaterThan:
    sta $0002 	        ; store A in memory location A
    jmp GameLoop
    

simpleAddition:
    ; add a number to A and store in in memory
    lda #$20        ; load the value $20/32 into A 
    clc             ; clear the carry flag
    adc #$0a        ; add $0a to A: $20 + $0a = $2a/42
    clc             ; clear the carry flag
    adc $0020       ; add the value at memory location $0020 to the value in A
    jmp GameLoop

someSimpleGameLogic:
    ; We initalize two "variables" with zero and three. 
    ; We will use the memory locations $00:0000 and $00:0001
    ; to store the number of coins and lives.
    lda #$64        ; COINS (in hexa 64 is 100 in decimal) load the A register with zero... 
    sta $0000       ; ...and store in memory at $00:0000
    lda #$03        ; LIVES load the A register with three... 
    sta $0001       ; ...and store in memory at $00:0001

; ...here goes some game code...

; now let's check the number of coins
    lda $0000       ; load the number of coins into the accumulator
    cmp #100        ; compare the number in accumulator to 100
    bcc Done        ; if the number in accumulator is less than 100, jump to done
    lda #$00        ; else, load the accumulator with zero...
    sta $0000       ; ...and reset the coin counter 
    lda $0001       ; next, get the current number of lives...
    clc             ; ...clear the carry flag...
    adc #$01        ; ...and add one to the number in A
    sta $0001       ; store the new number of lives
Done:
    jmp GameLoop

.proc   NMIHandler              ; NMIHandler, called every frame/V-blank
        ;iny
        ;iny

        lda $4210               ; read NMI status
        rti                     ; interrupt done, return to main game loop
.endproc

;-------------------------------------------------------------------------------
;   Interrupt and Reset vectors for the 65816 CPU
;-------------------------------------------------------------------------------
.segment "VECTOR"
; native mode   COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           NMIHandler, $0000,      $0000

.word           $0000, $0000    ; four unused bytes

; emulation m.  COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           $0000 ,     ResetHandler, $0000