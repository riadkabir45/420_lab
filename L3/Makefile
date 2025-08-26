.SILENT:

FILE ?= ./InputSample/input1.c

all:
	make -s unclean  $(FILE)
	make -s clean


unclean:
	./script.sh  $(FILE)


clean:
	for f in l.o lex.yy.c y.o y.output y.tab.c y.tab.h test.cpp scope_table.log;\
	do \
		if [ -e "$$f" ]; then \
			rm "$$f"; \
		fi; \
	done

fclean:
	make -s clean
	for f in my_log.txt a.out;\
	do \
		if [ -e "$$f" ]; then \
			rm "$$f"; \
		fi; \
	done
