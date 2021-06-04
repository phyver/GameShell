#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define NB_LINES 3
#define MAX_SIZE 6
#define MAX_SPACES 30
#define SLEEP_TIME 5

char coal[NB_LINES][MAX_SIZE + 1] = {
    " *#@*",
    "&_**/~",
    " !$-#",
};

char spaces[MAX_SPACES + 1] = "                              ";

int main()
{
    srand(time(NULL));
    while (1) {
        sleep(SLEEP_TIME);
        printf("\n");
        char* s = spaces + (rand() % MAX_SPACES);
        for (int i = 0; i < NB_LINES; i++) {
            printf("%s%s\n", s, coal[i]);
        }
        printf("\n");
    }
}
