#!/bin/bash

# Boucle sur les files 
spark-submit --master=spark://tp2-machine.scnccywyne1uzjmfrttffkebha.bx.internal.cloudapp.net:7077 ../python/wordcount.py --file $1 2>> /dev/null
