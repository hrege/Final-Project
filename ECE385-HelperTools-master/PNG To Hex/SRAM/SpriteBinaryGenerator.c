/* SpriteParser.c - Parses the t files from matlab into an MIF file format
 */

#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "background.txt"			// Input filename
#define OUTPUT_FILE "backgroundSeperate.ram"		// Name of file to output to
#define NUM_COLORS 	6								// Total number of different colors
#define WIDTH		8
#define DEPTH		3072

// Use this to define value of each color in the palette
const long Palette_Colors []= {2894636, 0, 14474460, 16711680, 6664447, 16579836};
int addr = 0;

int main()
{
	char line[21];
	FILE *in = fopen(INPUT_FILE, "r");
	FILE *out = fopen(OUTPUT_FILE, "wb");
	size_t num_chars = 20;
	long value = 0;

	unsigned short *p;

	if(!in)
	{
		printf("Unable to open input file!");
		return -1;
	}

	// Get a line, convert it to an integer, and compare it to the palette values.
	while(fgets(line, num_chars, in) != NULL)
	{
		value = (unsigned short)strtol(line, NULL, 16);
		p = (unsigned short *)&value;
		fwrite(p, sizeof(unsigned short), 1, out);
	}

	fclose(out);
	fclose(in);
	return 0;
}
