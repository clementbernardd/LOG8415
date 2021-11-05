#!/bin/bash

RELATIVE_PATH=..
ID_MACHINE=52.190.7.196

function send_config_files(){
   scp -i $RELATIVE_PATH/credentials/log_key.cer -r $RELATIVE_PATH/codes $RELATIVE_PATH/configs $RELATIVE_PATH/files azureuser@$ID_MACHINE:/home/azureuser/
}

function connect_to_vm(){
  ssh -i $RELATIVE_PATH/credentials/log_key.cer azureuser@52.190.7.196
}

send_config_files;
connect_to_vm;
