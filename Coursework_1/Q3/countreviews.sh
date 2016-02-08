#!/bin/bash

function reviewcount () {
	grep -c "<Author>" $1
}

# If provided argument is a directory
if [ -d $1 ]
then
	
	reviewCount=""

	# Loop through files and do reviewcount
	for file in $1/*
	do
		# Trim directory prefix and .dat suffix from hotelName to get hotel_xxxx
		hotelName=${file#$1/}
		hotelName=${hotelName%.dat}
		
		# Set current count to reviewCount:file
		currentCount="$(reviewcount $file) $hotelName"

		# Append currentCount to reviewCount using a newlinw (\n)
		reviewCount="$reviewCount"$'\n'"$currentCount"
	done;
	
	# Pipe $reviewCount into a reverse number sort, then format the result using awk
	echo -e "$reviewCount" | sort -nr | awk '{print $2 " " $1}'
else
	reviewcount $1
fi