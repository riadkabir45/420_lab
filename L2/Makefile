.SILENT:

FILE ?= ./InputOutput/input1.c

all:
	./script.sh  $(FILE)
	make clean

clean:
	rm  l.o lex.yy.c y.o y.output y.tab.c y.tab.h

fclean:
	make clean
	rm my_log.txt a.out
