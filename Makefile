all:
	rgbasm -o main.o main.asm
	rgblink -o mario.gb main.o