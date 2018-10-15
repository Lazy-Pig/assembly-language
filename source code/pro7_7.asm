assume cs:codesg,ds:datasg
datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
	dw 0
datasg ends

codesg segment
  start:mov ax,datasg
	mov ds,ax
	mov bx,0
	mov cx,4
      s:mov ds:[40H],cx
	mov cx,3
	mov si,0
     s0:mov al,[bx+si]
	and al,0dfh
	mov [bx+si],al
	inc si
	loop s0
	add bx,16
	mov cx,ds:[40H]
	loop s
	mov ax,4c00H
	int 21H
codesg ends
end start
