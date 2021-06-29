#!/usr/bin/awk -f

function _(s) {
    sprintf("gettext '%s'", s) | getline msg;
    if (!msg) {
        return s;
    } else {
        return msg;
    }
}

function _n(sing, plur, nb) {
    sprintf("ngettext '%s' '%s' %d", sing, plur, nb) | getline msg;
    if (!msg) {
        return s;
    } else {
        return msg;
    }
}

function human_time(seconds) {
    if (seconds >= 24*3600) {
        return sprintf("%.1f %s", seconds/(24*3600), _("days"))
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
    printf(_("total time: %s") "\n", human_time(last_time - start_time));
    fmt = _n("game time: %s in %d session",
             "game time: %s in %d sessions",
             nb_restart);
    printf(fmt "\n", human_time(game_time), nb_restart);

    if (nb_auto_passed) {
        fmt = _n("%d mission passed using the auto.sh script:",
                 "%d missions passed using the auto.sh script:",
                 nb_auto_passed);
        printf(fmt " ", nb_auto_passed);
        for (i=0; i< nb_auto_passed; i++) {
            if (i > 0) printf(", ");
            printf("%d", auto_passed[i]);
        }
        printf("\n");
    }

    if (nb_passed) {
        fmt = _n("%d mission passed:",
                 "%d missions passed:",
                 nb_passed);
        printf(fmt " ", nb_passed);
        for (i=0; i<nb_passed; i++) {
            if (i > 0) {
                printf(", ");
            }
            printf("%d", passed[i]);
        }
        printf("\n");
    }

    if (nb_skipped) {
        fmt = _n("%d mission skipped:",
                 "%d missions skipped:",
                 nb_skipped);
        printf(fmt " ", nb_skipped);
        for (i=0; i< nb_skipped; i++) {
            if (i > 0) printf(", ");
            printf("%d", skipped[i]);
        }
        printf("\n");
    }

    if (nb_cancelled) {
        fmt = _n("%d mission cancelled for missing dependencies:",
                 "%d missions cancelled for missing dependencies:",
                 nb_cancelled);
        printf(fmt " ", nb_cancelled);
        for (i=0; i< nb_cancelled; i++) {
            if (i > 0) printf(", ");
            printf("%d", cancelled[i]);
        }
        printf("\n");
    }

    if (auth_failure) {
        fmt = _n("%d authentification failure",
                 "%d authentification failures",
                 auth_failure);
        printf(fmt "\n", auth_failure);
    }

}
