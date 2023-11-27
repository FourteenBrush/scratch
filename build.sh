#!/bin/bash

OUT_NAME=scratch
FLAGS="-strict-style -vet-unused"
COLLECTION_SOURCES=(
    "reader=dependencies/Classreader/src"
    "cli=dependencies/cli"
)
COLLECTIONS=$(printf -- "-collection:%s " "${COLLECTION_SOURCES[@]}")

case $1 in
    run)
        args="${@:1}"
        args[0] = $OUT_NAME
        odin run src $COLLECTIONS $FLAGS -- ${args[@]}
        ;;
    debug)
        EXTRA_FLAGS="-debug"
        ;&
    *)
        EXTRA_FLAGS=${EXTRA_FLAGS:="-o:speed"}
        odin build src -out:$OUT_NAME $COLLECTIONS $FLAGS $EXTRA_FLAGS
        ;;
esac
