#!/usr/bin/python3

from time import sleep
from random import randint


coal = """
      *#@*
     &_**/~
       !$-#
""".split("\n")

DELAY = 3

while True:
    INDENT = randint(2, 15)
    for line in coal:
        print(" "*INDENT + line)
    sleep(DELAY)
