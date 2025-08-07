.PHONY: watch clean

watch:
	@while true; do\
		inotifywait -q -e modify syntax_analyzer.y  lex_analyzer.l; \
    	make all ; \
	done

all:
	@./compiler.sh sides/input2.txt
