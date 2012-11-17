.section    .start
.global     _start

_start:

	addiu $s7, $0, 0x0
	li $s6, 0x80000000 # DataInReady
	li $s5, 0x80000004 # DataOutValid
	li $s4, 0x80000008 # DataIn
	li $s3, 0x8000000c # DataOut
	li $s1, 0x80000008
	li $s2, 0x1000100F
	addiu $s7, $0, 0x0	
	
	# Test 0 Branching

    li  $v0, 0x12345678
    sw    $v0,184($sp)
    sw    $v0,188($sp)
    lw    $a0,184($sp)
    nop
    bne $v0, $a0, Error
    nop
    li $t0, 0xFFFFFFFF
    bltz $t0, z
    nop
    j Error
    nop

    z: blez $t0, a
    nop
    j Error
    nop

    a: li $t0, 0x00000001
    blez $t0, Error
    nop
    bgtz $t0, b
    nop
    j Error
    nop

    b: bgtz $0, Error
    nop
    bltz $0, Error
    nop
    bgez $0, c
    nop
    j Error
    nop

    c: li $t0, 0xFFFFFFFF
    bgez $t0, Error
    nop 
	
	# Test 1 li

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x12345678
	li $t0, 0x12345678
	bne $t0, $s0, Error
	nop

	# Test 2 sh/lbu

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x00000078
	li $t0, 0x12345678
	sh $t0, 0($s2)
	nop
	lbu $t0, 0($s2)
	nop
	bne $t0, $s0, Error
	nop

	# Test 3 sh/lhu

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x00005678
	li $t0, 0x12345678
	sh $t0, 0($s2)
	nop
	lhu $t0, 0($s2)
	nop
	bne $t0, $s0, Error
	nop

	# Test 4 sh/lw

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x00005678
	li $t0, 0x12345678
	sh $t0, 0($s2)
	nop
	lw $t0, 0($s2)
	nop
	bne $t0, $s0, Error
	nop

	# Test 5 sltiu

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x00000001
	addiu $t0, $0, 0x00000002
	sltiu $t0, $t0, 0xFFFF
	bne $t0, $s0, Error
	nop

	# Test 6 xori

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x0000EDCB
	addiu $t0, $0, 0x00001234
	xori $t0, $t0, 0xFFFF
	bne $t0, $s0, Error
	nop

	# Test 7 sll

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x23456780
	li $t0, 0x12345678
	sll $t0, $t0, 0x4
	bne $t0, $s0, Error
	nop

	# Test 8 srlv

	addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
	li $s0, 0x01234567
	li $t0, 0x12345678
	addiu $t1, $0, 0x00000004
	srlv $t0, $t0, $t1
	bne $t0, $s0, Error

	# Test 9 addiu		
	li $s0, 0x00000020
	addiu $t0, $0, 0x20
	addiu $s7, $s7,0x9 # register to hold the test number (in case of failure)
	bne $t0, $s0, Error

	# Test 10 addu
	li $s0, 0x50
	li $t0, 0x0
	nop
	addu $t0, $t0, $s0
	li $s7, 0xa
	bne $t0, $s0, Error

	# Test 11 subu
	li $s0, 0x30
	li $t1, 0x50
	li $t0, 0x20
	nop
	subu $t0, $t1, $t0
	li $s7, 11
	bne $t0, $s0, Error

	# Test 12 and = 1
	li $s0, 0x1
	li $t0, 0x1
	nop
	li $t1, 0x1
	nop
	and $t0, $t1, $t0
	li $s7, 0xc
	bne $t0, $s0, Error

	# Test 13 and = 0
	li $t0, 0x0000
	nop
	li $t1, 0x1010
	nop
	and $t0, $t1, $t0
	li $s7, 0xd
	bne $t0, $0, Error

	# Test 14 or = 1
	li $s0, 0x1111
	li $t0, 0x0000
	nop
	li $t1, 0x1111
	nop
	or $t0, $t0, $t1
	li $s7, 0xe
	bne $t0, $s0, Error

	# Test 15 or = 0
	li $t0, 0x0000
	li $t1, 0x0000
	nop
	or $t0, $t0, $t1
	li $s7, 0xf
	bne $t0, $0, Error

	# Test 16 XOR
	addiu $s7, $0, 0x10
	addiu $s0, $0, 0x1
	addiu $t0, $0, 0x1
	addiu $t1, $0, 0x0
	xor $t0, $t1, $t0
	bne $t0, $s0, Error

	# Test 21 SLTU = 1
	addiu $s0, $0, 0x1
	addiu $s7, $0, 0x15
	addiu $t0, $0, 0x1
	sltu $t0, $0, $t0
	bne $s0, $t0, Error

	# Test 22 SLTU = 0
	addiu $s7, 0x16
	sltu $t0, $0, $0
	bne $t0, $0, Error

Error:
	# Perhaps write the test number over serial
	sb $s7, 0($s1)

Done:
	# Write success over serial
	sb $0, 0($s1)
