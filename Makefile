all:
	rgbasm -o main.o main.asm
	rgblink -p0xFF -o mario.gb main.o