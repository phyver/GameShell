#!/bin/sh

_PID=$!
animate "$_PID" "$@"
wait $_PID
