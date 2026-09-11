;
; Block 6 starter: compound interest, in whole centavos.
;
; This assembles and runs as it stands. It asks the three questions and then
; stops. The loop and the currency formatting are yours.
;
; Rename it first:
;
;       cp b6_starter.asm interest.asm
;
; The rate and the term are declared in .data below rather than kept in
; registers. Count the values this program has to keep alive at once and you
; will see why: there are more of them than there are registers. Read one back
; with brackets, like this:
;
;       cmp     ecx, [years]
;       mul     dword [rate]
;
; Block 7 is where that notation gets explained properly.
;

%include "asm_io.inc"

segment .data
bal_prompt      db  "Starting balance in centavos: ", 0
rate_prompt     db  "Annual rate as a percent: ", 0
years_prompt    db  "Number of years: ", 0
year_msg        db  "Year ", 0
colon_msg       db  ": ", 0
total_msg       db  "Total interest earned: ", 0
dot             db  ".", 0

rate            dd  0
years           dd  0

segment .bss

segment .text
        global  _asm_main
_asm_main:
        enter   0,0
        pusha

        mov     eax, bal_prompt
        call    print_string
        call    read_int
        mov     esi, eax                ; esi: the running balance, in centavos
        mov     edi, eax                ; edi: what we started with

        mov     eax, rate_prompt
        call    print_string
        call    read_int
        mov     [rate], eax

        mov     eax, years_prompt
        call    print_string
        call    read_int
        mov     [years], eax

        ;
        ; TODO 1: the year loop.
        ;
        ; Run it once per year. Each pass computes
        ;
        ;       interest = balance * rate / 100
        ;
        ; and adds it to the balance. Multiply before you divide, and clear
        ; edx between the mul and the div, because the mul wrote there.
        ;
        ; The balance has to survive every iteration, so keep it somewhere mul
        ; and div will not tread on. esi already holds it. Leave it there.
        ;
        ; Each pass prints year_msg, the year number, colon_msg, the balance
        ; as currency, and a newline.
        ;
                mov     ecx, 1
                ; skip if zero years
                cmp     ecx, [years]
                jg      year_loop_done
        year_loop:
                ; interest = balance * rate / 100
                mov     eax, esi
                mov     ebx, [rate]
                mul     ebx

                mov     edx, 0
                mov     ebx, 100
                div     ebx

                ; balance += interest
                add     esi, eax

                ; print current balance
                mov     eax, year_msg
                call    print_string

                mov     eax, ecx
                call    print_int

                mov     eax, colon_msg
                call    print_string

                mov     eax, esi
                call    print_money
                call    print_nl

                ; ecx ++
                inc     ecx

                cmp     ecx, [years]
                jle     year_loop

        year_loop_done:

        ;
        ; TODO 2: after the loop, print total_msg and the total interest.
        ;
        ; You do not need to have accumulated it. The balance now, minus what
        ; you started with, is the same number.
        ;

        mov     ebx, esi
        sub     ebx, edi
        mov     eax, total_msg
        call    print_string
        mov     eax, ebx
        call    print_money
        call    print_nl

        popa
        mov     eax, 0
        leave
        ret

;
; TODO 3: print_money - print the centavos in eax as pesos and centavos.
;
; One division does most of it. Divide by 100 and the quotient is pesos while
; the remainder, in edx, is centavos. Print the pesos, print the dot, print
; the centavos.
;
; That gets you 1050.0 where you wanted 1050.00, and 1050.5 where you wanted
; 1050.05. Currency wants two digits and print_int has no idea it owes you a
; leading zero, so test the centavos and print one yourself when it is needed.
;
; The pusha and popa here mean the caller gets every register back, which is
; what makes this safe to call in the middle of your loop. Carter's routines
; do the same thing, which is why yours have survived every call so far.
;
print_money:
        enter   0,0
        pusha
        pushf

        ; your code here
        mov     edx, 0
        mov     ebx, 100
        div     ebx
        ; eax = pesos, edx = centavos

        call    print_int

        mov     eax, dot
        call    print_string

        ; check if remainder is one digit
        ; if edx < 10
                cmp     edx, 10
                jge     is_not_one_digit

                mov     eax, 0
                call    print_int

        is_not_one_digit:

        mov     eax, edx
        call    print_int

        popf
        popa
        leave
        ret
