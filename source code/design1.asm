assume cs:code,ds:data,ss:stack

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'         ;第一个数组，起始地址为0,每次循环地址递增4个字节，总共21×4=84
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514         ;第二个数组，起始地址为84,每次循环地址递增4个字节，总共21×4=84
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226      ;第三个数组，起始地址为168,每次循环地址递增2个字节
	dw 11542,14430,15257,17800
data ends

table segment
	db 21 dup ('year      s         n         p        ',0)                   ;39+1=40个字节，21行每行40个字节，最后一个字节是0
table ends

stack segment
	dw 16 dup (0)
stack ends

code segment
  start:mov ax,data
	mov ds,ax
	mov ax,table
	mov es,ax
	mov ax,stack
	mov ss,ax
	mov sp,32

	mov cx,21
	mov si,0
	mov di,0
	mov bx,0
     s0:push cx                ;写table的一行
	mov cx,4               ;写年份
     	mov bp,0
	mov ax,0
	push di
	mov di,bx
     s1:mov al,ds:0[si][bp]
	mov es:0[di][bp],al
	inc bp
	loop s1
	pop di

	mov ax,ds:84[si][0]    ;写十进制的summ
	mov dx,ds:84[si][2]
	mov bp,bx
	add bp,10
	call dtoc

	mov ax,ds:168[di]     ;写十进制的ne
	mov dx,0
	mov bp,bx
	add bp,20
	call dtoc             

	mov ax,ds:84[si][0]   ;写十进制的人均
	mov dx,ds:84[si][2]
	mov bp,ds:168[di]
	div bp
	mov dx,0
	mov bp,bx
	add bp,30
	call dtoc

	add si,4
	add di,2
	add bx,40	
	pop cx
	loop s0

	mov si,0             ;结果打印在屏幕中
	mov ax,table
	mov ds,ax	
	mov cx,21
	mov dh,1
	mov dl,0
     s4:push cx
	mov ch,0
	mov cl,2
	call show_str
	inc dh
	add si,1
	pop cx
	loop s4
	
	mov ax,4c00h
	int 21h


   dtoc:push cx
	push bx
	mov bx,bp             ;存一下起始位置
     s2:mov cx,10
     	call divdw            ;dx，ax所组成的dword转十进制字符串。每次对10取余，结果是倒序的
	add cx,30h
	mov es:[bp],cl
	mov cx,dx
	add cx,ax
	jcxz ok1
	inc bp
	jmp short s2
    ok1:mov al,es:[bp]        ;用两个指针将倒序的十进制字符串变成正序。bx是左边的指针，bp是右边的指针
	mov ah,es:[bx]
	mov es:[bx],al
	mov es:[bp],ah
	mov cx,bp             ;bx等于bp，则结束循环
	sub cx,bx
	jcxz ok2
	inc bx                ;bx加一后，bx等于bp，则结束循环
	mov cx,bp
	sub cx,bx
	jcxz ok2
	sub bp,1              ;bx加一且bp减1后，bx等于bp，则结束循环
	mov cx,bp
	sub cx,bx
	jcxz ok2
	jmp short ok1
    ok2:pop bx
	pop cx
	ret


  divdw:push bx
	push ax
	mov ax,dx
	mov dx,0
	div cx
	mov bx,ax    ;bx存商
	pop ax
	div cx
	mov cx,dx
	mov dx,bx
	pop bx
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
	mov bh,0
	mov bl,160
	mul bl
	mov di,ax            ;行偏移
	
	mov ah,0
	mov al,dl
	mov bh,0
	mov bl,2
	mul bl
	mov bx,ax            ;列偏移
	
	mov al,cl
     s3:mov ch,0
	mov cl,ds:[si]
	jcxz ok3
	mov es:[bx+di],cl
	mov es:[bx+di+1],al
	add bx,2
	inc si
	jmp short s3

    ok3:pop di
	pop bx
	pop ax
	pop es
	ret

code ends
end start
