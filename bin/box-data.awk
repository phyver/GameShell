BEGIN {
    n = 0;
    BOXES[n++] = "ADA";
    BOXES[n++] = "ADA2";
    BOXES[n++] = "ASCII";
    BOXES[n++] = "Braid";
    BOXES[n++] = "C";
    BOXES[n++] = "C2";
    BOXES[n++] = "C3";
    BOXES[n++] = "CAMl";
    BOXES[n++] = "Diamond";
    BOXES[n++] = "DoubleDiamond";
    BOXES[n++] = "HTML";
    BOXES[n++] = "HTMl2";
    BOXES[n++] = "Inverted";
    BOXES[n++] = "Parchment1";
    BOXES[n++] = "Parchment2";
    BOXES[n++] = "Parchment3";
    BOXES[n++] = "Parchment4";
    BOXES[n++] = "Parchment5";
    BOXES[n++] = "Parchment6";
    BOXES[n++] = "Parchment7";
    BOXES[n++] = "Parchment8";
    BOXES[n++] = "Parchment9";
    BOXES[n++] = "Test";
    BOXES[n++] = "Twinkle";
    BOXES[n++] = "Twisted";
    BOXES[n++] = "Unicode";
    BOXES[n++] = "Unicode_bold";
    BOXES[n++] = "Unicode_double";
    BOXES[n++] = "Unicode_inverted";
    BOXES[n++] = "Unicode_round";
    BOXES[n++] = "Unicode_shadow";
    BOXES[n++] = "Unicode_shadow2";
    BOXES[n++] = "Wavy";
    BOXES[n++] = "hash";
    BOXES[n++] = "star";

    if (box == "ADA") {
        Uh = split("-\n-", UL, "\n");
        split("-", UM, "\n");
        split("-\n-", UR, "\n");
        Mh = split("-\n-", ML, "\n");
        split("-\n-", MR, "\n");
        Lh = split("-\n-", LL, "\n");
        split("-", LM, "\n");
        split("-\n-", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "ADA2") {
        Uh = split("-\n-", UL, "\n");
        split("-", UM, "\n");
        split("", UR, "\n");
        Mh = split("-\n-", ML, "\n");
        split("", MR, "\n");
        Lh = split("-\n-", LL, "\n");
        split("-", LM, "\n");
        split("", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "ASCII") {
        Uh = split("+", UL, "\n");
        split("-", UM, "\n");
        split("+", UR, "\n");
        Mh = split("|", ML, "\n");
        split("|", MR, "\n");
        Lh = split("+", LL, "\n");
        split("-", LM, "\n");
        split("+", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Braid") {
        Uh = split("\\\\//\n // \n//\\\\", UL, "\n");
        split("\\\\  //\n \\\\// \n", UM, "\n");
        split("\\\\//\n // \n//\\\\", UR, "\n");
        Mh = split("\\\\//\n // \n//\\\\", ML, "\n");
        split("\\\\//\n // \n//\\\\", MR, "\n");
        Lh = split("\\\\//\n // \n//\\\\", LL, "\n");
        split("\n //\\\\ \n//  \\\\", LM, "\n");
        split("\\\\//\n // \n//\\\\", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 1;
        margin["B"] = 1;
        margin["L"] = 1;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "C") {
        Uh = split("/\n*", UL, "\n");
        split("*", UM, "\n");
        split("*\n/", UR, "\n");
        Mh = split("/\n*", ML, "\n");
        split("*\n/", MR, "\n");
        Lh = split("/\n*", LL, "\n");
        split("*", LM, "\n");
        split("*\n/", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "C2") {
        Uh = split("/\n*", UL, "\n");
        split(" ", UM, "\n");
        split("*\n/", UR, "\n");
        Mh = split("/\n*", ML, "\n");
        split("*\n/", MR, "\n");
        Lh = split("/\n*", LL, "\n");
        split(" ", LM, "\n");
        split("*\n/", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "C3") {
        Uh = split("/\n*", UL, "\n");
        split(" ", UM, "\n");
        split("*", UR, "\n");
        Mh = split(" \n*", ML, "\n");
        split("*", MR, "\n");
        Lh = split(" \n*", LL, "\n");
        split(" ", LM, "\n");
        split("*\n/", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "CAMl") {
        Uh = split("(\n*", UL, "\n");
        split("*", UM, "\n");
        split("*\n)", UR, "\n");
        Mh = split("(\n*", ML, "\n");
        split("*\n/", MR, "\n");
        Lh = split("(\n*", LL, "\n");
        split("*", LM, "\n");
        split("*\n/", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Diamond") {
        Uh = split("/ \\ \n\\ / ", UL, "\n");
        split("/ \\ \n\\ / ", UM, "\n");
        split("/ \\ \n\\ / ", UR, "\n");
        Mh = split("/ \\ \n\\ / ", ML, "\n");
        split("/ \\ \n\\ / ", MR, "\n");
        Lh = split("/ \\ \n\\ / ", LL, "\n");
        split("/ \\ \n\\ / ", LM, "\n");
        split("/ \\ \n\\ / ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 1;
        margin["B"] = 1;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 1;
    } else if (box == "DoubleDiamond") {
        Uh = split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", UL, "\n");
        split(" /\\ \n//\\\\\n\\\\//\n \\/ \n    \n    ", UM, "\n");
        split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", UR, "\n");
        Mh = split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", ML, "\n");
        split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", MR, "\n");
        Lh = split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", LL, "\n");
        split("    \n    \n /\\ \n//\\\\\n\\\\//\n \\/ ", LM, "\n");
        split(" /\\ \n//\\\\\n\\\\//\n//\\\\\n\\\\//\n \\/ ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 2;
        margin["B"] = 1;
        margin["L"] = 2;

        neg_margin["T"] = 2;
        neg_margin["R"] = 0;
        neg_margin["B"] = 2;
        neg_margin["L"] = 0;
    } else if (box == "HTML") {
        Uh = split("<\n!\n-\n-\n ", UL, "\n");
        split("-", UM, "\n");
        split(" \n-\n-\n>", UR, "\n");
        Mh = split("<\n!\n-\n-\n ", ML, "\n");
        split(" \n-\n-\n>", MR, "\n");
        Lh = split("<\n!\n-\n-\n ", LL, "\n");
        split("-", LM, "\n");
        split(" \n-\n-\n>", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "HTMl2") {
        Uh = split("<\n!\n-\n-\n ", UL, "\n");
        split(" ", UM, "\n");
        split(" \n-\n-\n>", UR, "\n");
        Mh = split("<\n!\n-\n-\n ", ML, "\n");
        split(" \n-\n-\n>", MR, "\n");
        Lh = split("<\n!\n-\n-\n ", LL, "\n");
        split(" ", LM, "\n");
        split(" \n-\n-\n>", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "Inverted") {
        Uh = split("  |\n--+", UL, "\n");
        split(" \n-", UM, "\n");
        split("|  \n+--", UR, "\n");
        Mh = split("  |", ML, "\n");
        split("|  ", MR, "\n");
        Lh = split("--+\n  |", LL, "\n");
        split("-\n ", LM, "\n");
        split("+--\n|  ", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Parchment1") {
        Uh = split("      _____\n    / \\    \n   |   |   \n    \\_ |   ", UL, "\n");
        split("_\n \n \n ", UM, "\n");
        split("_  \n \\.\n |.\n |.", UR, "\n");
        Mh = split("       |   ", ML, "\n");
        split(" |.", MR, "\n");
        Lh = split("       |   \n       |  /\n       \\_/_", LL, "\n");
        split("_\n \n_", LM, "\n");
        split("_|___ \n    /.\n___/. ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 3;
        neg_margin["R"] = 1;
        neg_margin["B"] = 0;
        neg_margin["L"] = 3;
    } else if (box == "Parchment2") {
        Uh = split("  ,---\n (_\\  ", UL, "\n");
        split("-\n ", UM, "\n");
        split("----.  \n     \\ ", UR, "\n");
        Mh = split("    | ", ML, "\n");
        split("      |", MR, "\n");
        Lh = split("   _| \n  (_/_\n      \n      \n      ", LL, "\n");
        split(" \n_\n \n \n ", LM, "\n");
        split("      |\n(*)___/\n \\\\    \n  ))   \n  ^    ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 0;
        margin["B"] = 1;
        margin["L"] = 1;

        neg_margin["T"] = 1;
        neg_margin["R"] = 5;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "Parchment3") {
        Uh = split("  ______\n /  __  \n|  /  \\ \n|\\ \\   |\n| \\___/|", UL, "\n");
        split("_\n \n \n \n ", UM, "\n");
        split("______ \n  __  \\ \n /  \\  |\n|   / /|\n|\\___/ |", UR, "\n");
        Mh = split("|      |", ML, "\n");
        split("|      |", MR, "\n");
        Lh = split(" \\     |\n  \\___/ ", LL, "\n");
        split("_\n ", LM, "\n");
        split("|     / \n \\___/  ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 2;
        margin["B"] = 1;
        margin["L"] = 2;

        neg_margin["T"] = 4;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Parchment4") {
        Uh = split("         \n         \n         \n         \n  .------\n /  .-.  \n|  /   \\ \n| |\\_.  |\n|\\|  | /|\n| `---' |", UL, "\n");
        split(" \n \n \n \n-\n \n \n \n \n ", UM, "\n");
        split("  .---.  \n /  .  \\ \n|\\_/|   |\n|   |  /|\n------' |\n        |\n        |\n        |\n        |\n        |", UR, "\n");
        Mh = split("|       |", ML, "\n");
        split("        |", MR, "\n");
        Lh = split("|       |\n|       |\n\\       |\n \\     / \n  `---'  ", LL, "\n");
        split(" \n-\n \n \n ", LM, "\n");
        split("       /\n------' \n        \n        \n        ", LR, "\n");
        margin["T"] = 2;
        margin["R"] = 4;
        margin["B"] = 2;
        margin["L"] = 3;

        neg_margin["T"] = 5;
        neg_margin["R"] = 7;
        neg_margin["B"] = 1;
        neg_margin["L"] = 0;
    } else if (box == "Parchment5") {
        Uh = split("  .------\n /  .-.  \n|  /   \\ \n| |\\_.  |\n|\\|  | /|\n| `---' |", UL, "\n");
        split("-\n \n \n \n \n ", UM, "\n");
        split("------.  \n  .-.  \\ \n /   \\  |\n|    /| |\n|\\  | |/|\n| `---' |", UR, "\n");
        Mh = split("|       |", ML, "\n");
        split("|       |", MR, "\n");
        Lh = split("|       |\n\\       |\n \\     / \n  `---'  ", LL, "\n");
        split("-\n \n \n ", LM, "\n");
        split("|       |\n|       /\n \\     / \n  `---'  ", LR, "\n");
        margin["T"] = 2;
        margin["R"] = 3;
        margin["B"] = 1;
        margin["L"] = 3;

        neg_margin["T"] = 5;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Parchment6") {
        Uh = split(" __^__ \n( ___ )\n |   | ", UL, "\n");
        split(" \n-\n ", UM, "\n");
        split(" __^__ \n( ___ )\n |   | ", UR, "\n");
        Mh = split(" | / | ", ML, "\n");
        split(" | \\ | ", MR, "\n");
        Lh = split(" |___| \n(_____)", LL, "\n");
        split(" \n-", LM, "\n");
        split(" |___| \n(_____)", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 2;
        margin["B"] = 0;
        margin["L"] = 2;

        neg_margin["T"] = 0;
        neg_margin["R"] = 1;
        neg_margin["B"] = 0;
        neg_margin["L"] = 1;
    } else if (box == "Parchment7") {
        Uh = split(" /\"\\/\\_..\n(     _||\n \\_/\\/ ||", UL, "\n");
        split("-\n \n ", UM, "\n");
        split("-._/\\/\"\\ \n||_     )\n|| \\/\\_/ ", UR, "\n");
        Mh = split("       ||", ML, "\n");
        split("||", MR, "\n");
        Lh = split(" /\"\\/\\_|-\n(     _| \n \\_/\\/ `-", LL, "\n");
        split("-\n \n-", LM, "\n");
        split("-|_/\\/\"\\ \n |_     )\n-' \\/\\_/ ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 3;
        margin["B"] = 1;
        margin["L"] = 3;

        neg_margin["T"] = 2;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Parchment8") {
        Uh = split("     __\n    /\\ \n(O)===)\n    \\/'\n    (  ", UL, "\n");
        split("__\n  \n><\n''\n  ", UM, "\n");
        split("_       \n \\      \n><)==(O)\n'/       \n(        ", UR, "\n");
        Mh = split("     ) \n    (  ", ML, "\n");
        split(" )    \n(     ", MR, "\n");
        Lh = split("    /\\'\n(O)===)\n    \\/_", LL, "\n");
        split("''\n><\n__", LM, "\n");
        split("'\\      \n><)==(O)\n_/      ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 2;
        margin["B"] = 1;
        margin["L"] = 2;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 1;
    } else if (box == "Parchment9") {
        Uh = split("     ___\n()==(   \n     '__", UL, "\n");
        split("_\n \n_", UM, "\n");
        split("_     \n(@==()\n_'|   ", UR, "\n");
        Mh = split("       |", ML, "\n");
        split("  |", MR, "\n");
        Lh = split("     __)\n()==(   \n     '--", LL, "\n");
        split("_\n \n-", LM, "\n");
        split("__|    \n (@==()\n-'     ", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 2;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Test") {
        Uh = split("+---->\n|     \nv     ", UL, "\n");
        split("<--->\n     \n     ", UM, "\n");
        split("<--+\n   |\n   v", UR, "\n");
        Mh = split("^     \n|     \n|     \n|     \nv     ", ML, "\n");
        split("   ^\n   |\n   |\n   |\n   v", MR, "\n");
        Lh = split("^     \n|     \n|     \n|     \n|     \n+---->", LL, "\n");
        split("     \n     \n     \n     \n     \n<--->", LM, "\n");
        split("   ^\n   |\n   |\n   |\n   |\n<--+", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 0;
        margin["B"] = 0;
        margin["L"] = 0;

        neg_margin["T"] = 2;
        neg_margin["R"] = 3;
        neg_margin["B"] = 5;
        neg_margin["L"] = 5;
    } else if (box == "Twinkle") {
        Uh = split("   \\  :  /    \n`. __/ \\__ .' \n_ _\\     /_ _ \n   /_   _\\    \n .'  \\ /  `.  \n   /  |  \\    \n      |       ", UL, "\n");
        split("   \\  :  /    \n`. __/ \\__ .' \n_ _\\     /_ _ \n   /_   _\\    \n .'  \\ /  `.  \n   /  :  \\    \n              ", UM, "\n");
        split("   \\  :  /   \n`. __/ \\__ .'\n_ _\\     /_ _\n   /_   _\\   \n .'  \\ /  `. \n   /  |  \\   \n      |      ", UR, "\n");
        Mh = split("   \\  |  /    \n`. __/ \\__ .' \n_ _\\     /_ _ \n   /_   _\\    \n .'  \\ /  `.  \n   /  |  \\    \n      |       ", ML, "\n");
        split("   \\  |  /   \n`. __/ \\__ .'\n_ _\\     /_ _\n   /_   _\\   \n .'  \\ /  `. \n   /  |  \\   \n      |      ", MR, "\n");
        Lh = split("   \\  |  /    \n`. __/ \\__ .' \n_ _\\     /_ _ \n   /_   _\\    \n .'  \\ /  `.  \n   /  :  \\    ", LL, "\n");
        split("   \\  :  /    \n`. __/ \\__ .' \n_ _\\     /_ _ \n   /_   _\\    \n .'  \\ /  `.  \n   /  :  \\    ", LM, "\n");
        split("   \\  |  /   \n`. __/ \\__ .'\n_ _\\     /_ _\n   /_   _\\   \n .'  \\ /  `. \n   /  :  \\   ", LR, "\n");
        margin["T"] = 2;
        margin["R"] = 4;
        margin["B"] = 2;
        margin["L"] = 4;

        neg_margin["T"] = 1;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 1;
    } else if (box == "Twisted") {
        Uh = split("._____. ._____. .__\n| ._. | | ._. | | .\n| !_| |_|_|_! | | !\n!___| |_______! !__\n.___|_|_| |________\n| ._____| |________\n| !_! | | |        \n!_____! | |        \n._____. | |        \n| ._. | | |        ", UL, "\n");
        split("_\n_\n_\n_\n_\n_\n \n \n \n ", UM, "\n");
        split("__. ._____. ._____.\n. | | ._. | | ._. |\n! | | !_| |_|_|_! |\n__! !___| |_______!\n________|_|_| |___.\n____________| |_. |\n        | | ! !_! |\n        | | !_____!\n        | | ._____.\n        | | | ._. |", UR, "\n");
        Mh = split("| | | | | |        ", ML, "\n");
        split("        | | | | | |", MR, "\n");
        Lh = split("| !_! | | |        \n!_____! | |        \n._____. | |        \n| ._. | | |        \n| !_| |_|_|________\n!___| |____________\n.___|_|_| |___. .__\n| ._____| |_. | | .\n| !_! | | !_! | | !\n!_____! !_____! !__", LL, "\n");
        split(" \n \n \n \n_\n_\n_\n_\n_\n_", LM, "\n");
        split("        | | ! !_! |\n        | | !_____!\n        | | ._____.\n        | | | ._. |\n________| |_|_|_! |\n________| |_______!\n__. .___|_|_| |___.\n. | | ._____| |_. |\n! | | !_! | | !_! |\n__! !_____! !_____!", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 2;
        margin["B"] = 1;
        margin["L"] = 2;

        neg_margin["T"] = 4;
        neg_margin["R"] = 8;
        neg_margin["B"] = 4;
        neg_margin["L"] = 8;
    } else if (box == "Unicode") {
        Uh = split("┌", UL, "\n");
        split("─", UM, "\n");
        split("┐", UR, "\n");
        Mh = split("│", ML, "\n");
        split("│", MR, "\n");
        Lh = split("└", LL, "\n");
        split("─", LM, "\n");
        split("┘", LR, "\n");
        margin["T"] = 1;
        margin["R"] = 1;
        margin["B"] = 1;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_bold") {
        Uh = split("┏", UL, "\n");
        split("━", UM, "\n");
        split("┓", UR, "\n");
        Mh = split("┃", ML, "\n");
        split("┃", MR, "\n");
        Lh = split("┗", LL, "\n");
        split("━", LM, "\n");
        split("┛", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_double") {
        Uh = split("╔", UL, "\n");
        split("═", UM, "\n");
        split("╗", UR, "\n");
        Mh = split("║", ML, "\n");
        split("║", MR, "\n");
        Lh = split("╚", LL, "\n");
        split("═", LM, "\n");
        split("╝", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_inverted") {
        Uh = split(" │\n─┼", UL, "\n");
        split(" \n─", UM, "\n");
        split("│ \n┼─", UR, "\n");
        Mh = split(" │", ML, "\n");
        split("│ ", MR, "\n");
        Lh = split("─┼\n │", LL, "\n");
        split("─\n ", LM, "\n");
        split("┼─\n│ ", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_round") {
        Uh = split("╭", UL, "\n");
        split("─", UM, "\n");
        split("╮", UR, "\n");
        Mh = split("│", ML, "\n");
        split("│", MR, "\n");
        Lh = split("╰", LL, "\n");
        split("─", LM, "\n");
        split("╯", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_shadow") {
        Uh = split("┌", UL, "\n");
        split("─", UM, "\n");
        split("┒", UR, "\n");
        Mh = split("│", ML, "\n");
        split("┃", MR, "\n");
        Lh = split("┕", LL, "\n");
        split("━", LM, "\n");
        split("┛", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Unicode_shadow2") {
        Uh = split("┌", UL, "\n");
        split("─", UM, "\n");
        split("╖", UR, "\n");
        Mh = split("│", ML, "\n");
        split("║", MR, "\n");
        Lh = split("╘", LL, "\n");
        split("═", LM, "\n");
        split("╝", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "Wavy") {
        Uh = split("   .-.   \n .'   `._\n(    .   \n `.   `._", UL, "\n");
        split("  .-.   \n.'   `._\n  .-.   \n.'   `._", UM, "\n");
        split("   .-.   \n_.'   `. \n   .    )\n_.'   .' ", UR, "\n");
        Mh = split("   )    )\n ,'   ,' \n(    (   \n `.   `. ", ML, "\n");
        split("(    (   \n `.   `. \n   )    )\n .'   .' ", MR, "\n");
        Lh = split("   )    )\n ,'   .' \n(    '  _\n `.   .' \n   `-'   ", LL, "\n");
        split("       _\n`.   .' \n  `-'  _\n`.   .' \n  `-'   ", LM, "\n");
        split("(    (   \n `.   `. \n_  `    )\n `.   .' \n   `-'   ", LR, "\n");
        margin["T"] = 2;
        margin["R"] = 2;
        margin["B"] = 1;
        margin["L"] = 2;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "hash") {
        Uh = split("#", UL, "\n");
        split("#", UM, "\n");
        split("#", UR, "\n");
        Mh = split("#", ML, "\n");
        split("#", MR, "\n");
        Lh = split("#", LL, "\n");
        split("#", LM, "\n");
        split("#", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    } else if (box == "star") {
        Uh = split("*", UL, "\n");
        split("*", UM, "\n");
        split("*", UR, "\n");
        Mh = split("*", ML, "\n");
        split("*", MR, "\n");
        Lh = split("*", LL, "\n");
        split("*", LM, "\n");
        split("*", LR, "\n");
        margin["T"] = 0;
        margin["R"] = 1;
        margin["B"] = 0;
        margin["L"] = 1;

        neg_margin["T"] = 0;
        neg_margin["R"] = 0;
        neg_margin["B"] = 0;
        neg_margin["L"] = 0;
    }
}
