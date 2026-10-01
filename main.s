%include "gl_constants.inc"

default rel

extern glfwInit
extern glfwWindowHint
extern glfwCreateWindow
extern glfwMakeContextCurrent
extern gladLoadGL
extern glad_glViewport
extern glfwSwapBuffers
extern glfwPollEvents
extern glfwGetProcAddress
extern glad_glClear
extern glad_glClearColor

section .data
title db "AsmGL"

clearcolR dd 0.2
clearcolG dd 0.3
clearcolB dd 0.3
clearcolA dd 1.0

vertices:
dd 0.0
dd 0.5
dd 0.0

dd 0.5
dd -0.5
dd 0.0

dd -0.5
dd -0.5
dd 0.0 

section .bss
window resq 1

section .text
global MAINASM
MAINASM:
	sub rsp, 8

	call glfwInit
	mov rdi, GLFW_CONTEXT_VERSION_MAJOR
	mov rsi, 4
	call glfwWindowHint

	mov rdi, GLFW_CONTEXT_VERSION_MINOR
	mov rsi, 6
	call glfwWindowHint

	mov rdi, GLFW_OPENGL_PROFILE
	mov rsi, GLFW_OPENGL_CORE_PROFILE
	call glfwWindowHint

	mov rdi, 800
	mov rsi, 800
	lea rdx, [title]
	xor rcx, rcx
	xor r8, r8
	call glfwCreateWindow
	mov [window], rax

	mov rdi, [window]
	call glfwMakeContextCurrent

	lea rdi, [glfwGetProcAddress]
	call gladLoadGL

	mov rdi, 0
	mov rsi, 0
	mov rdx, 800
	mov rcx, 800
	mov rax, [rel glad_glViewport]
	call rax

	.loop:
	call glfwPollEvents

	mov rdi, GL_COLOR_BUFFER_BIT
	mov rax, [rel glad_glClear]
	call rax

	movss xmm0, [clearcolR]
	movss xmm1, [clearcolG]
	movss xmm2, [clearcolB]
	movss xmm3, [clearcolA]
	mov rax, [rel glad_glClearColor]
	call rax

	mov rdi, [window]
	call glfwSwapBuffers
	jmp .loop

	add rsp, 8
	xor eax, eax
	ret
