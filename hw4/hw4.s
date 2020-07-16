.data
input: .space 400 #100 * 4byte = 400 bytes: max number of arguments
bArray: .space 400 #array of lengths
.text
	li $v0,5
	syscall
	move $t0, $v0 #t0 now contains number of elements
	
	li $s2, 4 #save word size
	li $t2, 1 #$t2 will contain result: maximal length
	move $t1, $t0 #store number of elements here
	la $t4, input #store address of the beginning of input
	la $t5, bArray #store address of the beginning of aArray
	li $t7, 0 #another iterator
	readInput:
		beqz $t1, exit
		li $v0,5
		syscall #read next number
		move $t3, $v0 #$t3 now contains next number
		sb $t3, 0($t4) #move newly read number to input array:
		move $t8, $t7 #copy number of elems on the left to be iterated.
		li $s3, 0
		sb $t2, 0($t5) #load 1 on first index
		bnez $t7, iterLeft
		next:
		addi $t4, $t4, 4 # move to next elem (integer needs word size (4 bytes))
		addi $t5, $t5, 4 # "---"
		subi $t1,$t1,1 #go to next number
		addi $t7, $t7, 1 #go to next number (another interator for simplicity)
	j readInput
	
	iterLeft:
	beqz $t8, next
	subi $t8, $t8, 1 #move to next iteration to the left
	la $t0, input
	mult $s2, $t8
	mflo $s0
	add $t0, $t0, $s0 #$t0 is address of element thet we should compare
	lb $s0, 0($t0) #load current number to $s0
	blt $s0, $t3, possibleUpdate	#!!!!!!!!! aqamdea shecdoma
	j iterLeft #if did not jump to possibleUpdate, check next number
	nextIterLeft:
	addi $s3, $s3, 1
	sb $s3, 0($t5) #load $s3+1 to be bArray's current value
	ble $s3, $t2, nope #update final result if possible
	move $t2, $s3
	nope:
	j iterLeft
	
	possibleUpdate: #update our max if possible
	la $t0, bArray
	mult $s2, $t8
	mflo $s1
	add $t0, $t0, $s1
	lb $s1, 0($t0) #bArray's corresponding value for $t8-th elem of input array
	blt $s1, $s3, nope
	move $s3, $s1
	j nextIterLeft
	
exit:
move $a0,$t2
li $v0,1
syscall #print $t2 
li $v0, 10
syscall #exit




