;
; Block 5 starter: classify a number, then count up to it.
;
; This assembles and runs as it stands. It prompts, reads a number, and stops.
; The branching and the loop are yours.
;
; Rename it first:
;
;       cp b5_starter.asm classify.asm
;

%include "asm_io.inc"

segment .data
prompt      db  "Enter an integer: ", 0
neg_msg     db  "negative", 0
zero_msg    db  "zero", 0
pos_msg     db  "positive", 0
sum_msg     db  "sum: ", 0
none_msg    db  "nothing to count", 0

segment .bss

segment .text
        global  _asm_main
_asm_main:
        enter   0,0
        pusha

        mov     eax, prompt
        call    print_string
        call    read_int
        mov     esi, eax                ; esi holds the number

        ;
        ; TODO 1: the three-way branch.
        ;
        ; cmp esi against 0 and jump to .negative, .zero, or fall through into
        ; the positive case. Use the SIGNED jump family, jl and je and jg. The
        ; unsigned ones read every negative number as about four billion.
        ;
        ; Each case prints its word and a newline.
        ;

                cmp esi, 0
                jl .negative
                je .zero
        ; if esi > 0
                mov eax, pos_msg
                call print_string
                call print_nl
                jmp .end_if
        ; if esi < 0
        .negative:
                mov eax, neg_msg
                call print_string
                call print_nl
                jmp .none
        ; if esi == 0
        .zero:
                mov eax, zero_msg
                call print_string
                call print_nl
                jmp .none
        .end_if:


        ;
        ; TODO 2: the counting loop, for the positive case only.
        ;
        ; Print every integer from 1 up to esi on one line, separated by
        ; spaces, and add each one to a running total as you go.
        ;
        ; Two things to decide before you write it.
        ;
        ; Which register survives the loop? print_int and print_char give you
        ; back every register you had, so a counter in ecx and a total in edi
        ; both survive the calls. Only eax is spoken for, because that is how
        ; you hand a value to a routine.
        ;
        ; And where does the space go? Printing one after every number leaves
        ; a trailing space at the end of the line. You cannot see it, and
        ; check compares bytes rather than looks. Printing one BEFORE every
        ; number except the first avoids the problem.
        ;
        ; To print a single space:
        ;
        ;       mov     eax, ' '
        ;       call    print_char
        ;

        ; initialize total sum
        mov ebx, 0

                ; initialize counter
                mov ecx, 1
        .for_top:
                ; for (i = 1; i <= esi; i++)
                cmp ecx, esi
                jg .for_end

                ; add to total
                add ebx, ecx

                ; skip space if it's the first
                cmp ecx, 1
                je .skip_space
                ; print space delimiter
                mov eax, ' '
                call print_char
                .skip_space:

                ; print counter
                mov eax, ecx
                call print_int

                ; increment counter
                inc ecx

                ; loop
                jmp .for_top
        .for_end:
                call print_nl

        ;
        ; TODO 3: print sum_msg followed by the total, then a newline.
        ;

        ; print total sum
        mov eax, sum_msg
        call print_string
        mov eax, ebx
        call print_int
        call print_nl

        ; skip to end
        jmp .end

        ;
        ; TODO 4: the negative and zero cases print none_msg instead of
        ; counting anything. Remember that a true branch needs an unconditional
        ; jmp at its end, or it falls straight into the branch below it.
        ;
        .none:
                mov eax, none_msg
                call print_string
                jmp .end

        .end:

        popa
        mov     eax, 0
        leave
        ret
