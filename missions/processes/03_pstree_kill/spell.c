#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define DELAY 3
#define NB_FILES 4

// This program relies on the following environment variable:
// - SPELL_PATH_TEMPLATE containing a path template pointing to a group of
//   ascii-art files (the last character 'X' will be substituted by numbers
//   between 0 and NB_FILES).
int main() {
    srand(time(NULL));

    // Sanity checks.
    if(NB_FILES <= 0 || NB_FILES > 9 || DELAY < 1) return 1;

    char *spell_path = getenv("SPELL_PATH_TEMPLATE");
    if(spell_path == NULL) return 1;

    // Get the index of the last X in the spell path template.
    int ix = strlen(spell_path) - 1;
    while(ix > 0 && spell_path[ix] != 'X') ix--;
    if(ix == 0) return 1;

    while(1) {
        sleep(DELAY);

        // Pick an index to choose a spell file.
        spell_path[ix] = '0' + (rand() % NB_FILES);

        // TODO actually write files.
        printf("PATH: %s\n", spell_path);
    }
}
