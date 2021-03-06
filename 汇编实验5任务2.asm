﻿DATAS SEGMENT
	;此处输入数据段代码  
	ARRAY DB 02H,05H,08H,04H,07H,01H,09H,06H,03H,00H
	LEN DW 10 ;数组长度为10
	NUM DW 0  ;最后输出的时候计数用
	TABLE DW 2 DUP(?)
DATAS ENDS

STACKS SEGMENT
	DW 100 DUP(?)
	TOS LABEL WORD;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX
	MOV AX,STACKS
	MOV SS,AX;堆栈段地址
	MOV BX,OFFSET TOS
	MOV SP,BX;堆栈偏移地址
	LEA SI,ARRAY;si存array偏移地址
	MOV TABLE,OFFSET LEN;table 第一个字存len偏移地址
	MOV TABLE + 2,OFFSET ARRAY;table 第二个字存array偏移地址
	MOV BX,OFFSET TABLE
	CALL NEAR PTR SORTFUN
	
	;此处输入代码段代码
	MOV AH,4CH
	INT 21H
SORTFUN PROC NEAR
	PUSH AX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	MOV SI,[BX]
	MOV CX,[SI];取到len
	DEC CX;减掉一次循环？
	MOV SI,[BX + 2];ds:si array的第一个值
	PUSH SI
NEXT1:
	MOV DI,SI
	MOV AL,[SI]
	MOV DX,CX
NEXT2:
	CMP AL,[DI + 1];第一个值和第二个值相比较
	JBE NEXT3 ;al<=[di+1]
	MOV AH,[DI + 1];如果第一个值大于第二个值则交换
	MOV [SI],AH
	MOV [DI + 1],AL
	MOV AL,AH
NEXT3:
	;al<=[di+1]
	INC DI
	DEC DX
	JNZ NEXT2
	INC SI
	LOOP NEXT1
	POP SI
OUTPUT:
	MOV AH,02
	MOV DL,[SI]
	ADD DL,'0';加上0的ascii码
	INT 21H
	INC SI
	ADD NUM,1
	CMP NUM,10
	JNZ OUTPUT
	POP DI
	POP SI
	POP DX
	POP CX
	POP AX
	RET
SORTFUN ENDP
CODES ENDS
	END START

