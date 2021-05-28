# function to update the global state for each line (either top or bottom
# margin, or text
function update() {
    # update global variable: line number, **including the margins**
    line_number++;
    # update global variable: "local" index inside current block
    block_index++;

    # update global variable: current block: "T", "M", "B" for Top, Middle or Bottom
    if (current_block == "T" && block_index > Th) {
        current_block = "M";
        block_index = 1;
    }
    if (current_block == "M" && block_index > Mh) {
        block_index = 1;
    }
    if (current_block == "M" &&line_number + neg_margin["B"] > height + margin["T"] + margin["B"]) { # ???

        current_block = "B";
        block_index = 1;
    }
    if (current_block == "B" && block_index > Bh) {
        printf("PROBLEM, end of bottom block has been reached!\n");
        exit(1);
    }

    # update global variables for the left and right part of the string to be
    # printed
    if (current_block == "T") {
        left_string = TL[block_index];
        right_string = TR[block_index];
    } else if (current_block == "M") {
        left_string = ML[block_index];
        right_string = MR[block_index];
    } else {
        left_string = BL[block_index];
        right_string = BR[block_index];
    }
}

BEGIN {
    DEBUG = 0;

    # adjust width / height to make sure lines will fill the negative margins
    if (height+margin["T"]+margin["B"] < neg_margin["T"]+neg_margin["B"]) {
        height = neg_margin["T"]+neg_margin["B"]-margin["T"]-margin["B"];
    }
    if (width + margin["L"]+margin["R"] < neg_margin["L"]+neg_margin["R"]) {
        width = neg_margin["L"]+neg_margin["R"]-margin["L"]-margin["R"];
    }

    # computing additional padding to make sure we need an integral number of
    # middle patterns (horizontaly and verticaly)
    padding = length(TC[1]) - (width + margin["L"] + margin["R"] - neg_margin["L"] - neg_margin["R"]) % length(TC[1]);
    if (padding != length(TC[1])) {
        margin["L"] += int(padding/2);
        margin["R"] += padding - int(padding/2);
    }

    padding = Mh - (height + margin["T"] + margin["B"] - neg_margin["T"] - neg_margin["B"]) % Mh;
    if (padding != Mh) {
        margin["T"] += int(padding/2);
        margin["B"] += padding - int(padding/2);
    }

    for (i=0; i<width+margin["L"]+margin["R"]; i++) blanks = blanks " ";

    if (DEBUG) printf("width=%d, height=%d, margin[T]=%d, margin[B]=%d\n", width, height, margin["T"], margin["B"]);
    if (DEBUG) printf("margin[L]=%d, margin[R]=%d\n", margin["L"], margin["R"]);
    if (DEBUG) printf("Th=%d, Mh=%d, Bh=%d\n", Th, Mh, Bh);
    if (DEBUG) printf("neg_margin[T]=%d, neg_margin[B]=%d\n", neg_margin["T"], neg_margin["B"]);
    if (DEBUG) printf("neg_margin[L]=%d, neg_margin[R]=%d\n", neg_margin["L"], neg_margin["R"]);

    # global variable: line number, **including the margins**
    line_number = 0;
    # global variable: "local" index inside current block
    block_index = 0;
    # global variable: current block: "T", "M", "B" for Top, Middle or Bottom
    current_block = "T";

    # static part of the upper block
    for (i=0; i<Th-neg_margin["T"]; i++) {
        block_index++;
        printf("%s", TL[block_index]);
        for (j=0; j<width+margin["L"]+margin["R"]-neg_margin["L"]-neg_margin["R"]; j+=length(TC[block_index])) {
            printf("%s", TC[block_index]);
        }
        printf("%s", TR[block_index]);
        if (DEBUG)
            printf(" <-- UPPER BLOCK: %s[%d]",
                   current_block, block_index);
        printf("\n");
    }

    # upper margin
    for (i=0; i<margin["T"]; i++) {
        update();

        printf("%s", substr(left_string, 1, length(left_string)-neg_margin["L"]));
        printf(blanks);
        printf("%s", substr(right_string, neg_margin["R"]+1));
        if (DEBUG)
            printf(" <-- UPPER MARGIN: %s[%d], n=%d",
                   current_block, block_index, line_number);
        printf("\n");
    }
}

{
    update();

    printf("%s", substr(left_string, 1, length(left_string)-neg_margin["L"]));
    printf(substr(blanks, 1, margin["L"]));
    printf("%s", $0);
    printf(substr(blanks, 1+length($0)+margin["L"]));
    printf("%s", substr(right_string, neg_margin["R"]+1));
    if (DEBUG)
            printf(" <-- TEXT: %s[%d], n=%d",
                   current_block, block_index, line_number);
    printf("\n");
}



END {
    # lower margin
    for (i=0; i<margin["B"]; i++) {
        update();

        printf("%s", substr(left_string, 1, length(left_string)-neg_margin["L"]));
        printf(blanks);
        printf("%s", substr(right_string, neg_margin["R"]+1));
        if (DEBUG)
            printf(" <-- LOWER MARGIN: %s[%d], n=%d",
                   current_block, block_index, line_number);
        printf("\n");
    }

    # static part of the lower block
    current_block = "B";
    block_index = neg_margin["B"]
    for (i=neg_margin["B"]; i<Bh; i++) {
        block_index++;
        printf("%s", BL[block_index]);
        for (j=0; j<margin["L"]-neg_margin["L"]+width+margin["R"]-neg_margin["R"]; j+=length(BC[block_index])) {
            printf("%s", BC[block_index]);
        }
        printf("%s", BR[block_index]);
        if (DEBUG)
            printf(" <-- LOWER BLOCK: %s[%d]",
                   current_block, block_index);
        printf("\n");
    }
}
