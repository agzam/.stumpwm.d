#!/usr/bin/env bash
if ! pidof -x "redshift" >/dev/null; then
   redshift &
fi
