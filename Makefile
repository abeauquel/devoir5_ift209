AS = as
CC = g++


tp5:	tp5.o analyse.o tp5.cc
	@echo
	@echo ------------------------
	@echo Edition des liens
	@echo ------------------------
	@echo

	$(CC) -g tp5.cc tp5.o analyse.o -o tp5








tp5.o: tp5.as
	@echo
	@echo ---------------------------------------------
	@echo Sous-programme de compilation, tp5.as
	@echo ---------------------------------------------
	@echo

	$(AS)  -gstabs tp5.as -o tp5.o
