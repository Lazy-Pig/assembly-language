assume cs:code

data segment
	db 10 dup (0)
data ends

stack segment
	dw 16 dup (0)
stack ends

code segment
  start:mov ax,12666
	mov bx,data
	mov ds,bx
	mov si,0

	mov bx,stack
	mov ss,bx
	mov sp,32
	call dtoc

	mov dh,8
	mov dl,3
	mov cl,2
	call show_str
	
	mov ax, 4c00h
	int 21h

   dtoc:push cx
	push dx
     s0:mov dx,0
	mov bx,10
	div bx
	add dx,30h
	mov ds:[si],dl
	mov cx,ax
	jcxz s1
	inc si
	jmp short s0
     s1:mov di,0
	mov bx,0
     s2:mov cx,si
	sub cx,di
	jcxz ok1
	mov al,ds:[si]
	mov bl,ds:[di]
	mov ds:[si],bl
	mov ds:[di],al
	inc di
	sub si,1
	jmp short s2
    ok1:mov si,0
	pop dx
	pop cx
	ret

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
     s3:mov ch,0
	mov cl,ds:[si]
	jcxz ok2
	mov es:[bx+di],cl
	mov es:[bx+di+1],al
	add bx,2
	inc si
	jmp short s3

    ok2:pop di
	pop bx
	pop ax
	pop es
	ret
code ends
end start
	
