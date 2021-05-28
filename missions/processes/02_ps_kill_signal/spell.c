#include <libintl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>

#define NB_LINES 3
#define MAX_SIZE 6
#define MAX_SPACES 30
#define MIN_SLEEP_TIME 5
#define MAX_SLEEP_BONUS 5

char coal[NB_LINES][MAX_SIZE+1] = {
  " *#@*",
  "&_**/~",
  " !$-#",
};

char spaces[MAX_SPACES+1] = "                              ";

char dom[1024];  // Plenty large enough for TEXTDOMAIN
char path[1024]; // Plenty large enough for a file path.

sem_t *printing_sem; // Semaphore protecting stdout.
sem_t *writing_sem;  // Semaphore protecting the PID file.

void print_coal() {
  int err = sem_wait(printing_sem);

  if(err != 0) return; // Might have been interrupted.

  printf("\n");

  char *s = spaces + (rand() % MAX_SPACES);
  for(int i = 0; i < NB_LINES; i++) {
    printf("%s%s\n", s, coal[i]);
  }

  printf("\n");

  sem_post(printing_sem);
}

void write_pid(pid_t pid) {
  sem_wait(writing_sem);

  FILE *f = fopen(path, "a");
  fprintf(f, "%d\n", pid);
  fclose(f);

  sem_post(writing_sem);
}

void spawn(int sig) {
  printf("%s\n", dgettext(dom,
    "You'll need to do better than that to kill my spell!"));

  pid_t pid = fork();

  if(pid) {
    write_pid(pid);

    // Update the seed to desynchronize.
    srand(time(NULL));
  }
}

int main(int argc, char *argv[]) {
  srand(time(NULL));

  // Give access to the TEXTDOMAIN environment variable.
  char *dom_env = getenv("TEXTDOMAIN");
  if(dom_env == NULL) return 1;
  strncpy(dom, dom_env, 1024);

  // Get a path to the file in which to write the children's PIDs.
  char *gsh_var = getenv("GSH_VAR");
  if(gsh_var == NULL) return 1;
  strncpy(path, gsh_var, 1024);
  if(strlen(path) > 1000) return 1;
  strcat(path, "/spell-term.pids");

  // Initialize semaphores.
  printing_sem = sem_open("/printing_sem", O_CREAT, 0644, 1);
  if(printing_sem == SEM_FAILED) return 1;

  writing_sem = sem_open("/writing_sem", O_CREAT, 0644, 1);
  if(writing_sem == SEM_FAILED) return 1;

  // Register callback.
  signal(SIGTERM, spawn);

  while(1) {
    sleep(MIN_SLEEP_TIME + rand() % MAX_SLEEP_BONUS);
    print_coal();
  }
}
