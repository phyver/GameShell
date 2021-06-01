#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#define NB_CHILDREN 3

// This program relies on the following environment variables:
// - SPELL_PATH containing the path to the "spell" executable,
// - SPELL_NAME the (translated) name of the spell executable,
// - PIDS_FILE a file path where to record the PID of all children.
int main(int argc, char **argv) {
    char *spell_path = getenv("SPELL_PATH");
    if(spell_path == NULL) return 1;

    char *spell_name = getenv("SPELL_NAME");
    if(spell_name == NULL) return 1;

    char *pids_file = getenv("PIDS_FILE");
    if(pids_file == NULL) return 1;

    char *args[] = { spell_name, NULL, };

    FILE *pids = fopen(pids_file, "w");
    if(pids == NULL) return 1;

    for(int i = 0; i < NB_CHILDREN; i++) {
        pid_t pid = fork();

        if(pid == 0) {
            fclose(pids);
            sleep(i);
            execv(spell_path, args);
        }

        fprintf(pids, "%d\n", pid);
    }

    fclose(pids);

    while(1) {
        sleep(1);
    }
}
