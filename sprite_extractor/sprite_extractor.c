#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

#include "image_gen.h"

#define SPRITE_RES 8
#define SPRITE_SIZE 16

typedef struct  {
  char *in_file;
  char *out_file;
  uint32_t offset;
  uint32_t width;
  uint32_t height;
  int max_sprites;
} config_t;

typedef struct {
  uint8_t *data;
  uint32_t len;
} imagedat_t;

void prinf_config(config_t *c) {
  printf("Input file: %s\n", c->in_file);
  printf("Output file: %s\n", c->out_file);
  printf("Offset: %d\n", c->offset);
  if(c->max_sprites <= -2) {
      printf("Max sprites: no limit\n");
  }
  else {
      printf("Max sprites: %d\n", c->max_sprites);
  }
}

imagedat_t *load_file(config_t *config) {
    imagedat_t *raw;
    raw = malloc(sizeof(imagedat_t));
    FILE *f = fopen(config->in_file, "rb");
    if(f == 0) {
        printf("ERROR: Couldn't open file");
        exit(-1);
    }

    fseek(f, 0, SEEK_END);
    raw->len = ftell(f);
    printf("File size: %d\n", raw->len);
    raw->data = malloc(raw->len);

    fseek(f, 0, SEEK_SET);
    fread(raw->data, raw->len, 1, f);
    fclose(f);
    return raw;
}

bitmap_t *init_bitmap(config_t *config) {
    bitmap_t *bm = malloc(sizeof(bitmap_t));
    bm->sprites_x = config->width;
    bm->sprites_y = config->height;
    bm->width = SPRITE_RES * config->width;
    bm->height = SPRITE_RES * config->height;
    bm->pixels = calloc (bm->width * bm->height, sizeof (pixel_t));
    return bm;
}

void load_sprite(uint8_t *image, uint8_t *data) {
    for(int c = 0 ; c < 8 ; c++) {
        uint8_t low = *(data);
        data++;
        uint8_t high = *(data);
        data++;

        for(int j = 7 ; j > -1 ; j--) {
            uint8_t px = ((high >> j & 0x1) << 1) + (low >> j & 0x1);
            *image = px;
            image++;
        }
    }
    image -= 64;
}

void render_sprite(uint8_t *data, bitmap_t *bitmap, uint32_t sx, uint32_t sy) {
    sx *= SPRITE_RES;
    sy *= SPRITE_RES;
    for(uint32_t y = 0 ; y < SPRITE_RES ; y++) {
        for(uint32_t x = 0 ; x < SPRITE_RES ; x++) {
            pixel_t *pixel = pixel_at(bitmap, sx + x, sy + y);
            uint8_t color = *data;
            switch(color) {
                case 0:
                  color = 255;
                  break;
                case 1:
                  color = 200;
                  break;
                case 2:
                  color = 100;
                  break;
                case 3:
                  color = 0;
                  break;
            }
            pixel->red = color;
            pixel->green = color;
            pixel->blue = color;

            data++;
        }
    }

    data -= 64;
}

void extract_sprites(config_t *config, imagedat_t *raw, bitmap_t *bitmap) {
    uint8_t image[64];
    uint32_t sprites_x = 0;
    uint32_t sprites_y = 0;

    for(int c = config->offset ; c < raw->len ; c+= SPRITE_SIZE) {
        if(c + SPRITE_SIZE >= raw->len) {
            break;
        }


        load_sprite(&image, raw->data + c);
        render_sprite(&image, bitmap, sprites_x, sprites_y);
        config->max_sprites--;
        if(config->max_sprites == 0) {
            break;
        }

        sprites_x++;
        if(sprites_x >= config->width) {
            sprites_x = 0;
            sprites_y++;
        }

    }
}

int main (int argc, char *argv[]) { 
    config_t config;
    bitmap_t *bitmap;
    imagedat_t *data;
    int c;

    config.in_file = "../baserom.gb";
    config.out_file = "sprites.png";
    config.offset = 0;
    config.width = 64;
    config.height = 64;
    config.max_sprites = -2;

    while ((c = getopt (argc, argv, "i:o:x:m:w:h:")) != -1) {
      switch (c) {
        case 'i':
          config.in_file = optarg;
          break;
        case 'o':
          config.out_file = optarg;
          break;
        case 'x':
          config.offset = atoi(optarg);
          break;
        case 'm':
          config.max_sprites = atoi(optarg);
          break;
        case 'w':
          config.width = atoi(optarg);
          break;
        case 'h':
          config.height = atoi(optarg);
          break;
      }
    }

    prinf_config(&config);
    data = load_file(&config);
    bitmap = init_bitmap(&config);
    extract_sprites(&config, data, bitmap);

    save_png_to_file (bitmap, config.out_file);
   
    free(data->data);
    free(data);
    free(bitmap->pixels);
    free(bitmap);
    return 0;
}