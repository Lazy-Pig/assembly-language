assume cs:code
data segment
	db 'Welcome to masm!',0
data ends

code segment
  start:mov dh,8
	mov dl,3
	mov cl,2
	mov ax,data
	mov ds,ax
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h
  show_str:
	push es
	push ax
	push bx
	push di

	mov ax,0B800H        ;屏幕的段地址
	mov es,ax

	mov ah,0	
	mov al,dh
	mov bl,160
	mul bl
	mov di,ax            ;行偏移
	
	mov ah,0
	mov al,dl
	mov bl,2
	mul bl
	mov bx,ax            ;列偏移
	
	mov al,cl
      s:mov ch,0
	mov cl,ds:[si]
	jcxz ok
	mov es:[bx+di],cl
	mov es:[bx+di+1],al
	add bx,2
	inc si
	jmp short s

     ok:pop di
	pop bx
	pop ax
	pop es
	ret
code ends
end start
