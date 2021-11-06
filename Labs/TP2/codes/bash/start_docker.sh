#!/bin/bash 

function build_docker(){
	docker build -t log8415_tp2 . ;
	docker run -it -p 50070:50070 log8415_tp2;
}

build_docker ; 
