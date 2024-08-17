OBJECT=main
$(OBJECT): lex.yy.o calc.tab.o
	g++ -w -o $(OBJECT) lex.yy.o calc.tab.o 
	$(OBJECT)
lex.yy.o: lex.yy.c calc.tab.h
	g++ -w -c lex.yy.c
calc.tab.o: calc.tab.c
	g++ -w -c calc.tab.c
calc.tab.c calc.tab.h: calc.y
	bison -d calc.y
lex.yy.c: calc.l
	flex calc.l

clean:
	del *.o *.tab.* lex.yy.c $(OBJECT).exe