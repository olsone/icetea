#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>

int indexes[16] = 
// { 11, 12, 14, 2, 6, 7, 13, 9, 8, 15, 0, 1, 5, 3, 4, 10 };
 { 11, 12, 14, 2, 6, 7, 13, 9, 8, 15, 0, 1, 5, 3, 4, 10 };
 
     // Reading Address from shift registers
    // Address lines to LV165A were routed to minimize vias. Reorder bits in fpga.
    //  11  12  13  14   3   4   5   6  LV165A pin
    //   A   B   C   D   E   F   G   H  <- H is the first bit obtained by shifting
    //  A8  A7 A15  A0  A1  A6  A2  A9  <- ADRIN1
    // A10 A11  A3 A13 A14 A12  A4  A5  <- ADRIN2
    //   8   9  10  11  12  13  14  15  <- index
    //   0   1   2   3   4   5   6   7  <- index
    
    // A000 set: A0, A2  but i see 5 bits at  least in 4837
    // A001 set: A0, A2, A15 but I see 6 bits in 4877
    
int main(int argc, char **argv)
{
  if (argc<2) {
    fprintf(stderr, "usage: %s hex\n", argv[0]);
    exit(1);
  }
  
  char *ptr;
  int x0 = strtol(argv[1], &ptr, 16);
  int x = x0;
  int bits[16];
  // break into bits
  for (int i=0; i<16; ++i) {
//  for (int i=15; i>=0; --i) {
    bits[i] = x&1;

        
    char stars[32];
    sprintf(stars, "|    |    |    |    |");
    int j = 0;
    while (j<16 && indexes[j] != i) {
      ++j;
    }
    if (bits[i]  && j<16) stars[ 5*(j/4) + j%4 + 1] = '*';
    
    printf("bits[%X] = %d %s A%d\n", i, bits[i], stars, j);
    x = x>>1;
  }
  // rearrange
  int y = 0;
  for (int i=0; i<16; ++i) {
    y = (y<<1) | bits[indexes[i]];
  } 
  printf("%04x -> %04x\n", x0, y);
  
}
