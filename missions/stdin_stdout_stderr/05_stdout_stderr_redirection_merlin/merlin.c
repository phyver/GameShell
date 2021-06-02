#include <libgen.h>
#include <libintl.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wordexp.h>

char dom[1024];    // large enough for TEXTDOMAIN
char domdir[1024]; // large enough for TEXTDOMAINDIR

char key[1024];

int main(int argc, char** argv)
{
    srand(time(NULL));

    // set locale from environment
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

    // check for arguments
    if (argc > 1) {
        fprintf(stderr, gettext("Error: %s takes no argument."),
            basename(argv[0]));
        fprintf(stderr, "\n");
        exit(1);
    }

    // the message
    char* msg = gettext("THESECRETKEYISONSTDERR");

    // get the key from "$GSH_VAR/secret_key"
    wordexp_t result;
    wordexp("$GSH_VAR/secret_key", &result, 0);
    char* key_path = result.we_wordv[0];

    // remove trailing newline
    if (key_path == NULL)
        return 1;
    FILE* key_f = fopen(key_path, "r");
    int n = fread(key, 1, 2048, key_f);
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
