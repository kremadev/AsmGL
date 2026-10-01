CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -std=c23
CPPFLAGS = -Iinclude/glad/include -Iinclude $(shell pkg-config --cflags glfw3)
LDLIBS  = $(shell pkg-config --libs glfw3) -lm -ldl

C_SRC   = help.c include/glad/src/gl.c
OBJ     = help.o gl.o main.o
GL_INC  = gl_constants.inc

vpath %.c include/glad/src

all: main

main: $(OBJ)
	$(CC) -no-pie $(OBJ) $(LDLIBS) -o main

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(GL_INC): include/glad/include/glad/gl.h
	gcc -E -dM -Iinclude/glad/include -include glad/gl.h -include GLFW/glfw3.h -x c /dev/null \
		| grep -E '#define (GL_|GLFW_)[A-Za-z0-9_]* .+' \
		| sed -E 's/#define ([A-Za-z0-9_]+) (.+)/%define \1 \2/' > $@

main.o: main.s $(GL_INC)
	nasm -felf64 $< -o $@

run: main
	./main

clean:
	rm -f $(OBJ) $(GL_INC) main

.PHONY: all run clean
