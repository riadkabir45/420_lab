.SILENT:

FILE ?= ./InputOutput/input1.c

all:
	./script.sh  $(FILE)
	make clean

clean:
	for f in l.o lex.yy.c y.o y.output y.tab.c y.tab.h;\
	do \
		if [ -e "$$f" ]; then \
			rm "$$f"; \
		fi; \
	done

fclean:
	make clean
	for f in my_log.txt a.out;\
	do \
		if [ -e "$$f" ]; then \
			rm "$$f"; \
		fi; \
	done
