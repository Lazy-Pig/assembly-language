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
	db 21 dup ('year summ ne ?? ')
table ends

stack segment
	dw 0,0,0,0,0,0,0,0      ;由于有两重loop所以需要吧cx压栈，另外寄存器不够用也需要压栈
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
	mov bx,0                ;bx代表输出table中的每一条的首地址，每次循环递增16
	mov di,0                ;di用于循环地三个数组
	mov bp,0                ;用于循环第一个和第二个数组
     s0:push cx                 ;外层循环，循环21次，每次循环写好table中的一条记录
	mov cx,4
	mov si,0
      s:mov al,ds:0h[bp][si]    ;内层循环，循环4次，每次读取对应的年份中的每个char写入table中当前条目的第0～3个字节
	mov es:[bx].0h[si],al
	inc si
	loop s
	pop cx
	mov ax,ds:84[bp][0]     ;取出第二个数组中的低两个字节内容放入ax
	mov dx,ds:84[bp][2]     ;取出第二个数组中的高两个字节内容放入dx
	mov es:[bx].05h,ax      ;ax放入table中当前条目的第5、6个字节
	mov es:[bx].07h,dx      ;dx放入table中当前条目的第7、8个字节
	push ax                 ;寄存器不够用了，下面要借用一下ax，所以先保存ax的值
	mov ax,ds:168[di]       ;第三个数组的当前两个字节放入ax
	mov es:[bx].0Ah,ax      ;ax放入table中当前条目的第10、11个字节
	pop ax                  ;取出原本的ax
	div word ptr ds:168[di] ;做除法，被除数在dx和ax中，除数是ds:168[di]中的两个字节
	mov es:[bx].0Dh,ax      ;商默认存在ax中，放入table中当前条目的第13、14个字节
	add bp,4
	add di,2	
	add bx,16
	loop s0
	mov ax,4c00h
	int 21h
code ends
end start
	
