data segment
	db 'welcome to masm!'
	db 02h,24h,71h       ;三种颜色
data ends

stack segment
	dw 8 dup (0)         ;两重循环需要把cx压栈
stack ends

code segment
  start:mov ax,data
	mov ds,ax
	mov ax,0B800H        ;屏幕的段地址
	mov es,ax
	mov ax,stack
	mov ss,ax
	mov sp,16

	mov si,0             ;屏幕行的首字节的偏移地址，每次循环递增160
	mov di,0             ;遍历三种颜色
	mov cx,3
     s0:push cx
	mov cx,16
	mov bx,0             ;指向屏幕的当前行的显示位置
	mov bp,0             ;遍历'welcome to masm!'
      s:mov al,ds:[bp]       ;取字符
	mov es:[bx+si],al    ;将字符放在当前行的对应位置
	mov al,ds:16[di]     ;取颜色，16是颜色的起始便宜地址
	mov es:[bx+si+1],al  ;将颜色放在当前行的对应字符的后面
	add bx,2
	inc bp
	loop s
	pop cx
	add si,160
	inc di
	loop s0
code ends
end start
