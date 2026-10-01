#include <stdio.h>
#include <glad/gl.h>
#include <GLFW/glfw3.h>

extern void MAINASM();

int main() {
	printf("SWITCHING TO ASSEMBLY\n");
	MAINASM();
}
