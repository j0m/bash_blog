#!/bin/bash
#$1: git working directroy
#$2: file
#$3: md work dir
#$4: bin dir

#create new list
$4/get_change_date.sh $1 $2 >> "$3/tmpFileList"
echo -n ";" >> "$3/tmpFileList"
echo -n $2 >> "$3/tmpFileList"
echo -n ";" >> "$3/tmpFileList"
$4/get_users.sh $1 $2 >> "$3/tmpFileList"
echo "" >> "$3/tmpFileList"
