#!/usr/bin/env python3

DEPTH=4
WIDTH=10
DIR="./"

from random import randrange
import hashlib
import os


def gen_maze(nb_path, stone):
    r = str(randrange(0, 2**128))

    def md5(s):
        return hashlib.md5(bytes(r+s, "UTF-8")).hexdigest()

    t = []
    p = []
    n = 0
    path = []
    while True:
        assert len(t) == len(p)
        if len(t) < DEPTH:
            t.append(0)
            # p.append(md5(str(t)))
            p.append(md5(str(t))[:randrange(8, 32)])
        else:
            while t:
                if t[-1] == WIDTH-1:
                    t.pop()
                    p.pop()
                else:
                    break
            if t:
                t[-1] += 1
                # p[-1] = md5(str(t))
                p[-1] = md5(str(t))[:randrange(8, 32)]
            else:
                break

        if len(t) == DEPTH:
            filename = os.path.join(DIR,*p)
            f = open(filename, mode="w")
            h = md5(filename)
            f.write(h[:randrange(4, 16)] + " " + stone + " " + h[16:randrange(20, 32)])
            f.close()


        else:
            os.mkdir(os.path.join(DIR,*p))

        if len(t) == DEPTH:
            if len(path) < nb_path:
                path.append(p[:])
            else:
                n += 1
                i = randrange(0, n)
                if i < nb_path:
                    path[i] = p[:]

    for p in path:
        print(os.path.join(*p))


if __name__ == "__main__":
    from sys import argv, exit
    if len(argv) != 6:
        print(f"""usage: {argv[0]} dir depth width nb_path stone
create a maze of given depth and width inside the given directory
all leaves are text files containing 'stone'
nb_path random file path are printed on the screen""")
        exit(1)
    DIR = argv[1]
    DEPTH = int(argv[2])
    WIDTH = int(argv[3])
    nb_path = int(argv[4])
    stone = argv[5]

    gen_maze(nb_path, stone)
