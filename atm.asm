include "emu8086.inc"
DATA SEGMENT
ac dw ?
amt dw 1000,1000,1000,1000,1000
dep dw ?
wd dw ?
cho dw ?
pin dw ?
k dw ?   
i dw ?
j dw ?
b dw ?
tr dw 1
count dw 3 
count2 dw 3
rem db ?
acnos dw 4321,8642,1963,2184,1015
pno dw 1234,2468,3691,4812,5101
msg21 db '****$'                     
msg0 db 10,13,'ENTER YOUR ACCOUNT NUMBER    :$'
msg1 db 10,13, 'ENTER YOUR PIN NUMBER   :$'
msg2 db 10,13, 'ENTER VALID PIN     :$'
msg3 db 10,13, '**********WELCOME TO ATM SERVICE***********$'
msg4 db 10,13,'1.CHECK BALANCE$'
msg5 db 10,13,'2.WITHDRAW CASH$'
msg6 db 10,13,'3.DEPOSIT CASH$'
msg7 db 10,13,'4.CANCEL TRANSACTION $'
msg8 db 10,13, '**************************$'
msg9 db 10,13,'ENTER YOUR CHOICE    :$'
msg10 db 10,13,'YOUR BALANCE IS :$'
msg11 db 10,13,'ENTER THE AMOUNT TO WITHDRAW    :$'
msg12 db 10,13,'PLEASE ENTER THE AMOUNT IN MULTIPLES OF 100:$'
msg13 db 10,13,'INSUFFICIENT BALANCE!$'    
msg14 db 10,13,'PLEASE COLLECT CASH$'
msg15 db 10,13,'YOUR CURRENT BALANCE IS :$'
msg16 db 10,13,'ENTER THE AMOUNT TO DEPOSIT :$'
msg17 db 10,13,'THANK YOU FOR USING OUR ATM SERVICE$'
msg18 db 10,13,'INVALID CHOICE$'
msg19 db 10,13,'DO YOU WISH TO HAVE ANOTHER TRANSACTION?(1/0)$'
msg20 db 10,13,'---------------------------------------------------------------$'
DATA ENDS

CODE SEGMENT
START:

play:
ASSUME CS:CODE,DS:DATA

mov ax,DATA
mov ds,ax
lea dx,msg3
mov ah,9
int 21h  

printn
lea dx,msg0               
mov ah,9
int 21h
             
INPUT:                      
call scan_num
mov ac,cx  
mov bx,ac
mov si,0000h
mov cx,5

COM:
mov ax,acnos[si]
cmp ax,bx
je store
add si,2
loop COM 
mov bl,00h
mov ax,4C00h
int 21h   

store:
mov i,si
mov si,i
jmp epin
 
epin:
printn
printn
print "ENTER PIN    :"
printn       
call scan_num  
lea dx,msg21
mov ah,9
int 21h 



getp:
mov pin,cx
mov bx,pin
mov si,0000h
mov cx,5 

COM1:
mov ax,pno[si]
cmp ax,bx
je print
add si,2
loop COM1




printn
printn 
print "INVALID PIN!"
dec count 
cmp count,0
je error
jmp epin

error:
printn
print "OOPS!! TOO MANY INVALID ATTEMPTS!!" 
printn
print "YOUR ACCOUNT HAS BEEN LOCKED!!"  
jmp quit
      
print1:
printn  
aty:   
printn
print "SELECT ACCOUNT TYPE"
printn
print "1--->SAVINGS ACCOUNT (SB)"
printn
print "2--->CURRENT ACCOUNT (CB)"
printn
call scan_num
xor cx,cx
printn
jmp dispmen

print:
mov j,si
mov ax,j
mov ax,i 
mov bx,j
cmp ax,bx
je print1
printn 
printn
print "INVALID PIN!"
dec count
cmp count,0
je error 
jmp epin

chkbal:
xor ax,ax 
mov ax,amt[si]
mov b,ax    
printn 
printn
print "DO YOU WANT TO PRINT THE RECEIPT :"
printn
print "ENTER 1 IF YES"  
printn
print "ENTER 0 IF NO"
printn
call scan_num
mov ax,tr
cmp cx,ax
je receipt
jmp ins1 

withdraw: 
printn     
printn
print "ENTER AMOUNT TO BE WITHDRAWN    :"
call scan_num
mov wd,cx
mov ax,cx
mov bl,100
div bl  
mov rem,ah
mov al,rem
cmp ax,0
jne mult 
mov ax,amt[si]
mov k,ax 
mov cx,wd
sub ax,cx
mov amt[si],ax
printn
mov ax,amt[si]
cmp amt[si],500
jl ins 
xor bx,bx
xor cx,cx

printn  
printn
print "PLEASE COLLECT CASH"
printn
printn
print "YOUR BALANCE IS  :"
call print_num 
xor ax,ax 
jmp trans  

deposit:
printn       
printn
print "ENTER THE AMOUNT TO BE DEPOSITED    :"  
call scan_num 
printn
mov dep,cx 
cmp dep,10000
jg mult1
mov ax,amt[si]
add ax,cx
mov amt[si],ax
printn     
printn
print "YOUR BALANCE IS  :"
call print_num
xor ax,ax
xor cx,cx
jmp trans

mult:
printn
printn
lea dx,msg12
mov ah,9
int 21h 
jmp withdraw  

mult1:
printn
printn
print "DEPOSIT OF AMOUNT GREATER THAN  10000 IS NOT POSSIBLE"
jmp deposit
            
ins:
printn
printn
print "INSUFFICIENT BALANCE!"
mov ax,k 
printn
print "YOUR BALANCE IS  :"
call print_num
mov amt[si],ax
jmp withdraw 

ins1:   
mov ax,b
printn
print "YOUR BALANCE IS  :"
call print_num
jmp trans

dispmen:
printn
print "***********MENU***********"
lea dx,msg4
mov ah,9
int 21h    
lea dx,msg5
mov ah,9
int 21h    
lea dx,msg6
mov ah,9
int 21h    
lea dx,msg7
mov ah,9
int 21h    
lea dx,msg8
mov ah,9
int 21h 
lea dx,msg9
mov ah,9
int 21h 
call scan_num
mov cho,cx 

cmp cho,1
je chkbal

cmp cho,2
je withdraw 

cmp cho,3
je deposit

cmp cho,4
je quit  

cmp cho,5
jge incho

incho:
printn 
printn
print "INVALID CHOICE!"
print "TRY AGAIN"
jmp dispmen

label1:
printn
print "YOU HAVE REACHED THE MAXIMUM NUMBER OF TRANSACTIONS PER DAY"
mov ah,0
int 10h
jmp play

trans:
dec count2
cmp count2,0
jz label1  
lea dx,msg19
mov ah,9
int 21h  

printn 
print "ENTER 1 IF YES" 
printn 
print "ENTER 0 IF NO"
printn
call scan_num
mov ax,tr
cmp cx,ax
je dispmen 
lea dx,msg17
mov ah,9
int 21h
mov ah,0
int 10h
jmp play   
quit:
lea dx,msg17
mov ah,9
int 21h
mov ah,0
int 10h
jmp play

receipt:

printn
lea dx,msg20
mov ah,9
int 21h

printn
DAY:
MOV AH,2AH    
INT 21H
MOV AL,DL     
AAM
MOV BX,AX

DIS1: 
MOV DL,BH      
ADD DL,30H     
MOV AH,02H     
INT 21H
MOV DL,BL      
ADD DL,30H     
MOV AH,02H     
INT 21H 

MOV DL,'/'
MOV AH,02H    
INT 21H

MONTH:
MOV AH,2AH    
INT 21H
MOV AL,DH     
AAM
MOV BX,AX

DIS2: 
MOV DL,BH      
ADD DL,30H     
MOV AH,02H     
INT 21H
MOV DL,BL      
ADD DL,30H     
MOV AH,02H     
INT 21H 
 
MOV DL,'/'    
MOV AH,02H
INT 21H

YEAR:
MOV AH,2AH    
INT 21H
ADD CX,0F830H 
MOV AX,CX     
AAM
MOV BX,AX
 
DIS3: 
MOV DL,BH      
ADD DL,30H     
MOV AH,02H     
INT 21H
MOV DL,BL      
ADD DL,30H     
MOV AH,02H     
INT 21H 
   
print "    "
HOUR:
MOV AH,2CH   
INT 21H
MOV AL,CH     
AAM
MOV BX,AX

DISP1:
MOV DL,BH     
ADD DL,30H     
MOV AH,02H  
INT 21H
MOV DL,BL       
ADD DL,30H     
MOV AH,02H     
INT 21H
  
MOV DL,':'
MOV AH,02H    
INT 21H

MINUTES:
MOV AH,2CH   
INT 21H
MOV AL,CL     
AAM
MOV BX,AX

DISP2:
MOV DL,BH     
ADD DL,30H     
MOV AH,02H  
INT 21H
MOV DL,BL       
ADD DL,30H     
MOV AH,02H     
INT 21H
  
MOV DL,':'   
MOV AH,02H
INT 21H

Seconds:
MOV AH,2CH    
INT 21H
MOV AL,DH    
AAM
MOV BX,AX

DISP3:
MOV DL,BH     
ADD DL,30H     
MOV AH,02H  
INT 21H
MOV DL,BL       
ADD DL,30H     
MOV AH,02H     
INT 21H 

MOV AL,CH
CMP AL,12
JNGE am
print " PM"
JMP place
am:
print " AM"

place:
print "     "
print "COIMBATORE"

mov ax,b
printn
printn
print "YOUR BALANCE IS  :"
call print_num

printn
printn
print "                  "
print "THANK YOU!!!"
printn
printn
lea dx,msg20
mov ah,9
int 21h
jmp trans
 
CODE ENDS      
DEFINE_PRINT_NUM 
DEFINE_PRINT_NUM_UNS
DEFINE_SCAN_NUM
END START