#!/bin/bash 

cat $1 | awk 'NR>1' RS=' ' | sort  | uniq -c | tail -n 10 >> $2;
