j main
j interrupt
j exception

#定时器设置
addi $t1, $zero, -1000
lui $t0, 0x4000
sw $t1, 0($t0)
addi $t0, $t0, 0x0004
sw $t1, 0($t0)
addi $t0, $t0, 0x0004
sw $zero, 0($t0)


main:
	addi $t7, $zero, 1
	j judge
shift:
	beq $t0, $zero, a_shift
	beq $t1, $zero, b_shift
a_shift:
	srl $s0, $s0, 1
	j judge
b_shift:
	srl $s1, $s1, 1
	j judge
judge:
	andi $t0, $s0, 1
	andi $t1, $s1, 1
	add $t2, $t0, $t1
	beq $t2, $t7, shift
gcd:
	beq $s0, $s1, end
	slt $t0, $s0, $s1
	beq $t0, $zero, b_s
a_s:
	sub $s1, $s1, $s0
	beq $s0, $s1, end
	j judge
b_s:
	sub $s0, $s0, $s1
	beq $s0, $s1, end
	j judge
end:
	# li $v0, 1
	# move $a0, $s0
	# syscall
#$t0, $t1, $t2, $t7, $s0, $s1, $a0, $v0
exception:
	jr $k1
#中断
interrupt:
	lui $s2, 0x4000
	addi $s2, 8
	lw $s3, 0($s2) #s3 = tcon
	addi $s4, $0, -7
	and $s3, $s3, $s4
	sw $s3, 0($s2)
	addi $s2, $s2, 12 #s2 = 0x40000014 #开始更新
	lw $s3,0($s2)
	andi $s3, $s3, 0x0f00 #s3 = digi高位
	addi $s4, $0, 0x0100
	beq $s3, $s4, num12
	sll $s4, $s4, 1
	beq $s3, $s4, num21
	sll $s4, $s4, 1
	beq $s3, $s4, num22
	sll $s4, $s4, 1
	beq $s3, $s4, num11
num11:
	srl $s4, $s4, 3 #s4 = 新digi高位
	andi $t4, $s0, 0x000f #t4 = s0低位
	jal bcd #t4 = 新digi低位
	j restore
num12:
	sll $s4, $s4, 1
	andi $t4, $s0, 0x00f0 #t4 = s0高位
	jal bcd
	j restore
num21:
	sll $s4, $s4, 1
	andi $t4, $s1, 0x000f #t4 = s1低位
	jal bcd
	j restore
num22:
	sll $s4, $s4, 1
	andi $t4, $s1, 0x00f0 #t4 = s1高位
	jal bcd
	j restore
bcd:
	add $s3, $0, $0 #s3计数
	beq $t4, $s3, d0
	addi $s3, $s3, 1
	beq $t4, $s3, d1
	addi $s3, $s3, 1
	beq $t4, $s3, d2
	addi $s3, $s3, 1
	beq $t4, $s3, d3
	addi $s3, $s3, 1
	beq $t4, $s3, d4
	addi $s3, $s3, 1
	beq $t4, $s3, d5
	addi $s3, $s3, 1
	beq $t4, $s3, d6
	addi $s3, $s3, 1
	beq $t4, $s3, d7
	addi $s3, $s3, 1
	beq $t4, $s3, d8
	addi $s3, $s3, 1
	beq $t4, $s3, d9
	addi $s3, $s3, 1
	beq $t4, $s3, d10
	addi $s3, $s3, 1
	beq $t4, $s3, d11
	addi $s3, $s3, 1
	beq $t4, $s3, d12
	addi $s3, $s3, 1
	beq $t4, $s3, d13
	addi $s3, $s3, 1
	beq $t4, $s3, d14
	addi $t4, $0, 0x0071
	jr $ra
d0:
	addi $t4, $0, 0x003f
	jr $ra
d1:
	addi $t4, $0, 0x0006
	jr $ra
d2:
	addi $t4, $0, 0x005b
	jr $ra
d3:
	addi $t4, $0, 0x004f
	jr $ra
d4:
	addi $t4, $0, 0x0066
	jr $ra
d5:
	addi $t4, $0, 0x006d
	jr $ra
d6:
	addi $t4, $0, 0x007d
	jr $ra
d7:
	addi $t4, $0, 0x0007
	jr $ra
d8:
	addi $t4, $0, 0x007f
	jr $ra
d9:
	addi $t4, $0, 0x006f
	jr $ra
d10:
	addi $t4, $0, 0x0077
	jr $ra
d11:
	addi $t4, $0, 0x007c
	jr $ra
d12:
	addi $t4, $0, 0x0039
	jr $ra
d13:
	addi $t4, $0, 0x005e
	jr $ra
d14:
	addi $t4, $0, 0x0079
	jr $ra
restore:
	add $t4, $t4, $s4 #t4 = 新digi
	sw $t4, 0($s2)
	addi $s2, $s2, -12 #s2 = 0x40000008
	lw $s3, 0($s2) #s3 = tcon
	addi $s4, $0, 2
	or $s3, $s3, $s4
	sw $s3, 0($s2)
	jr $k0
	