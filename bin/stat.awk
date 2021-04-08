#!/usr/bin/awk -f

function human_time(seconds) {
    days = int(seconds / (3600*24));
    seconds = seconds % (3600*24);
    hours = int(seconds / 3600);
    seconds = seconds % 3600;
    minutes = int(seconds / 60);
    seconds = seconds % 60;

    r = "";
    if (days > 0) r = r "" days " jour(s) ";
    if (hours > 0) r = r "" hours " heure(s) ";
    if (minutes > 0) r = r "" minutes " minutes(s) ";
    if (seconds > 0) r = r "" seconds " seconde(s) ";
    if (r == "") r = "0 seconde";
    return r;
    }

BEGIN {
    initial_time = 0;
    last_mission = 0;
    }

/\s*#/ { next }         # ignore comments

{
    current_time = $3+0;
    nb_mission = $1+0;
    if (nb_mission > last_mission) {
        last_mission = nb_mission;
    }
    # check actual checksum function in gash
    cmd = "echo -n \"" GASH_UID "#" $1 "#" $2 "#" $3 "\" | sha1sum | cut -c 1-40"
    cmd | getline checksum;
    # if (checksum != $4) {
    #     print "CHECKSUM PROBLEM : ";
    #     print "  expected " $4;
    #     print "       got " checksum;
    #     print "cmd = " cmd;
    # }
}


/(RE)?START/ {
    if (initial_time == 0) {
        initial_time = $3;
    }

    if (M[nb_mission][n]["result"] == "") {
        M[nb_mission][n]["stop"] =  current_time;
        M[nb_mission][n]["result"] = "EXIT";
        }

    n = ++M[nb_mission]["nb_tries"];
    M[nb_mission][n]["start"] =  current_time;
    next;
}


/CHECK_(OK|OOPS)|META_SAVE|PAUSE|SAVE|PASS/ {
    M[nb_mission][n]["stop"] =  current_time;
    M[nb_mission][n]["result"] = $2;
    next;
}

{
    print "***** PROBLEME *****";
}

END {

    print "UID : " GASH_UID;
    cmd = "date -d @" initial_time;
    cmd | getline tmp_date
    print "début du TP : " tmp_date

    if (M[nb_mission][n]["result"] == "") {
        M[nb_mission][n]["stop"] =  current_time;
        M[nb_mission][n]["result"] = "EXIT";
        }

    for (nb_mission=1; nb_mission <= last_mission; nb_mission++) {
        nb_tries = M[nb_mission]["nb_tries"];
        if (!nb_tries) {
            print "aucun essai pour cette mission !!!";
            continue;
        }
        print "Mission " nb_mission " : " nb_tries " essai(s)";
        for (i=1; i<=nb_tries; i++) {
            print "  essai " i " : " human_time(M[nb_mission][i]["stop"] - M[nb_mission][i]["start"]) ": " M[nb_mission][i]["result"];
            }
        print "";
        }

    cmd = "date -d @" current_time;
    cmd | getline tmp_date
    print "fin du TP : " tmp_date

    print "Temps total : " human_time(current_time - initial_time);
    }
