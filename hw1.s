.data 
newline: .asciiz "\n"
whitespace: .asciiz " "
.text 
	main:
	li $v0,5
	syscall
	move $t0,$v0 
	
	li $t5,0 #counter
	li $t2,2 #ეგრევე 2ს ვერ გამოვიყენებდი ხომ მაგალითად გამრავლების დროს?
	li $t3,3 
	
	loop:
	beq $t0,1 fin #if t0 is 1, jump to fin
	add $t5,$t5,1 #i=i+1
	div $t0,$t2 #divide val by 2
	mfhi $t1 #load remainder in $t0 register
	beqz $t1,even #if $t1 = 0
	# if this part start executin, $t0 contains odd integer:
	mult $t0,$t3 #multiply by 3
	mflo $t0 #move (lo or hi) value to t0 register
	add $t0,$t0,1 #val=val+1
	li $v0,1 #display 
	move $a0,$t0
	syscall	
		#print whitespace (ascii code 32)
		li $v0,4 #newline
		la $a0,whitespace #aq move-s ratom ver vaketeb?
		syscall
	j loop #begin loop again
	
	even:
	mflo $t0 #move quantitiy in Lo to register val and display
	li $v0,1
	move $a0,$t0
	syscall
		#print whitespace (ascii code 32)
		li $v0,4 #newline
		la $a0,whitespace
		syscall
	j loop
	
	fin:
	li $v0,4 #newline
	la $a0,newline
	syscall
	li $v0,1 #print out count of dispayed numbers
	move $a0,$t5
	syscall
	
	li $v0, 10 #exit
	syscall	
