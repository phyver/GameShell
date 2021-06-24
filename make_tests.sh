#!/bin/sh

cd "$(dirname "$0")"

NAME="tmp tests game shell (1)¡"

clean() {
  echo "CLEANING"
  chmod -R +xrw "$NAME"*
  rm -rf "$NAME"*
}

trap 'clean' TERM INT HUP

./utils/archive.sh -at -N "$NAME"
NB_MISSIONS=42

NB_TESTS=7
gsh_test() {
  case $1 in

    simple_check-en | 1)
      ./"$NAME.sh" -q -L en -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh auto --abort < <(echo gsh); done; gsh stat; gsh exit --force"
      ;;

    simple_check-fr | 2)
      ./"$NAME.sh" -q -L fr -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh auto --abort < <(echo gsh); done; gsh stat; gsh exit --force"
      ;;

    tests-en | 3)
      ./"$NAME.sh" -q -L en -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh test --abort < <(echo gsh); gsh auto --abort < <(echo gsh); done; gsh stat; gsh exit --force"
      ;;

    tests-fr | 4)
      ./"$NAME.sh" -q -L fr -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh test --abort < <(echo gsh); gsh auto --abort < <(echo gsh); done; gsh stat; gsh exit --force"
      ;;

    tests-verbose-en | 5)
      ./"$NAME.sh" -qD -L en -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh test --abort; gsh auto --abort; done; gsh stat; gsh exit --force"
      ;;

    tests-verbose-fr | 6)
      ./"$NAME.sh" -qD -L fr -c "gsh systemconfig; for _ in \$(seq $NB_MISSIONS); do gsh test --abort; gsh auto --abort; done; gsh stat; gsh exit --force"
      ;;

    exits | 7)
      ./"$NAME.sh" -q -c "gsh exit"
      for i in $(seq $NB_MISSIONS)
      do
        echo MISSION $i
        echo ./"$NAME-save.sh" -q -c "gsh auto --abort < <(echo gsh); gsh exit --force"
        ./"$NAME-save.sh" -q -c "gsh auto --abort < <(echo gsh); gsh exit --force" || exit 1
      done
      ;;

    *)
      echo "unkwnown test: '$1'" >&2
      exit 1
      ;;
  esac
}


main() {
  case $1 in
    "")
      gsh_test 1
      ;;

    all)
      for i in $(seq $NB_TESTS)
      do
        echo
        echo "================================================="
        echo "TEST $i ($(basename $SHELL))"
        gsh_test $i || exit 1
      done
      ;;

    all-bash)
      SHELL=bash main all
      ;;

    all-zsh)
      SHELL=zsh main all
      ;;

    all-all)
      SHELL=bash main all
      SHELL=zsh main all
      ;;

    *)
      gsh_test "$1"
      ;;
  esac
}

main "$@"
ret_val=$?
clean
exit $ret_val
