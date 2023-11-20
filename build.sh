#!/bin/bash

if [[ $1 == "debug" ]]; then
    EXTRA_FLAGS="-debug"
else
    EXTRA_FLAGS="-o:speed"
fi

COLLECTIONS=shared=dependencies/Classreader/src

odin build src -collection:$COLLECTIONS $EXTRA_FLAGS

