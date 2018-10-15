data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

stack segment
	dw 0,0,0,0,0,0,0,0
stack ends

code segment
  start:mov ax,data
	mov ds,ax
	mov ax,table
	mov es,ax
	mov ax,stack
	mov ss,ax
	mov sp,16
	
	mov cx,21
	mov bx,0
	mov di,0
	mov bp,0
     s0:push cx
	mov cx,4
	mov si,0
      s:mov al,ds:0h[bp][si]
	mov es:[bx].0h[si],al
	inc si
	loop s
	pop cx
	mov ax,ds:84[bp][0]
	mov dx,ds:84[bp][2]
	mov es:[bx].05h,dx
	mov es:[bx].07h,ax
	push ax
	mov ax,ds:168[di]
	mov es:[bx].0Ah,ax
	pop ax
	div word ptr ds:168[di]
	mov es:[bx].0Dh,ax
	add bp,4
	add di,2	
	add bx,16
	loop s0
	mov ax,4c00h
	int 21h
code ends
end start
	
