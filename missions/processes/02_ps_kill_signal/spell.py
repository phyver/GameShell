#!/usr/bin/python3

from time import sleep
from random import randint
import os
import signal
import gettext
from sys import argv


TEXTDOMAIN = argv[1]

gettext.bindtextdomain(TEXTDOMAIN, localedir=os.environ.get("TEXTDOMAINDIR"))
gettext.textdomain(TEXTDOMAIN)


def spawn(a, b):
    print(gettext.gettext("You'll need to do better than that to kill my spell!"))
    p = os.fork()
    if p > 0:
        f = open(os.path.expandvars("$GSH_VAR/spell-term.pids"), mode="a")
        f.write(str(p) + "\n")


signal.signal(signal.SIGTERM, spawn)

coal = """
      *#@*
     $@%#\4
     &"_'%<@
      +8^@j
       #!v@
""".split("\n")

DELAY = 5

while True:
    sleep(DELAY)
    INDENT = randint(2, 15)
    for line in coal:
        print(" "*INDENT + line)
