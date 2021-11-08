#!/bin/bash

RELATIVE_PATH=.
NAME="LOG8415TP2"
RESSOURCE_GROUP="LOG8415TP2_group"
ID_MACHINE=$(az vm show -d -g $RESSOURCE_GROUP -n  $NAME  --query publicIps -o tsv)

RED='\033[0;31m'
NC='\033[0m'

function show(){
  echo -e "${RED} $1 ${NC}" ;
}

function send_config_files(){
   echo "$ID_MACHINE" > $RELATIVE_PATH/credentials/ip_address.txt
   show "SEND FILES TO VM";
   scp -i $RELATIVE_PATH/credentials/log_key.cer -r $RELATIVE_PATH/credentials $RELATIVE_PATH/Makefile $RELATIVE_PATH/codes $RELATIVE_PATH/configs $RELATIVE_PATH/files azureuser@$ID_MACHINE:/home/azureuser/
  show "END SEND FILES TO VM";
}

function connect_vm(){
  show "CONNECT TO VM";
  ssh -i $RELATIVE_PATH/credentials/log_key.cer azureuser@$ID_MACHINE
}

function send_and_connect(){
  send_config_files;
  connect_vm;
}

function start_vm(){
  show "START VM";
  az vm start --name $NAME --resource-group $RESSOURCE_GROUP
}

function stop_vm(){
  show "STOP VM";
  az vm deallocate --name $NAME --resource-group $RESSOURCE_GROUP
}


