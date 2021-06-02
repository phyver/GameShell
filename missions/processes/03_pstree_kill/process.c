#include <libgen.h>
#include <libintl.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <wordexp.h>

#define NB_CHILDREN 3

#define IMP 1
#define FAIRY 2

char dom[1024];        // large enough for TEXTDOMAIN
char domdir[1024];     // large enough for TEXTDOMAINDIR
char pids_path[1024];  // large enough for a file pids_path.
char imp_name[1024];   // large enough for the imp's name
char fairy_name[1024]; // large enough for the fairy's name
char spell_path[1024]; // large enough for the path to the spell process

int main(int argc, char** argv)
{
    setlocale(LC_ALL, "");

    // Give access to the TEXTDOMAIN environment variable.
    char* dom_env = getenv("TEXTDOMAIN");
    if (dom_env == NULL)
        return 1;
    strncpy(dom, dom_env, 1024);
    textdomain(dom);

    // Give access to the TEXTDOMAINDIR environment variable.
    char* domdir_env = getenv("TEXTDOMAINDIR");
    if (domdir_env == NULL)
        return 1;
    strncpy(domdir, domdir_env, 1024);
    bindtextdomain(dom, domdir);

    strncpy(imp_name, gettext("mischievous_imp"), 1024);
    strncpy(fairy_name, gettext("nice_fairy"), 1024);

    /* printf(">>> imp_name = %s\n", imp_name); */
    /* printf(">>> fairy_name = %s\n", fairy_name); */

    int who;
    char* cmd = basename(argv[0]);
    if (0 == strcmp(cmd, imp_name)) {
        who = IMP;
    } else if (0 == strcmp(cmd, fairy_name)) {
        who = FAIRY;
    } else {
        return 1;
    }
    /* printf(">>> who = %d\n", who); */

    // Get a pids_path to the file in which to write the children's PIDs.
    wordexp_t result;
    switch (who) {
    case IMP:
        wordexp("$GSH_VAR/imp_spell.pids", &result, 0);
        break;
    case FAIRY:
        wordexp("$GSH_VAR/fairy_spell.pids", &result, 0);
        break;
    }
    strncpy(pids_path, result.we_wordv[0], 1024);
    /* printf(">>> pids_path = %s\n", pids_path); */

    switch (who) {
    case IMP:
        wordexp("$GSH_VAR/imp/$(gettext 'spell')", &result, 0);
        break;
    case FAIRY:
        wordexp("$GSH_VAR/fairy/$(gettext 'spell')", &result, 0);
        break;
    }
    strncpy(spell_path, result.we_wordv[0], 1024);
    /* printf(">>> spell_path = %s\n", spell_path); */

    FILE* pids = fopen(pids_path, "w");
    if (pids == NULL)
        return 1;
    setbuf(pids, 0);

    for (int i = 0; i < NB_CHILDREN; i++) {
        /* printf(">>> i=%d\n", i); */
        int pid = fork();

        if (pid == 0) {
            fclose(pids);
            /* printf(">>> execl %s\n", spell_path); */
            execl(spell_path, spell_path, NULL);
        }

        fprintf(pids, "%d\n", pid);
    }

    fclose(pids);

    for (int i = 0; i < NB_CHILDREN; i++) {
        wait(NULL);
    }
    while (1) {
        sleep(1);
    }
}
