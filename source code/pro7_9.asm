assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
	db '1. display      '
	db '2. brows        '
	db '3. replace      '
	db '4. modify       '
datasg ends

codesg segment
  start:mov ax,stacksg
	mov ss,ax
	mov sp,16
	mov ax,datasg
	mov ds,ax
	
	mov bx,0
	mov cx,4
     s0:push cx
	mov cx,4
	mov si,0
      s:mov al,[bx+si+3]
	and al,0dfH
	mov [bx+si+3],al
	inc si
	loop s
	add bx,16
	pop cx
	loop s0
	mov ax,4c00H
	int 21H
codesg ends
end start
	
