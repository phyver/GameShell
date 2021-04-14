_local_check() {
    local cellar
    cellar="$(eval_gettext "\$GASH_HOME/Castle/Cellar")"

    # Check that there are no more rats.
    local rats
    rats=$(find "$cellar" -name "$(gettext "rat")*")
    if [ -n "$rats" ]
    then
        echo "$(gettext "There are still rats in the cellar!")"
        return 1
    fi

    # Check that the cat is still there.
    local cat
    cat=$(find "$cellar" -name "$(gettext "cat")*")
    if [ -z "$cat" ]
    then
        echo "$(gettext "The cat has disappeared!!!")"
        return 1
    fi

    return 0
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
