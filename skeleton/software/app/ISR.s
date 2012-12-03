start:
	mfc0 $k0, $13
	mfc0 $k1, $12
	andi $k1, $k1, 0xfc00
	and $k0, $k0, $k1
	andi $k1, $k0, 0x8000
	bne $k1, $0, timer_ISR
	andi $k1, $k0, 0x4000
	bne $k1, $0, RTC_ISR
	andi $k1, $k0, 0x0800
	bne $k1, $0, UART_TX
	andi $k1, $k0, 0x0400
	bne $k1, $0, UART_RX
	j done
	nop

timer_ISR:
	mfc0 $k0, $13
	andi $k0, $k0, 0x7FFE
	mtc0 $k0, $13
	mfc0 $k0, $2
	lui $k1, 0x02FA
	ori $k1, $k1, 0xF080
	add $k0, $k1, $k0
	mtc0 $k0, $2
	j done

RTC_ISR:
	mfc0 $k0, $13
	andi $k0, $k0, 0xBFFE
	mtc0 $k0, $13
	lui $k0, 0xc100
	ori $k0, 0xc
	lw $k1, 0($k0)
	nop
	addiu $k1, $k1, 1
	sw $k1, 0($k0)
	nop
	j done
	
UART_TX:
	mfc0 $k0, $13
	andi $k0, $k0, 0xf7fe
	mtc0 $k0, $13
	lui $k0, 0xc100
	ori $k0, $k0, 0x4
	lw $k1, 0($k0)
	addiu $k0, $k0, 0x4
	lw $k0, 0($k0)
	beq $k1, $k0, done
	lui $k0, 0xc100
	ori $k0, $k0, 0x8
	lw $k1, 0($k0)
	addiu $k1, $k1, 1
	sw $k1, 0($k0)
	lui $k0, 0xc100
	ori $k0, $k0, 0x4
	lw $k1, 0($k0)
	addiu $k0, $k0, 0x17c
	add $k0, $k0, $k1
	lw $k0, 0($k0)
	lui $k1, 0x8000
	ori $k1, $k1, 0x8
	sw $k0, 0($k1)
	j done
	
UART_RX:
	mfc0 $k0, $13
	andi $k0, $k0, 0xfbfe
	mtc0 $k0, $13
	sw $k1, 0($k0)
	lui $k0, 0x8000
	ori $k0, $k0, 0xc
	lw $k0, 0($k0)
	ori $k1, $0, 0x64
	beq $k0, $k1, Disable_Timer
	addiu $k1, $k1, 1
	beq $k0, $k1, Enable_Timer
	lui $k1, 0xc100
	sw $k0, 0($k1)
	nop
	j done
	
Disable_Timer:
	mfc0 $k0, $12
	andi $k0, $k0, 0x7FFE
	mtc0 $k0, $12
	j done

Enable_Timer:
	mfc0 $k0, $12
	andi $k0, $k0, 0xBFFE
	mtc0 $k0, $12
	j done

done:
	mfc0 $k1, $12
	or $k1, $k1, 1
	mfc0 $k0, $14
	jr $k0
	mtc0 $k1, $12
	
