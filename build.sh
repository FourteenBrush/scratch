#!/bin/bash

OUT_NAME=scratch
# TODO: add this back
FLAGS="-strict-style " # -vet-unused "

COLLECTION_SOURCES=(
    "classreader=dependencies/Classreader/src"
    "cli=dependencies/cli"
)

# unfortunately we can't add all collections to one -collection flag
COLLECTIONS=$(printf -- "-collection:%s " ${COLLECTION_SOURCES[@]})
DEBUG_FLAGS="-debug -use-separate-modules"

build () {
    odin build src -out:$OUT_NAME $COLLECTIONS $FLAGS $EXTRA_ARGS ${@:1}
}

case $1 in
    run)
        # interpret everything after 'run' as program args
        odin run src -out:$OUT_NAME $COLLECTIONS $FLAGS $DEBUG_FLAGS -- ${@:2}
        ;;
    check)
        odin check src $COLLECTIONS $FLAGS
        ;;
    debug)
        build $DEBUG_FLAGS ${@:2}
        ;;
    *)
        build -o:speed ${@:1}
        ;;
esac

