#!/bin/bash

# Gets number of reviews
function getReviewCount () {
	grep -c "<Author>" $1
}

# Gets average score to 1dp
function averageScore() {
	t=$1
	n=$2
	
	mean=$((t/n))
	dp=$(( 10 * (t % n) / n ))
	
	echo "$mean.$dp"
}

# Gets the sum of all review scores
function getTotalScore() {
	Scores=$(grep "<Overall>" $1 | sed -e 's:<Overall>::' -e 's:\r::')
	TotalScore=0
	while read -r line; do
		TotalScore=$((TotalScore + line))
	done <<< "$Scores"
	echo $TotalScore
}

# Gets the average review of the hotel
function getAverageScore() {
	HotelFile=$1

	ReviewCount=$(getReviewCount $1)
	TotalScore=$(getTotalScore $HotelFile)
	echo $(averageScore $TotalScore $ReviewCount)
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	echo $1 | sed -e 's:^[/a-zA-Z_0-9\-]*\/::' -e 's:.dat::'
}

# Checks argument passed was a directory
if [ -d $1 ]
then
	hotels=""
	# Loops through all files and prints HOTEL_ID AVERAGE_REVIEW
	for file in $1/*
	do
		currentHotel="$(getTrimmedHotelFile $file)"$'\t'"$(getAverageScore $file)"
		hotels="$hotels"$'\n'"$currentHotel"
	done

	# Sort hotels by second column (rating)
	echo -e "$hotels" | sort -k2nr
else
	echo "$(getTrimmedHotelFile $1) $(getAverageScore $1)"
fi
