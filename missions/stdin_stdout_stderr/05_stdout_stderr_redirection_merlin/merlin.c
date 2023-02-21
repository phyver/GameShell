#include <libgen.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wordexp.h>

#ifdef GSH_NO_GETTEXT
char* gettext(const char* msgid) { return msgid; }
#else
#include <libintl.h>
#endif

#ifndef GSH_NO_GETTEXT
char dom[1024];    // large enough for TEXTDOMAIN
char domdir[1024]; // large enough for TEXTDOMAINDIR
#endif

char key[1024];
char key_path[1024];

int main(int argc, char** argv)
{
    srand(time(NULL));

#ifndef GSH_NO_GETTEXT
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
#endif

    // check for arguments
    if (argc > 1) {
        fprintf(stderr, gettext("Error: %s takes no argument."),
            basename(argv[0]));
        fprintf(stderr, "\n");
        exit(1);
    }

    // the message
    char* msg = gettext("THESECRETKEYISONSTDERR");

    // get the key from "$GSH_TMP/secret_key"
    wordexp_t result;
    wordexp("$GSH_TMP/secret_key", &result, 0);
    // if the path contains spaces, the result is contained in several words!
    int pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            key_path[pos++] = ' ';
            key_path[pos] = '\0';
        }
        strncat(key_path + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> key_path = '%s'\n", key_path); */

    // remove trailing newline
    FILE* key_f = fopen(key_path, "r");
    int n = fread(key, 1, 1024, key_f);
    if (key[n - 1] == '\n') {
        key[n - 1] = 0;
    }

    int len_msg = strlen(msg);
    int len_key = strlen(key);

    int i = 0; // index in the message
    int j = 0; // index in the key

    // stderr and stdout are not buffered
    setbuf(stdout, 0);
    setbuf(stderr, 0);

    while (i + j < len_msg + len_key) {
        if (rand() % (len_msg + len_key - i - j) < len_msg - i) {
            fprintf(stdout, "%c", msg[i++]);
            fflush(stdout);
        } else {
            fprintf(stderr, "%c", key[j++]);
            fflush(stderr);
        }
    }

    fprintf(stdout, "\n");
    fprintf(stderr, "\n");

    return 0;
}
