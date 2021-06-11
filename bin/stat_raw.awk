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

BEGIN {
  if (VERBOSE) {
    FORMAT_STRING="%3d %-40s %s %8s ";
  } else {
    FORMAT_STRING="%3d %0s%s %8s  ";
  }
}

/#NEW SESSION/ {
    print substr($0, 2);
    next
}

/#/ { next }         # ignore comments


$1 == current_mission && $2 == "START" { next; }

# $1 != current_mission { printf("\n"); }

!MISSION_NB || MISSION_NB == $1 {
  current_mission = $1;
  if (!previous_time) previous_time = $3+0;

  n = $1+0;

  if (VERBOSE) sprintf("missiondir -r %d", n) | getline dir;

  delta_t = human_time($3 - previous_time);
  previous_time = $3+0;

  # check checksum using the "checksum" script, that must be in the path
  sprintf("checksum \"%s#%s#%s#%s\"", UID, $1, $2, $3) | getline checksum;
  if (checksum != $4) {
    sum_c = "X";
  } else {
    sum_c = " ";
  }

  printf(FORMAT_STRING, n, dir, sum_c, delta_t);
}

(!MISSION_NB || MISSION_NB == $1) && $2 == "START" {
  printf("start\n");
  next;
}

(!MISSION_NB || MISSION_NB == $1) && $2 == "EXIT" {
  printf("exit\n");
  print "-----";
  current_mission = "";
  previous_time = "";
  next;
}

(!MISSION_NB || MISSION_NB == $1) && $2 == "CHECK_OOPS" {
  printf("failed\n");
  next;
}

(!MISSION_NB || MISSION_NB == $1) && $2 == "CHECK_OK" {
  printf("success\n");
  next;
}

!MISSION_NB || MISSION_NB == $1 {
  printf("%s\n", $2)
}
