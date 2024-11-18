// FIXME: the semaphores can probably be safely removed if we open pid file
// with O_APPEND and use plain "write"

#include <fcntl.h>
#include <libgen.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <wordexp.h>

#define IMP 1
#define FAIRY 2
//
// #define WHO FAIRY // must be defined when compiling

#define MIN_SLEEP_TIME 2
#define MAX_SLEEP_BONUS 2
#define NB_FILES 4 // number of ascii-art files

// template for the input files
#define IMP_INPUT_TEMPLATE "$MISSION_DIR/ascii-art/coal-%d.txt"
#define FAIRY_INPUT_TEMPLATE "$MISSION_DIR/ascii-art/snowflake-%d.txt"
#define INPUT_TEMPLATE                                                       \
    (WHO == IMP ? IMP_INPUT_TEMPLATE : FAIRY_INPUT_TEMPLATE)

// template for the output files
#ifndef GSH_NO_GETTEXT
#define IMP_OUTPUT_TEMPLATE                                                  \
    "$(gettext '$GSH_HOME/Castle/Cellar')/%d_$(gettext 'coal')"
#define FAIRY_OUTPUT_TEMPLATE                                                \
    "$(gettext '$GSH_HOME/Castle/Cellar')/%d_$(gettext 'snowflake')"
#else
#define IMP_OUTPUT_TEMPLATE "$GSH_HOME/Castle/Cellar/%d_coal"
#define FAIRY_OUTPUT_TEMPLATE "$GSH_HOME/Castle/Cellar/%d_snowflake"
/* #endif */
#define OUTPUT_TEMPLATE                                                      \
    (WHO == IMP ? IMP_OUTPUT_TEMPLATE : FAIRY_OUTPUT_TEMPLATE)

char input_template[1024]; // template for the input ASCII-art files
char input_file[1024];     // actual path for the current input ASCII-art file

char output_template_tmp[1024]; // temporary template for the ouput file
char output_template[1024];     // template for the ouput file
char output_file[1024];         // actual path for the current output file

char line[1024]; // content of the ASCII-art file

#define LOG_FILE                                                             \
    (WHO == IMP ? "$GSH_TMP/coals.list" : "$GSH_TMP/snowflakes.list")
char log_file[1024]; // path for the log file

#define MAX_SPACES 30
char spaces[MAX_SPACES + 1] = "                              ";

sem_t* writing_sem; // Semaphore protecting the log file

int main()
{
    srand(getpid() + time(NULL));

    // Sanity checks.
    if (NB_FILES <= 0 || NB_FILES > 9 || MIN_SLEEP_TIME < 1)
        return 1;

    // expand the input template
    wordexp_t result;
    wordexp(INPUT_TEMPLATE, &result, 0);
    // if the path contains spaces, the result is contained in several words!
    int pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            input_template[pos++] = ' ';
            input_template[pos] = '\0';
        }
        strncat(input_template + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> input_template = '%s'\n", input_template); */
    wordfree(&result);

    // expant the output template
    wordexp(OUTPUT_TEMPLATE, &result, 0);
    // if the path contains spaces, the result is contained in several words!
    pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            output_template_tmp[pos++] = ' ';
            output_template_tmp[pos] = '\0';
        }
        strncat(output_template_tmp + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> 1output_template_tmp = '%s'\n", output_template_tmp); */
    wordfree(&result);
    // we need to expand it a second time as the expansion of "$(gettext
    // '$GSH_HOME/...')" puts a "$GSH_HOME" in the first expansion
    wordexp(output_template_tmp, &result, 0);
    pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            output_template[pos++] = ' ';
            output_template[pos] = '\0';
        }
        strncat(output_template + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> 2output_template = '%s'\n", output_template); */
    wordfree(&result);

    // expand the log path
    wordexp(LOG_FILE, &result, 0);
    pos = 0;
    for (int i = 0; result.we_wordv[i] != NULL; i++) {
        if (i > 0) {
            log_file[pos++] = ' ';
            log_file[pos] = '\0';
        }
        strncat(log_file + pos, result.we_wordv[i], 1024 - pos);
        pos += strlen(result.we_wordv[i]);
    }
    /* printf(">>> log_file = '%s'\n", log_file); */
    wordfree(&result);

    char login[128];
    getlogin_r(login, 128);
    char sem_path[256];
    strncpy(sem_path, "/writing_sem_", 128);
    strncat(sem_path, login, 128);
    sem_path[255] = '\0';


    writing_sem = sem_open(sem_path, O_CREAT, 0644, 1);
    if (writing_sem == SEM_FAILED)
        return 1;

    while (1) {
        int n;
        sleep(MIN_SLEEP_TIME + rand() % MAX_SLEEP_BONUS);

        // actual input ASCII-art file
        n = rand() % NB_FILES;
        sprintf(input_file, input_template, n);
        FILE* in = fopen(input_file, "r");

        // actual output file
        n = rand() % 65536;
        sprintf(output_file, output_template, n);
        FILE* out = fopen(output_file, "w");

        // random amount of spaces at the start of each line
        char* s = spaces + (rand() % MAX_SPACES);
        while (fgets(line, 1024, in)) {
            fprintf(out, "%s%s", s, line);
        }
        fclose(in);
        fclose(out);
        sem_wait(writing_sem);
        FILE* f = fopen(log_file, "a");
        setbuf(f, 0);
        fprintf(f, "%s\n", basename(output_file));
        fclose(f);
        sem_post(writing_sem);
    }
}
