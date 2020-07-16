.data 
input: .space 20 #max length of input
yes: .asciiz "YES\n"
no: .asciiz "NO\n"
.text 
	
main:
#save input string
li $v0, 8
la $a0, input
li $a1, 20
syscall
	

li $t0, 0 #will contain string length
li $t8, 10 #end of string 
strlen:
lb $t1, 0($a0) #load next char
beq $t1, $t8, cont #check if null character is reached
beq $t1, 32, cont #check if space character is reached
addi $a0, $a0, 1 #incremet pointer
addi $t0, $t0, 1 #increment count
j strlen

cont: #checks is string is palindrome
li $t2, 2 #t2 contains 2
div $t0, $t2 #divide strlen by 2
mflo $t4 # $t4 contains strlen/2

#t3 has address of zero-th elem;
la $t3, input #address of input	
addi $t9,$t0,-1 #(strlen-1)
add $t9, $t3, $t9 #address of len-1-th elem

#for t4 times we should check if characters match	
loop:
beqz $t4, printyes #if we checked every character and they matched, it is palindrome
lb $t5, 0($t3) #str[i]
lb $t6, 0($t9) #str[len-1-i]
sub $t7, $t5, $t6 #t7 contains 0 if str[i] and str[len-1-i] are same
bnez $t7, printno
#move to next indexes
addi $t3, $t3, 1 # ->
addi $t9, $t9, -1 # <-
addi $t4,$t4,-1 #move onto next interation
j loop	
	
printyes:
li $v0, 4
la $a0, yes
syscall
j exit
	
printno:
li $v0, 4
la $a0, no
syscall
j exit
	
exit:
li $v0, 10
syscall