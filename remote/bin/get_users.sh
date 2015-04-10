#!/bin/bash
#$1: git working directroy
#$2: file
git --git-dir=$1/.git log --format='%aN' $2 | sort -u | awk '{print $1 " " $2 ", "}' | tr -d "\n" | tr -d ","
