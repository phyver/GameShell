#include <libgen.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <wordexp.h>

#ifdef GSH_NO_GETTEXT
char* gettext(const char* msgid) { return msgid; }
#else
#include <libintl.h>
#endif

#define NB_CHILDREN 3

#define IMP 1
#define FAIRY 2

#ifndef GSH_NO_GETTEXT
char dom[1024];    // large enough for TEXTDOMAIN
char domdir[1024]; // large enough for TEXTDOMAINDIR
#endif
char pids_path[1024];  // large enough for a file pids_path.
char imp_name[1024];   // large enough for the imp's name
char fairy_name[1024]; // large enough for the fairy's name
char spell_path[1024]; // large enough for the path to the spell process

int main(int argc, char** argv)
{
    (void)argc; // avoid warning
#ifndef GSH_NO_GETTEXT
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
#endif

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
        wordexp("$GSH_TMP/imp_spell.pids", &result, 0);
        break;
    case FAIRY:
        wordexp("$GSH_TMP/fairy_spell.pids", &result, 0);
        break;
    }
    // if the path contains spaces, the result is contained in several words!
    int pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            pids_path[pos++] = ' ';
            pids_path[pos] = '\0';
        }
        strncat(pids_path + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> pids_path = '%s'\n", pids_path); */
    wordfree(&result);

    switch (who) {
    case IMP:
#ifndef GSH_NO_GETTEXT
        wordexp("$GSH_TMP/imp/$(gettext 'spell')", &result, 0);
#else
        wordexp("$GSH_TMP/imp/spell", &result, 0);
#endif
        break;
    case FAIRY:
#ifndef GSH_NO_GETTEXT
        wordexp("$GSH_TMP/fairy/$(gettext 'spell')", &result, 0);
#else
        wordexp("$GSH_TMP/fairy/spell", &result, 0);
#endif
        break;
    }
    pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            spell_path[pos++] = ' ';
            spell_path[pos] = '\0';
        }
        strncat(spell_path + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> spell_path = '%s'\n", spell_path); */
    wordfree(&result);

    FILE* pids = fopen(pids_path, "w");
    if (pids == NULL)
        return 1;
    setbuf(pids, 0);

    for (int i = 0; i < NB_CHILDREN; i++) {
        /* printf(">>> i=%d\n", i); */
        int pid = fork();

        if (pid == 0) {
            fclose(pids);
            execl(spell_path, spell_path, NULL);
        }
        fprintf(pids, "%d\n", pid);
    }

    fclose(pids);

    /* printf(">>> waiting for children...\n"); */
    for (int i = 0; i < NB_CHILDREN; i++) {
        wait(NULL);
    }
    while (1) {
        sleep(1);
    }
}
