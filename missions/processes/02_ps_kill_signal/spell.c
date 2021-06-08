#include <fcntl.h>
#include <libintl.h>
#include <locale.h>
#include <semaphore.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <wordexp.h>

#define NB_LINES 3
#define MAX_SIZE 6
#define MAX_SPACES 30
#define MIN_SLEEP_TIME 5
#define MAX_SLEEP_BONUS 5

char coal[NB_LINES][MAX_SIZE + 1] = {
    " *#@*",
    "&_**/~",
    " !$-#",
};

char spaces[MAX_SPACES + 1] = "                              ";

char dom[1024];    // large enough for TEXTDOMAIN
char domdir[1024]; // large enough for TEXTDOMAINDIR
char path[1024];   // large enough for a file path.

sem_t* printing_sem; // Semaphore protecting stdout.
sem_t* writing_sem;  // Semaphore protecting the PID file.

void print_coal()
{
    int err = sem_wait(printing_sem);
    if (err != 0)
        return; // Might have been interrupted.
    printf("\n");
    char* s = spaces + (rand() % MAX_SPACES);
    for (int i = 0; i < NB_LINES; i++) {
        printf("%s%s\n", s, coal[i]);
    }
    printf("\n");
    sem_post(printing_sem);
}

void write_pid(pid_t pid)
{
    sem_wait(writing_sem);
    FILE* f = fopen(path, "a");
    fprintf(f, "%d\n", pid);
    fclose(f);
    sem_post(writing_sem);
}

void spawn(int sig)
{
    (void)sig; // to prevent warning
    printf("%s\n",
        gettext("You'll need to do better than that to kill my spell!"));
    // reset the signal handler
    signal(SIGTERM, spawn);

    pid_t pid = fork();
    if (pid) {
        printf("call write_pid with %d\n", pid);
        write_pid(pid);
        // Update the seed to desynchronize.
        srand(pid + time(NULL));
    }
}

int main()
{
    srand(time(NULL));

    setlocale(LC_ALL, "");

    // get the TEXTDOMAIN environment variable.
    char* dom_env = getenv("TEXTDOMAIN");
    if (dom_env == NULL)
        return 1;
    strncpy(dom, dom_env, 1024);
    textdomain(dom);

    // get the TEXTDOMAINDIR environment variable.
    char* domdir_env = getenv("TEXTDOMAINDIR");
    if (domdir_env == NULL)
        return 1;
    strncpy(domdir, domdir_env, 1024);
    bindtextdomain(dom, domdir);

    // define the path to the file in which to write the children's PIDs.
    wordexp_t result;
    wordexp("$GSH_VAR/spell.pids", &result, 0);
    // if the path contains spaces, the result is contained in several words!
    int pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            path[pos++] = ' ';
            path[pos] = '\0';
        }
        strncat(path + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }

    // Initialize semaphores.
    printing_sem = sem_open("/printing_sem", O_CREAT, 0644, 1);
    if (printing_sem == SEM_FAILED)
        return 1;

    writing_sem = sem_open("/writing_sem", O_CREAT, 0644, 1);
    if (writing_sem == SEM_FAILED)
        return 1;

    // Register callback.
    signal(SIGTERM, spawn);

    while (1) {
        sleep(MIN_SLEEP_TIME + rand() % MAX_SLEEP_BONUS);
        print_coal();
    }
}
