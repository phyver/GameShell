#!/usr/bin/python3

from time import sleep
from random import randint
import os
import signal
import gettext
from sys import argv


TEXTDOMAIN = argv[1]

gettext.bindtextdomain(os.environ.get(TEXTDOMAIN), localedir=os.environ.get("TEXTDOMAINDIR"))
gettext.textdomain(os.environ.get(TEXTDOMAIN))


def spawn(a, b):
    print(gettext.gettext("You'll need to do better than that!"))
    os.fork()


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
    INDENT = randint(2, 15)
    for line in coal:
        print(" "*INDENT + line)
    sleep(DELAY)
