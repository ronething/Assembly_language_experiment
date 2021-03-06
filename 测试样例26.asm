﻿;身份证根据前17位算出最后一位并且显示18位身份证号码
DATAS SEGMENT
    ;此处输入数据段代码  
    CRLF DB 0DH,0AH,24H
    WI DB 7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2
    YI DB "10X98765432"
	S  DW 0
	BUFFER DB 18,?
	AI DB 17 DUP(?)
	LAST  DB ?
	DB 24H
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DW 100H DUP(?)
    TOS LABEL WORD
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
MAIN PROC FAR
	MOV AX,STACKS
	MOV SS,AX
	LEA SP,TOS
	MOV AX,DATAS
	MOV DS,AX
	LEA DX,BUFFER
	MOV AH,0AH
	INT 21H
	XOR BX,BX
	MOV CX,17
NEXT:
	MOV AL,AI[BX]
	AND AL,0FH
	MOV DL,WI[BX]
	MUL DL
	ADD S,AX
	INC BX
	LOOP NEXT
	MOV AX,S
	MOV DL,11
	DIV DL
	MOV BL,AH
	MOV BH,0
	MOV AL,YI[BX]
	MOV LAST,AL
	LEA DX,CRLF
	MOV AH,09H
	INT 21H
	LEA DX,AI
	MOV AH,09H
	INT 21H
	MOV AH,4CH
	INT 21H
MAIN ENDP
CODES ENDS
    END MAIN