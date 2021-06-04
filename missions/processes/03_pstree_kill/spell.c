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
#define INPUT_TEMPLATE \
    (WHO == IMP ? IMP_INPUT_TEMPLATE : FAIRY_INPUT_TEMPLATE)

// template for the output files
#define IMP_OUTPUT_TEMPLATE \
    "$(gettext '$GSH_HOME/Castle/Cellar')/%d_$(gettext 'coal')"
#define FAIRY_OUTPUT_TEMPLATE \
    "$(gettext '$GSH_HOME/Castle/Cellar')/%d_$(gettext 'snowflake')"
#define OUTPUT_TEMPLATE \
    (WHO == IMP ? IMP_OUTPUT_TEMPLATE : FAIRY_OUTPUT_TEMPLATE)

char input_template[1024]; // template for the input ASCII-art files
char input_file[1024];     // actual path for the current input ASCII-art file

char output_template[1024]; // template for the ouput file
char output_file[1024];     // actual path for the current output file

char buf[4096]; // content of the ASCII-art file

#define LOG_FILE \
    (WHO == IMP ? "$GSH_VAR/coals.list" : "$GSH_VAR/snowflakes.list")
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
    strncpy(input_template, result.we_wordv[0], 1024);

    // expant the output template
    wordexp(OUTPUT_TEMPLATE, &result, 0);
    strncpy(output_template, result.we_wordv[0], 1024);
    // we need to expand it a second time as the expansion of "$(gettext
    // '$GSH_HOME/...')" puts a "$GSH_HOME" in the first expansion
    wordexp(output_template, &result, 0);
    strncpy(output_template, result.we_wordv[0], 1024);

    // expand the log path
    wordexp(LOG_FILE, &result, 0);
    strncpy(log_file, result.we_wordv[0], 1024);

    writing_sem = sem_open("/writing_sem", O_CREAT, 0644, 1);
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
        int size = fread(buf, 1, 4096, in);
        buf[size] = 0; // make sure it is a proper null terminated string
        for (char* line = strtok(buf, "\n"); line != NULL; line = strtok(NULL, "\n")) {
            fprintf(out, "%s%s\n", s, line);
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
