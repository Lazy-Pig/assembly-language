assume cs:codesg,ds:datasg
datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
	dw 0
datasg ends

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

codesg segment
  start:mov ax,datasg
	mov ds,ax
	mov bx,0
	mov cx,4
	mov ax,stacksg
	mov ss,ax
	mov sp,16
      s:push cx
	mov cx,3
	mov si,0
     s0:mov al,[bx+si]
	and al,0dfh
	mov [bx+si],al
	inc si
	loop s0
	add bx,16
	pop cx
	loop s
	mov ax,4c00H
	int 21H
codesg ends
end start
