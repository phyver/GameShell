#!/usr/bin/python3
# ^^^ DON'T USE THE SHEBANG
#!/usr/bin/env python3
# as the process name will be "python3"

from sys import argv
from time import sleep
from random import randint

dir = argv[1]
nature = argv[2]
n = 0

while True:
    n = 1 - n
    name = f"{randint(0,2**15)}_{nature}"
    if n == 0:
        name = "." + name
    open(f"{dir}/{name}", mode="a").close()
    sleep(3)
