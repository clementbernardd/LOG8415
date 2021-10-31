#!/bin/bash 

cat pg4300.txt | awk 'NR>1' RS=' ' | sort  | uniq -c
