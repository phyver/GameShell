#!/usr/bin/env python3

msg = "LACLESECRETEESTSURSTDERR"
cle = ("MRGLPZYMAMLAJNBWRQPYACQBDYUFWQFUWVXQELCCGCJZUEJUEZ"
       "XLDYQPVHLHGLXKZJAAUKKFCTQJQKMMCNLUUEFFYEYPHNWCMKDM"
       "BKQAJPSHGBTJJQKDAAPCWFHTKGLTWRFTEWMPDHCHQNVVLHDWNM"
       "LFCLEAZWCQLVBXFFRRZMMJGLMKEVUXXDHUCHWAYQJFWAUYEHUP")

if __name__ == "__main__":
    from sys import argv, exit, stderr
    from random import randint

    if len(argv) > 1:
        print(f"L'executable {argv[0]} ne prend pas d'arguments.")
        exit(1)

    i, j = 0, 0
    while i < len(msg) or j < len(cle):

        if j >= len(cle) or (randint(0, len(msg)+len(cle)) < len(msg) and i < len(msg)):
            print(msg[i], end="", flush=True)
            i += 1
        else:
            print(cle[j], end="", file=stderr, flush=True)
            j += 1
    print("")
    print("", file=stderr)
