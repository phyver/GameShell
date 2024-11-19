#!/usr/bin/awk -f

/INCLUDE/ {
    filename = $2
    if ((getline < filename) < 0) {
        print "ERROR: file", filename, "not found" > "/dev/stderr" ;
        exit 1
    }
    close(filename)
    while (getline l < filename) {
        print l
    }
    next
}

{print}
