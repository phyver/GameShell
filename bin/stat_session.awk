#!/usr/bin/awk -f

function human_time(seconds) {
    if (seconds >= 24*3600) {
        return sprintf("%dd", int(seconds/24*3600))
    }
    hours = int(seconds / 3600);
    seconds = seconds % 3600;
    minutes = int(seconds / 60);
    seconds = seconds % 60;
    return sprintf("%d:%02d:%02d", hours, minutes, seconds);
}

/#/ { next }         # ignore comments

# initialize starting time, and last timestamp (only done on the first line)
!start_time {
    start_time = $3;
    last_time = $3;
    nb_restart = 1;
}

# increment game_time, but not when the game has been exited
last_action != "EXIT" { game_time += $3 - last_time; }

# update last_time on all lines
{
    last_time = $3;
}

# count number of sessions
last_action == "EXIT" && $2 == "START" {
    nb_restart++;
}

$2 ~ /AUTH_FAILURE/ {
    auth_failure++;
}

$2 == "SKIP" {
    skipped[nb_skipped++] = $1;
}

$2 == "CANCEL_DEP_PB" {
    cancelled[nb_cancelled++] = $1;
}

last_action == "AUTO" && $2 == "CHECK_OK" {
    auto_passed[nb_auto_passed++] = $1;
}

last_action != "AUTO" && $2 == "CHECK_OK" {
    passed[nb_passed++] = $1;
}

# update last_action once everything has been processed
{
    last_action = $2;
}

END {
    print "total time:", human_time(last_time - start_time);
    printf("game time: %s in %d session%s\n", human_time(game_time), nb_restart, nb_restart>1?"s":"");

    if (nb_auto_passed) {
        printf("%d mission%s passed using the auto.sh script: ", nb_auto_passed, nb_auto_passed>1?"s":"");
        for (i=0; i< nb_auto_passed; i++) {
            if (i > 0) printf(", ");
            printf("%d", auto_passed[i]);
        }
        printf("\n");
    }

    if (nb_passed) {
        printf("%d mission%s passed", nb_passed, nb_passed>1?"s":"");
        for (i=0; i<nb_passed; i++) {
            if (i == 0) {
                printf(": ");
            } else {
                printf(", ");
            }
            printf("%d", passed[i]);
        }
        printf("\n");
    }

    if (nb_skipped) {
        printf("%d mission%s skipped: ", nb_skipped, nb_skipped>1?"s":"");
        for (i=0; i< nb_skipped; i++) {
            if (i > 0) printf(", ");
            printf("%d", skipped[i]);
        }
        printf("\n");
    }

    if (nb_cancelled) {
        printf("%d mission%s cancelled for missing dependencies: ", nb_cancelled, nb_cancelled>1?"s":"");
        for (i=0; i< nb_cancelled; i++) {
            if (i > 0) printf(", ");
            printf("%d", cancelled[i]);
        }
        printf("\n");
    }

    if (auth_failure) {
        printf("%d authentification failure%s\n", auth_failure, auth_failure>1?"s":"");
    }

}
