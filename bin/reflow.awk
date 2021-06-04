#!/usr/bin/awk -f

func greedy_format() {
    indent_width = length(par_indent);
    if (nb_words) {
        current_width = indent_width;
        printf("%s", par_indent);
        for (i=1; i<=nb_words; i++) {
            w = length(PAR[i]);
            if (current_width + w <= width) {
                printf("%s", PAR[i]);
                current_width += w;
            } else {
                printf("\n%s%s", par_indent, PAR[i]);
                current_width = indent_width + w;
            }
            if (i<nb_words) {
                printf(" ");
                current_width++;
            }
        }
        printf("\n");
        nb_words = 0;
        par_indent = "";
    }
}

func dynamic_format() {
    INF = nb_words * width * width;

    indent_width = length(par_indent);
    second_par_indent = par_indent;
    gsub(/./, " ", second_par_indent);


    if (nb_words == 0) {return;}

    # initialize padding
    for (i=1; i<=nb_words; i++) {
        padding[i,i] = width-length(PAR[i])-indent_width;
        # if (padding[i,i]<0) padding[i,i] *= -INF;
        for (j=i+1; j<=nb_words; j++) {
            padding[i,j] = padding[i,j-1] - length(PAR[j]) - 1;
        }
    }

    # last line has no cost
    for (i=1; i<=nb_words; i++) {
        if (padding[i,nb_words] > 0) {
            padding[i,nb_words] = 0;
        }
    }

    # initialize total cost array
    cost_before[1] = 0;
    for (i=2; i<=nb_words+1; i++) {
        cost_before[i] = INF;
    }

    # initialize break positions
    for (i=1; i<=nb_words; i++) {
        break_before[i] = 1;
    }

    # compute best cost, and corresponding breaking point, starting from the end
    for (j=1; j<=nb_words; j++) {
        i = j;
        while (i >= 1) {
            if (padding[i,j] < 0) {
                cost = cost_before[i] + penalty*penalty*padding[i,j]*padding[i,j];
            } else {
                cost = cost_before[i] + padding[i,j]*padding[i,j];
            }
            if (cost_before[j+1] > cost) {
                cost_before[j+1] = cost;
                break_before[j] = i;
            }
            i--;
        }
    }

    # get line breaks
    j = nb_words+1;
    B[b=0]= j;
    while (j > 1) {
        i = break_before[j-1];
        B[++b] = i;
        j = i;
    }

    # print lines
    for (i=b; i>0; i--) {
        printf("%s", par_indent);
        par_indent = second_par_indent;
        for (k=B[i]; k<B[i-1]; k++) {
            printf("%s", PAR[k]);
            if (i != 1 || k<B[i-1]-1) {
                printf(" ");
            }
        }
        printf("\n");
    }

    # reset global structure
    nb_words = 0;
    par_indent = "";

}

func format() {
    # greedy_format();
    dynamic_format();
}

# push the word into the current paragraph
func push(w) {
    PAR[++nb_words] = w;
}

BEGIN {
    if (!width) width = ENVIRON["COLUMNS"];
    if (!width) width = 78;
    if (!penalty) penalty = 10;
}

# on first line of new paragraph, count leading spaces to get indentation
!nb_words {
    # if a paragraph starts with a list marker
    # don't forget to remove the list marker!
    if (match($0, /^ *[-+]  */)) {
        par_indent = substr($0, 1, RLENGTH);
        $0 = substr($0, RLENGTH+1);
    } else if (match($0, /^ *[0-9][0-9]*[./]  */)) {
        par_indent = substr($0, 1, RLENGTH);
        $0 = substr($0, RLENGTH+1);
    } else {
        match($0, /^ */);
        par_indent = substr($0, 1, RLENGTH);
    }
}

# on empty lines, format current paragraph (if it exits) and print a newline
/^$/ {
    format();
    print;
    next;
}

# if line ends with a space, append all words to the current paragraph
/ $/ {
    for (i=1; i<=NF; i++) push($i);
}

# if line doesn't end with a space, it finishes the current paragraph
/[^ ]$/ {
    for (i=1; i<=NF; i++) push($i);
    format();
}

END {
    format();
}
