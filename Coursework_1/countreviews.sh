#!/bin/bash

function reviewcount () {
	grep -c "<Author>" $1
}

# If provided argument is a directory
if [ -d $1 ]
then

	# Loop through files and do reviewcount
	for file in $1/*
	do
		reviewcount $file
	done;
	
else
	reviewcount $1
fi