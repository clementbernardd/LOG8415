#!/bin/bash

#MASTER_NAME="spark://LOG8415TP2.aydew02h1fhuzobtqa4mhe0img.bx.internal.cloudapp.net:7077"
#IP_MACHINE=$(cat ./credentials/ip_address.txt)

#spark-submit --master spark://$IP_MACHINE:7077 codes/python/wordcount.py --file $1 2>> /dev/null

python3 ./codes/python/wordcount.py --file=$1 --output=$2 &>> /dev/null