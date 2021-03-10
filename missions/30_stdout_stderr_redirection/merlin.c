#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

char msg[] = "LACLESECRETEESTSURSTDERR";
char cle[] = "MRGLPZYMAMLAJNBWRQPYACQBDYUFWQFUWVXQELCCGCJZUEJUEZ"
"XLDYQPVHLHGLXKZJAAUKKFCTQJQKMMCNLUUEFFYEYPHNWCMKDM"
"BKQAJPSHGBTJJQKDAAPCWFHTKGLTWRFTEWMPDHCHQNVVLHDWNM"
"LFCLEAZWCQLVBXFFRRZMMJGLMKEVUXXDHUCHWAYQJFWAUYEHUP";

int main(int argc, char** argv){
    if (argc > 1) {
        printf("L'executable %s ne prend pas d'arguments.\n", argv[0]);
        return 1;
    }
    int len_msg = strlen(msg);
    int len_cle = strlen(cle);

    int pos_msg = 0;
    int pos_cle = 0;

    srand(time(NULL));


    while(pos_msg < len_msg || pos_cle < len_cle){
        if(rand() % 6 == 0 && pos_msg < len_msg){
            fprintf(stdout, "%c", msg[pos_msg++]);
            fflush(stdout);
        } else {
            fprintf(stderr, "%c", cle[pos_cle++]);
            fflush(stderr);
        }
    }

    fprintf(stdout, "\n");
    fprintf(stderr, "\n");

    return 0;
}

