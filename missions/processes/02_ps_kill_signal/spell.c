#include <libintl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define NB_LINES 3
#define MAX_SIZE 6
#define MAX_SPACES 30
#define SLEEP_TIME 5

char coal[NB_LINES][MAX_SIZE+1] = {
  " *#@*",
  "&_**/~",
  " !$-#",
};

char spaces[MAX_SPACES+1] = "                              ";

char **dom;
char path[1024]; // Plenty large enough for a file path.

void spawn(int sig) {
  printf("%s\n", dgettext(*dom,
    "You'll need to do better than that to kill my spell!"));

  pid_t pid = fork();

  if(pid) {
    FILE *f = fopen(path, "a"); // FIXME protect against concurrent writes?
    fprintf(f, "%d\n", pid);
    fclose(f);
  }
}

int main(int argc, char *argv[]) {
  srand(time(NULL));

  // Give access to the TEXTDOMAIN (given as first argument);
  if(argc != 2) return 1;
  dom = &argv[1];

  // Get a path to the file in which to write the children's PIDs.
  char *gsh_var = getenv("GSH_VAR");
  strncpy(path, gsh_var, 1024);
  if(strlen(path) > 1000) return 1;
  strcat(path, "/spell-term.pids");

  // Register callback.
  signal(SIGTERM, spawn);

  while(1) {
    sleep(SLEEP_TIME);

    printf("\n");

    char *s = spaces + (rand() % MAX_SPACES);

    for(int i = 0; i < NB_LINES; i++) {
      printf("%s%s\n", s, coal[i]);
    }

    printf("\n");
  }
}
