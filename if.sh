#!/bin/sh

addr="$1"

if [[ "$addr" != "" ]]
then
    echo n
else
    echo y
fi