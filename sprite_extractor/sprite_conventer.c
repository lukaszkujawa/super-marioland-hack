#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

#include "image_gen.h"

static FILE *f;

uint8_t get_color(int c) {
	if(c == 255) {
		return 0;
	}
	else if(c == 200) {
		return 1;
	}
	else if(c == 100) {
		return 2;
	}
	else if(c == 0) {
		return 3;
	}

	return 5;	
}

void convert_tile(pngimagedat_t *image, int tx, int ty) {
	tx *= 8;
	ty *= 8;

	for(int y = ty ; y < ty + 8 ; y++) {

		png_bytep row = image->data[y];
		uint8_t low = 0;
		uint8_t high = 0;
		uint8_t shift = 7;
		for(int x = tx ; x < tx+8 ; x++) {
			png_bytep px = &(row[x * 4]);
			uint8_t col = get_color(px[0]);
			//printf("%d,%d = %d, %d, %d\n", x, y, col, (col & 0x1) << (7-x), ((col >> 1) & 0x1) << (7-x));
			if(col == 5) {
				printf("ERROR: Unknow color value at:\n");
				printf("%4d,%4d = RGBA(%3d, %3d, %3d, %3d)\n", x, y, px[0], px[1], px[2], px[3]);
			}
			low |= (col & 0x1) << shift;
			high |= ((col >> 1) & 0x1) << shift;
			shift--;
			
		}

		fwrite(&low, 1, 1, f);
		fwrite(&high, 1, 1, f);

		printf("%02x %02x ", low, high );
	}
	printf("\n");
}

int main(int argc, char *argv[]) {
	if(argc != 3) {
		printf("USAGE: ./conventer input.png output.bin\n");
		exit(1);
	}
	pngimagedat_t *image = read_png_file(argv[1]);

	f = fopen(argv[2], "wb+");
    if(f == 0) {
        printf("ERROR: Couldn't open file");
        exit(-1);
    }


	int tiles_x = image->width / 8;
	int tiles_y = image->height / 8;

	printf("Dim=[%d, %d]\n", tiles_x, tiles_y);

	for(int y = 0 ; y < tiles_y ; y++) {
		for(int x = 0 ; x < tiles_x ; x++) {
			convert_tile(image, x, y);
		}
	}

	fclose(f);

/*
	for(int y = 0 ; y < image->height ; y++) {
		png_bytep row = image->data[y];

		for(int x = 0 ; x < image->width ; x++) {
			png_bytep px = &(row[x * 4]);
			uint8_t col = 0;
			if(px[0] == 255) {
				col = 0;
			}
			else if(px[0] == 200) {
				col = 1;
			}
			else if(px[0] == 100) {
				col = 2;
			}
			else if(px[0] == 0) {
				col = 3;
			}
			else {
				printf("ERROR: Unknow color value at:\n");
				printf("%4d, %4d = RGBA(%3d, %3d, %3d, %3d)\n", x, y, px[0], px[1], px[2], px[3]);
			}
		}
	}
*/
	return 0;
}