#!/bin/bash

function getReviewCount () {
	grep -c "<Author>" $1
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	echo $1 | sed -e 's:^.*\/::' -e 's:.dat::'
}

# If provided argument is a directory
if [ -d $1 ]
then
	
	reviewCount=""

	# Loop through files and do reviewcount
	for file in $1/*
	do
		# Trim directory prefix and .dat suffix from hotelName to get hotel_xxxx
		hotelName=$(getTrimmedHotelFile $file)
		
		# Set current count to hotel_id count
		currentCount="$hotelName"$'\t'"$(getReviewCount $file)"

		# Append currentCount to reviewCount using a newline (\n)
		reviewCount="$reviewCount"$'\n'"$currentCount"
	done;
	
	# Pipe $reviewCount into a reverse number sort
	echo -e "$reviewCount" | sort -k2nr
else
	hotelName=$(getTrimmedHotelFile $1)
	echo $hotelName $(getReviewCount $1)
fi	
