#!/bin/bash

SU_CMD=sudo
BUILD_DST="build"
USE_NINJA=

if [[ "$*" == *"--ninja"* ]]
then
    if [[ -z "$(command -v ninja)" ]]; then
        echo "Attempted to build using Ninja, but Ninja was not found on the system. Falling back to GNU Make."
    else
        echo "Compiling using Ninja"
        USE_NINJA="-G Ninja"
    fi
fi

if [[ -z "$(command -v $SU_CMD)" ]]; then
    SU_CMD=doas
    if [[ -z "$(command -v $SU_CMD)" ]]; then
        echo "Neither sudo or doas were detected on the system."
        exit
    fi
fi

cmake $USE_NINJA -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
