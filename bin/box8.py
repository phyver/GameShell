#!/usr/bin/env python3

import sys
import getopt


LALIGN = "<"
RALIGN = ">"
CENTER = "^"


def text_width(B):
    if not B:
        return 0
    return max(map(len, B))


def text_height(B):
    return len(B)


def next_multiple(n, m):
    if n < 0:
        return 0
    tmp = n % m
    if tmp == 0:
        return n
    else:
        return n + m - tmp


def normalize_text(text, margin=(0, 2, 0, 2), width=None, height=None, align=LALIGN, fill_char=" "):
    if width is None:
        width = text_width(text)
    m_top, m_right, m_bottom, m_left = margin
    text = [""]*m_top + text + [""]*m_bottom
    th = text_height(text)
    if height is None:
        height = th-m_top-m_bottom

    if th < height:
        if align == LALIGN:
            text.extend([""] * (height-th))
        elif align == RALIGN:
            text = [""] * (height-th) + text
        else:
            h = (height-th) // 2
            text = [""] * h + text
            text.extend([""] * (height-th-h))

    template = fill_char*m_left + "{:" + fill_char + align + str(width) + "}" + fill_char*m_right
    for i in range(len(text)):
        text[i] = template.format(text[i])
    return text


def make_box(text, margin=(0, 0, 0, 0),
             UL="+", UM="-", UR="+",
             ML="|",         MR="|",
             LL="+", LM="-", LR="+",
             neg_padding=(0, 0, 0, 0),
             default_margin=(0, 0, 0, 0),
             fill_char=" ",
             align=LALIGN,
             descr=""):

    if margin is None:
        margin = default_margin

    if isinstance(UL, str):
        UL = UL.split("\n")
    if isinstance(UM, str):
        UM = UM.split("\n")
    if isinstance(UR, str):
        UR = UR.split("\n")

    if isinstance(ML, str):
        ML = ML.split("\n")
    if isinstance(MR, str):
        MR = MR.split("\n")

    if isinstance(LL, str):
        LL = LL.split("\n")
    if isinstance(LM, str):
        LM = LM.split("\n")
    if isinstance(LR, str):
        LR = LR.split("\n")

    # check basic sanity
    assert text_height(UL) == text_height(UR)   # == text_height(UM) don't check because of missing trailing spaces
    assert text_height(LL) == text_height(LR)   # == text_height(LM) don't check because of missing trailing spaces
    h_ML = text_height(ML)
    assert h_ML == text_height(MR)

    w_UL = text_width(UL)
    assert w_UL == text_width(LL)               # == text_width(ML) don't check because of missing trailing spaces
    # assert text_width(UR) == text_width(LR) == text_width(MR) usually not true because of missing trailing spaces
    w_UM = text_width(UM)
    assert w_UM == text_width(LM)

    np_top, np_right, np_bottom, np_left = neg_padding
    m_top, m_right, m_bottom, m_left = margin

    if isinstance(text, str):
        text = text.split("\n")

    # width of the frame consisting of UM / LM blocks
    UM_width = next_multiple(text_width(text) + m_right + m_left - np_right - np_left, w_UM)
    nb_UM = UM_width // w_UM
    tw = UM_width + np_right + np_left - m_right - m_left

    # height of the frame consisting of the ML / MR blocks
    ML_height = next_multiple(text_height(text) + m_top + m_bottom - np_top - np_bottom, text_height(ML))
    # nb_ML = ML_height // h_ML
    th = ML_height + np_top + np_bottom     # FIXME: tw / th are not uniform!

    text = normalize_text(text, margin=margin, width=tw, height=th, align=align, fill_char=fill_char)

    # Left and Right parts
    Left = []
    Right = []

    for i in range(text_height(UL) - np_top):
        Left.append(UL[i].rstrip(" ").ljust(w_UL, fill_char))
        Right.append(UR[i])

    for i in range(text_height(UL) - np_top, text_height(UL)):
        Left.append(UL[i].rstrip(" ").ljust(w_UL - np_left, fill_char))
        Right.append(UR[i][np_right:])

    h = h_ML
    # for i in range(text_height(text) - np_top - np_bottom):
    for i in range(ML_height):
        Left.append(ML[i % h].rstrip(" ").ljust(w_UL - np_left, fill_char))
        Right.append(MR[i % h][np_right:])

    for i in range(np_bottom):
        Left.append(LL[i].rstrip(" ").ljust(w_UL - np_left, fill_char))
        Right.append(LR[i][np_right:])

    for i in range(np_bottom, text_height(LL)):
        Left.append(LL[i].rstrip(" ").ljust(w_UL, fill_char))
        Right.append(LR[i])

    # Middle part
    Middle = []

    for i in range(text_height(UL) - np_top):
        Middle.append(UM[i] * nb_UM)

    Middle.extend(text)

    for i in range(np_bottom, text_height(LM)):
        Middle.append(LM[i] * nb_UM)

    for i in range(len(Middle)):
        # print(Left[i] + "  ,  " + Middle[i] + "  ,  " + Right[i])
        print(Left[i] + Middle[i] + Right[i])


########################################################################
# box designs

Hash_box = {
    "UL": "#", "UM": "#", "UR": "#",
    "ML": "#",            "MR": "#",
    "LL": "#", "LM": "#", "LR": "#",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Star_box = {
    "UL": "*", "UM": "*", "UR": "*",
    "ML": "*",            "MR": "*",
    "LL": "*", "LM": "*", "LR": "*",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

ADA_box = {
    "UL": "--", "UM": "-", "UR": "--",
    "ML": "--",            "MR": "--",
    "LL": "--", "LM": "-", "LR": "--",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

ADA2_box = {
    "UL": "--", "UM": "-", "UR": "",
    "ML": "--",            "MR": "",
    "LL": "--", "LM": "-", "LR": "",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

C_box = {
    "UL": "/*", "UM": "*", "UR": "*/",
    "ML": "/*",            "MR": "*/",
    "LL": "/*", "LM": "*", "LR": "*/",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

C2_box = {
    "UL": "/*", "UM": " ", "UR": "*/",
    "ML": "/*",            "MR": "*/",
    "LL": "/*", "LM": " ", "LR": "*/",
    "neg_padding": (1, 0, 1, 0),
    "default_margin": (0, 1, 0, 1),
}

C3_box = {
    "UL": "/*", "UM": " ", "UR": "*",
    "ML": " *",            "MR": "*",
    "LL": " *", "LM": " ", "LR": "*/",
    "neg_padding": (1, 0, 1, 0),
    "default_margin": (0, 1, 0, 1),
}

HTML_box = {
    "UL": "<!-- ", "UM": "-", "UR": " -->",
    "ML": "<!-- ",            "MR": " -->",
    "LL": "<!-- ", "LM": "-", "LR": " -->",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

HTML2_box = {
    "UL": "<!-- ", "UM": " ", "UR": " -->",
    "ML": "<!-- ",            "MR": " -->",
    "LL": "<!-- ", "LM": " ", "LR": " -->",
    "neg_padding": (1, 0, 1, 0),
    "default_margin": (0, 1, 0, 1),
}

CAML_box = {
    "UL": "(*", "UM": "*", "UR": "*)",
    "ML": "(*",            "MR": "*/",
    "LL": "(*", "LM": "*", "LR": "*/",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Ascii_box = {
    "UL": "+", "UM": "-", "UR": "+",
    "ML": "|",            "MR": "|",
    "LL": "+", "LM": "-", "LR": "+",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Double_Ascii_box = {
    "UL": [
        "+--",
        "| +"
    ],
    "UR": [
        "--+",
        "+ |"
    ],
    "UM": [
        "-",
        "-",
    ],
    "LL": [
        "| +",
        "+--",
    ],
    "LR": [
        "+ |",
        "--+",
    ],
    "LM": [
        "-",
        "-",
    ],
    "ML": [
        "| |",
    ],
    "MR": [
        "| |",
    ],
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Diamond_box = {
    "UL": [
        r"/ \ ",
        r"\ / ",
    ],
    "UR": [
        r"/ \ ",
        r"\ / ",
    ],
    "UM": [
        r"/ \ ",
        r"\ / ",
    ],
    "LL": [
        r"/ \ ",
        r"\ / ",
    ],
    "LR": [
        r"/ \ ",
        r"\ / ",
    ],
    "LM": [
        r"/ \ ",
        r"\ / ",
    ],
    "ML": [
        r"/ \ ",
        r"\ / ",
    ],
    "MR": [
        r"/ \ ",
        r"\ / ",
    ],
    "neg_padding": (0, 0, 0, 1),
    "default_margin": (1, 1, 1, 1),
}

DoubleDiamond_box = {
    "UL": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "UR": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "UM": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r" \/ ",
        r"    ",
        r"    ",
    ],
    "LL": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "LR": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "LM": [
        r"    ",
        r"    ",
        r" /\ ",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "ML": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "MR": [
        r" /\ ",
        r"//\\",
        r"\\//",
        r"//\\",
        r"\\//",
        r" \/ ",
    ],
    "neg_padding": (2, 0, 2, 0),
    "default_margin": (1, 2, 1, 2),
    "descr": "hjw @ https://www.asciiart.eu/art-and-design/borders"
}

Braid_box = {
    "UL": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "UR": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "UM": [
        r"\\  //",
        r" \\// ",
        r"",
    ],
    "LL": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "LR": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "LM": [
        r"",
        r" //\\ ",
        r"//  \\",
    ],
    "ML": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "MR": [
        r"\\//",
        r" // ",
        r"//\\",
    ],
    "neg_padding": (1, 0, 1, 0),
    "default_margin": (0, 1, 0, 1),
}


Unicode_simple_box = {
    "UL": "┌", "UM": "─", "UR": "┐",
    "ML": "│",            "MR": "│",
    "LL": "└", "LM": "─", "LR": "┘",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (1, 1, 1, 1),
}

Inverted_corners_box = {
    "UL": [
        "  |",
        "--+",
    ],
    "UR": [
        "|  ",
        "+--",
    ],
    "UM": [
        " ",
        "-",
    ],
    "LL": [
        "--+",
        "  |",
    ],
    "LR": [
        "+--",
        "|  ",
    ],
    "LM": [
        "-",
        " ",
    ],
    "ML": [
        "  |",
    ],
    "MR": [
        "|  ",
    ],
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}
Unicode_inverted_corners_box = {
    "UL": [
        " │",
        "─┼",
    ],
    "UR": [
        "│ ",
        "┼─",
    ],
    "UM": [
        " ",
        "─",
    ],
    "LL": [
        "─┼",
        " │",
    ],
    "LR": [
        "┼─",
        "│ ",
    ],
    "LM": [
        "─",
        " ",
    ],
    "ML": [
        " │",
    ],
    "MR": [
        "│ ",
    ],
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Unicode_round_box = {
    "UL": "╭", "UM": "─", "UR": "╮",
    "ML": "│",            "MR": "│",
    "LL": "╰", "LM": "─", "LR": "╯",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Unicode_bold_box = {
    "UL": "┏", "UM": "━", "UR": "┓",
    "ML": "┃",            "MR": "┃",
    "LL": "┗", "LM": "━", "LR": "┛",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Unicode_double_box = {
    "UL": "╔", "UM": "═", "UR": "╗",
    "ML": "║",            "MR": "║",
    "LL": "╚", "LM": "═", "LR": "╝",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Unicode_shadow_box = {
    "UL": "┌", "UM": "─", "UR": "┒",
    "ML": "│",            "MR": "┃",
    "LL": "┕", "LM": "━", "LR": "┛",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Unicode_shadow2_box = {
    "UL": "┌", "UM": "─", "UR": "╖",
    "ML": "│",            "MR": "║",
    "LL": "╘", "LM": "═", "LR": "╝",
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (0, 1, 0, 1),
}

Wavy_box = {
    "UL": [
        r"   .-.   ",
        r" .'   `._",
        r"(    .   ",
        r" `.   `._",
    ],
    "UR": [
        r"   .-.   ",
        r"_.'   `. ",
        r"   .    )",
        r"_.'   .' ",
    ],
    "UM": [
        r"  .-.   ",
        r".'   `._",
        r"  .-.   ",
        r".'   `._",
    ],
    "LL": [
        r"   )    )",
        r" ,'   .' ",
        r"(    '  _",
        r" `.   .' ",
        r"   `-'   ",
    ],
    "LR": [
        r"(    (   ",
        r" `.   `. ",
        r"_  `    )",
        r" `.   .' ",
        r"   `-'   ",
    ],
    "LM": [
        r"       _",
        r"`.   .' ",
        r"  `-'  _",
        r"`.   .' ",
        r"  `-'   ",
    ],
    "ML": [
        r"   )    )",
        r" ,'   ,' ",
        r"(    (   ",
        r" `.   `. ",
    ],
    "MR": [
        r"(    (   ",
        r" `.   `. ",
        r"   )    )",
        r" .'   .' ",
    ],
    "neg_padding": (0, 0, 0, 0),
    "default_margin": (2, 2, 1, 2),
    "descr": "Normand Veilleux @ https://asciiart.website/index.php?art=art%20and%20design/borders",
}

Parchment_box = {
    "UL": [
        r"      _____",
        r"    / \    ",
        r"   |   |   ",
        r"    \_ |   ",
    ],
    "UR": [
        r"_  ",
        r" \.",
        r" |.",
        r" |.",
    ],
    "UM": [
        r"_",
        r" ",
        r" ",
        r" ",
    ],
    "LL": [
        r"       |   ",
        r"       |  /",
        r"       \_/_",
    ],
    "LR": [
        r"_|___ ",
        r"    /.",
        r"___/. ",
    ],
    "LM": [
        r"_",
        r" ",
        r"_",
    ],
    "ML": [
        r"       |   ",
    ],
    "MR": [
        r" |.",
    ],
    "neg_padding": (3, 1, 0, 3),
    "default_margin": (1, 1, 0, 1),
    "descr": "dc @ https://www.asciiart.eu/art-and-design/borders"
}

Scroll_box = {
    "UL": [
        r" __^__ ",
        r"( ___ )",
    ],
    "UR": [
        r" __^__ ",
        r"( ___ )",
    ],
    "UM": [
        r" ",
        r"-",
    ],
    "LL": [
        r" |___| ",
        r"(_____)",
    ],
    "LR": [
        r" |___| ",
        r"(_____)",
    ],
    "LM": [
        r" ",
        r"-",
    ],
    "ML": [
        r" | / | ",
    ],
    "MR": [
        r" | \ | ",
    ],
    "neg_padding": (0, 1, 1, 1),
    "default_margin": (1, 2, 1, 2),
    "descr": "coded by Thomas Jensen <boxes@thomasjensen.com> (boxes)",
}

Parchment2_box = {
    "UL": [
        r"     ___",
        r"()==( ",
        r"     '__",
    ],
    "UR": [
        r"_     ",
        r"(@==()",
        r"_'|   ",
    ],
    "UM": [
        r"_",
        r" ",
        r"_",
    ],
    "LL": [
        r"     __)",
        r"()==(   ",
        r"     '--",
    ],
    "LR": [
        r"__|    ",
        r" (@==()",
        r"-'     ",
    ],
    "LM": [
        r"_",
        r" ",
        r"-",
    ],
    "ML": [
        r"       |",
    ],
    "MR": [
        r"  |",
    ],
    "neg_padding": (0, 2, 0, 0),
    "default_margin": (1, 1, 0, 1),
}

Parchment3_box = {
    "UL": [
        r"  ,---",
        r" (_\  ",
    ],
    "UR": [
        r"----.  ",
        r"     \ ",
    ],
    "UM": [
        r"-",
        r" ",
    ],
    "LL": [
        r"   _| ",
        r"  (_/_",
        r"      ",
        r"      ",
        r"      ",
    ],
    "LR": [
        r"      |",
        r"(*)___/",
        r" \\    ",
        r"  ))   ",
        r"  ^    ",
    ],
    "LM": [
        r" ",
        r"_",
        r" ",
        r" ",
        r" ",
    ],
    "ML": [
        r"    | ",
    ],
    "MR": [
        r"      |",
    ],
    "neg_padding": (1, 5, 1, 0),
    "default_margin": (1, 0, 1, 1),
}
# cf http://ascii.co.uk/art/scroll

Parchment4_box = {
    "UL": [
        r' /"\/\_..',
        r'(     _||',
        r' \_/\/ ||',
    ],
    "UR": [
        r'-._/\/"\ ',
        r'||_     )',
        r'|| \/\_/ '
    ],
    "UM": [
        r"-",
        r" ",
        r" ",
    ],
    "LL": [
        r' /"\/\_|-',
        r'(     _| ',
        r' \_/\/ `-'
    ],
    "LR": [
        r'-|_/\/"\ ',
        r' |_     )',
        r"-' \/\_/ ",
    ],
    "LM": [
        r"-",
        r" ",
        r"-",
    ],
    "ML": [
        r"       ||",
    ],
    "MR": [
        r"||",
    ],
    "neg_padding": (2, 0, 0, 0),
    "default_margin": (1, 3, 1, 3),
    "descr": "coded by Tristano Ajmone <tajmone@gmail.com> (boxes)",
}

Parchment5_box = {
    "UL": [
        r"     __",
        r"    /\ ",
        r"(O)===)",
        r"    \/'",
        r"    (  ",
    ],
    "UR": [
        r"_       ",
        r" \      ",
        r"><)==(O)",
        r"'/       ",
        r"(        ",
    ],
    "UM": [
        r"__",
        r"  ",
        r"><",
        r"''",
        r"  ",
    ],
    "LL": [
        r"    /\'",
        r"(O)===)",
        r"    \/_",
    ],
    "LR": [
        r"'\      ",
        r"><)==(O)",
        r"_/      ",
    ],
    "LM": [
        r"''",
        r"><",
        r"__",
    ],
    "ML": [
        r"     ) ",
        r"    (  ",
    ],
    "MR": [
        r" )    ",
        r"(     ",
    ],
    "neg_padding": (1, 0, 0, 1),
    "default_margin": (1, 2, 1, 2),
    "descr": "https://www.asciiart.eu/art-and-design/borders"
}

Parchment6_box = {
    "UL": [
        r"  .------",
        r" /  .-.  ",
        r"|  /   \ ",
        r"| |\_.  |",
        r"|\|  | /|",
        r"| `---' |",
    ],
    "UR": [
        r"------.  ",
        r"  .-.  \ ",
        r" /   \  |",
        r"|    /| |",
        r"|\  | |/|",
        r"| `---' |",
    ],
    "UM": [
        r"-",
        r" ",
        r" ",
        r" ",
        r" ",
        r" ",
    ],
    "LL": [
        r"|       |",
        r"\       |",
        r" \     / ",
        r"  `---'  ",
    ],
    "LR": [
        r"|       |",
        r"|       /",
        r" \     / ",
        r"  `---'  ",
    ],
    "LM": [
        r"-",
        r" ",
        r" ",
        r" ",
    ],
    "ML": [
        "|       |"
    ],
    "MR": [
        "|       |"
    ],
    "neg_padding": (5, 0, 0, 0),
    "default_margin": (2, 3, 1, 3),
    "descr": "https://www.asciiart.eu/art-and-design/borders"
}

Parchment7_box = {
    "UL": [
        r"         ",
        r"         ",
        r"         ",
        r"         ",
        r"  .------",
        r" /  .-.  ",
        r"|  /   \ ",
        r"| |\_.  |",
        r"|\|  | /|",
        r"| `---' |",


    ],
    "UR": [
        r"  .---.  ",
        r" /  .  \ ",
        r"|\_/|   |",
        r"|   |  /|",
        r"------' |",
        r"        |",
        r"        |",
        r"        |",
        r"        |",
        r"        |",
    ],
    "UM": [
        r" ",
        r" ",
        r" ",
        r" ",
        r"-",
        r" ",
        r" ",
        r" ",
        r" ",
        r" ",
    ],
    "LL": [
        r"|       |",
        r"|       |",
        r"\       |",
        r" \     / ",
        r"  `---'  ",
    ],
    "LR": [
        r"       /",
        r"------' ",
        r"        ",
        r"        ",
        r"        ",
    ],
    "LM": [
        r" ",
        r"-",
        r" ",
        r" ",
        r" ",
    ],
    "ML": [
        "|       |"
    ],
    "MR": [
        "        |"
    ],
    "neg_padding": (5, 6, 1, 0),
    "default_margin": (2, 4, 2, 3),
    "descr": "https://www.asciiart.eu/art-and-design/borders"
}

Scroll2_box = {
    "UL": [
        r" / ~~~~~",
        r"|  /~~\ ",
        r"|\ \   |",
        r"| \   /|",
        r"|  ~~  |",
    ],
    "UR": [
        r"~~~~~ \ ",
        r" /~~\  |",
        r"|   / /|",
        r"|\   / |",
        r"|  ~~  |",
    ],
    "UM": [
        r"~",
        r" ",
        r" ",
        r" ",
        r" ",
    ],
    "LL": [
        r" \     |",
        r"  \   / ",
        r"   ~~~  ",
    ],
    "LR": [
        r"|     / ",
        r" \   /  ",
        r"  ~~~   ",
    ],
    "LM": [
        r"~",
        r" ",
        r" ",
    ],
    "ML": [
        r"|      |",
    ],
    "MR": [
        r"|      |",
    ],
    "neg_padding": (4, 0, 0, 0),
    "default_margin": (1, 2, 1, 2),
    "descr": "coded by Thomas Jensen <boxes@thomasjensen.com> (boxes)",
}

Twisted_box = {
    "UL": [
        r"._____. ._____. .__",
        r"| ._. | | ._. | | .",
        r"| !_| |_|_|_! | | !",
        r"!___| |_______! !__",
        r".___|_|_| |________",
        r"| ._____| |________",
        r"| !_! | | |        ",
        r"!_____! | |        ",
        r"._____. | |        ",
        r"| ._. | | |        ",
    ],
    "UR": [
        r"__. ._____. ._____.",
        r". | | ._. | | ._. |",
        r"! | | !_| |_|_|_! |",
        r"__! !___| |_______!",
        r"________|_|_| |___.",
        r"____________| |_. |",
        r"        | | ! !_! |",
        r"        | | !_____!",
        r"        | | ._____.",
        r"        | | | ._. |",
    ],
    "UM": [
        r"_",
        r"_",
        r"_",
        r"_",
        r"_",
        r"_",
        r" ",
        r" ",
        r" ",
        r" ",
    ],
    "LL": [
        r"| !_! | | |        ",
        r"!_____! | |        ",
        r"._____. | |        ",
        r"| ._. | | |        ",
        r"| !_| |_|_|________",
        r"!___| |____________",
        r".___|_|_| |___. .__",
        r"| ._____| |_. | | .",
        r"| !_! | | !_! | | !",
        r"!_____! !_____! !__",
    ],
    "LR": [
        r"        | | ! !_! |",
        r"        | | !_____!",
        r"        | | ._____.",
        r"        | | | ._. |",
        r"________| |_|_|_! |",
        r"________| |_______!",
        r"__. .___|_|_| |___.",
        r". | | ._____| |_. |",
        r"! | | !_! | | !_! |",
        r"__! !_____! !_____!",
    ],
    "LM": [
        r" ",
        r" ",
        r" ",
        r" ",
        r"_",
        r"_",
        r"_",
        r"_",
        r"_",
        r"_",
    ],
    "ML": [
        r"| | | | | |        ",
    ],
    "MR": [
        r"        | | | | | |",
    ],
    "neg_padding": (4, 8, 4, 8),
    "default_margin": (1, 2, 1, 2),
    "descr": "design by Michael Naylor, coded by Tristano Ajmone <tajmone@gmail.com> (boxes)",
}

Twinkle_box = {
    "UL": [
        r"   \  :  /    ",
        r"`. __/ \__ .' ",
        r"_ _\     /_ _ ",
        r"   /_   _\    ",
        r" .'  \ /  `.  ",
        r"   /  |  \    ",
        r"      |       ",
    ],
    "UR": [
        r"   \  :  /   ",
        r"`. __/ \__ .'",
        r"_ _\     /_ _",
        r"   /_   _\   ",
        r" .'  \ /  `. ",
        r"   /  |  \   ",
        r"      |      ",
    ],
    "UM": [
        r"   \  :  /    ",
        r"`. __/ \__ .' ",
        r"_ _\     /_ _ ",
        r"   /_   _\    ",
        r" .'  \ /  `.  ",
        r"   /  :  \    ",
        r"              ",
    ],
    "LL": [
        r"   \  |  /    ",
        r"`. __/ \__ .' ",
        r"_ _\     /_ _ ",
        r"   /_   _\    ",
        r" .'  \ /  `.  ",
        r"   /  :  \    ",
    ],
    "LR": [
        r"   \  |  /   ",
        r"`. __/ \__ .'",
        r"_ _\     /_ _",
        r"   /_   _\   ",
        r" .'  \ /  `. ",
        r"   /  :  \   ",
    ],
    "LM": [
        r"   \  :  /    ",
        r"`. __/ \__ .' ",
        r"_ _\     /_ _ ",
        r"   /_   _\    ",
        r" .'  \ /  `.  ",
        r"   /  :  \    ",
    ],
    "ML": [
        r"   \  |  /    ",
        r"`. __/ \__ .' ",
        r"_ _\     /_ _ ",
        r"   /_   _\    ",
        r" .'  \ /  `.  ",
        r"   /  |  \    ",
        r"      |       ",

    ],
    "MR": [
        r"   \  |  /   ",
        r"`. __/ \__ .'",
        r"_ _\     /_ _",
        r"   /_   _\   ",
        r" .'  \ /  `. ",
        r"   /  |  \   ",
        r"      |      ",
    ],
    "neg_padding": (1, 0, 0, 1),
    "default_margin": (2, 4, 2, 4),
    "descr": "hjw @ https://www.asciiart.eu/art-and-design/borders"
}

Test_box = {
    "UL": [
        r"+---->",
        r"|",
        r"v",
    ],
    "UM": [
        r"<--->",
        r"     ",
        r"     ",
    ],
    "UR": [
        r"<--+",
        r"   |",
        r"   v",
    ],
    "ML": [
        r"^    ",
        r"|    ",
        r"|    ",
        r"|    ",
        r"v  ",
    ],
    "MR": [
        r"   ^",
        r"   |",
        r"   |",
        r"   |",
        r"   v",
    ],
    "LL": [
        r"^     ",
        r"|     ",
        r"|     ",
        r"|     ",
        r"|     ",
        r"+---->",
    ],
    "LM": [
        r"     ",
        r"     ",
        r"     ",
        r"     ",
        r"     ",
        r"<--->",
    ],
    "LR": [
        r"   ^",
        r"   |",
        r"   |",
        r"   |",
        r"   |",
        r"<--+",
    ],

    "neg_padding": (2, 3, 5, 5),
    "default_margin": (0, 0, 0, 0),
}

BOXES = {
    "ASCII": Ascii_box,
    "ASCII_double": Double_Ascii_box,
    "Braid": Braid_box,
    "DoubleDiamond": DoubleDiamond_box,
    "Diamond": Diamond_box,
    "hash": Hash_box,
    "star": Star_box,
    "ADA": ADA_box,
    "ADA2": ADA2_box,
    "C": C_box,
    "C2": C2_box,
    "C3": C3_box,
    "HTMl": HTML_box,
    "HTMl2": HTML2_box,
    "CAMl": CAML_box,
    "Unicode": Unicode_simple_box,
    "Unicode_round": Unicode_round_box,
    "Unicode_double": Unicode_double_box,
    "Unicode_bold": Unicode_bold_box,
    "Unicode_shadow": Unicode_shadow_box,
    "Unicode_shadow2": Unicode_shadow2_box,
    "Wavy": Wavy_box,
    "Parchment": Parchment_box,
    "Parchment2": Parchment2_box,
    "Parchment3": Parchment3_box,
    "Parchment4": Parchment4_box,
    "Parchment5": Parchment5_box,
    "Parchment6": Parchment6_box,
    "Parchment7": Parchment7_box,
    "Scroll": Scroll_box,
    "Scroll2": Scroll2_box,
    "Unicode_inverted": Unicode_inverted_corners_box,
    "Inverted": Inverted_corners_box,
    "Twisted": Twisted_box,
    "Twinkle": Twinkle_box,
    "Test": Test_box,
}


LOREM = """
Lorem ipsum dolor sit amet, consectetur adipisicing
elit, sed do eiusmod tempor incididunt ut labore et
dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex
ea commodo consequat.  Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat
cupidatat non proident, sunt in culpa qui officia
deserunt mollit anim id est laborum.
""".strip("\n")


def rectangle(w, h):
    text = ["*" * w]
    text.extend(["*" + "."*(w-2) + "*"] * (h-2))
    text.append("*" * w)
    return text


def Box(text, margin, box, align=LALIGN, fill_char=" "):
    make_box(text, margin, align=align, **box, fill_char=fill_char)


def error(msg, retcode):
    sys.stderr.write("\n*** " + msg + " ***\n\n")
    sys.exit(retcode)


def main():

    # parsing the command line arguments
    short_options = "hb:lm:c:LRC"

    long_options = ["help", "box=", "list", "margin=", "lorem", "rect=",
                    "fill-char=", "left-align", "right-align", "center"]

    try:
        opts, args = getopt.getopt(sys.argv[1:], short_options, long_options)
    except getopt.GetoptError as err:
        error(str(err), 1)

    # default values
    box = "ASCII"
    margin = None
    text = None
    fill_char = " "
    align = LALIGN

    for o, a in opts:
        if o in ["-h", "--help"]:
            print("""
Usage: {prog:} [options]
    adds a "box" around UTF-8 encoded stdin
    inspired (copied) from Thomas Jensen's program "boxes"
    (https://boxes.thomasjensen.com/)
    that didn't support UTF-8 at the time

Options:
   -h,  --help                      display this message
   -b <design>, --box=<design>      choose box design
   -l, --list                       show available designs
   -m <...>, --margin=<...>         adds margin around text (top, right, bottom, left)
                                        default: use design's default
   -c <.>, --fill-char=<.>          use this character as filler
                                        default: use space
   -L, --left-align                 left/top align text in the box (default)
   -R, --right-align                right/bottom align text in the box
   -C, --center                     center text in the box
   --lorem                          test a design with Lorem text
   --rectange=<w>x<h>               test a design using a rectangle for text
""".format(prog=sys.argv[0]))
            sys.exit(0)
        elif o in ["-l", "--list"]:
            designs = sorted(list(BOXES.keys()))
            for b in designs:
                print("*"*72)
                m = ",".join(map(str, BOXES[b]["default_margin"]))
                print("design: '{}' (default margin={})".format(b, m))
                d = BOXES[b].get("descr", "")
                if d:
                    print(d)
                print("")
                if text is None:
                    text = LOREM
                Box(text, margin, BOXES[b], align=align, fill_char=fill_char)
                print("")
            sys.exit(0)
        elif o in ["-m", "--margin"]:
            try:
                tmp = tuple(map(int, a.split(",")))
                assert len(tmp) == 4
                margin = tmp
            except Exception as err:
                error("Invalid margin: '{}' ({})".format(a, err), 1)
        elif o in ["-b", "--box"]:
            if a in BOXES:
                box = a
            else:
                error("Unknown box design: '{}'".format(a))
        elif o in ["--lorem"]:
            text = LOREM
        elif o in ["--rect"]:
            try:
                w, h = a.split("x")
                w = int(w)
                h = int(h)
                text = rectangle(w, h)
            except Exception as err:
                error("Invalid rectangle specification: '{}' ({})".format(a, err), 1)
        elif o in ["-L", "--left-align"]:
            align = LALIGN
        elif o in ["-R", "--right-align"]:
            align = RALIGN
        elif o in ["-C", "--center"]:
            align = CENTER
        elif o in ["-c", "--fill-char"]:
            assert len(a) == 1
            fill_char = a
        else:
            error("You shouldn't see this!!!", 2)

    if text is None:
        text = []
        for l in sys.stdin:
            text.append(l.rstrip("\n"))

    Box(text, margin, BOXES[box], align=align, fill_char=fill_char)


if __name__ == "__main__":
    main()
