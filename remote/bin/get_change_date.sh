#!/bin/bash
#$1: git working directroy
#$2: file
git --git-dir=$1/.git log $2 | head -n 3 | tail -n 1 | sed -e 's/Date:[[:space:]][[:space:]][[:space:]]//g' | awk -F " " '{split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec",month); for (i in month) { month_nums[month[i]]=i}; printf $5 "-" month_nums[$2] "-" $3 " " $4}'
