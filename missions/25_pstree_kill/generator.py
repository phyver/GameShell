#!/usr/bin/python3
# ^^^ DON'T USE THE SHEBANG
#!/usr/bin/env python3
# as the process name will be "python3"

from sys import argv
from time import sleep
from random import randint
import os

delay = int(argv[1])
logfile = argv[2]
dir = argv[3]
nature = argv[4]
n = 0

open(logfile, mode="w").close()

sleep(delay)
while True:
    n = 1 - n
    name = f"{randint(0,2**15)}_{nature}"
    if n == 0:
        name = "." + name
    open(f"{dir}/{name}", mode="a").close()
    log = open(logfile, mode="a")
    log.write(f"{name}\n")
    log.close()
    sleep(3)
