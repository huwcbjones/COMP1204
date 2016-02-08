#!/bin/bash

# Gets number of reviews
function reviewcount () {
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
	Scores=$(grep "<Overall>" $1)
	TotalScore=0
	while read -r line; do
		TotalScore=$((TotalScore + ${line:(-1)}))
	done <<< "$Scores"
	echo $TotalScore
}

# Gets the average review of the hotel
function getAverageScore() {
	HotelFile=$1
	
	ReviewCount=$(reviewcount $HotelFile)
	TotalScore=$(getTotalScore $HotelFile)
	echo $(averageScore $TotalScore $ReviewCount)
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	filePath=$1
	fileName=$2
	hotelName=${fileName#$filePath/}
	hotelName=${hotelName%.dat}
	echo $hotelName
}

# Checks argument passed was a directory
if [ -d $1 ]
then
	# Loops through all files and prints HOTEL_ID AVERAGE_REVIEW
	for file in $1/*
	do
		echo $(getTrimmedHotelFile $1 $file) $(getAverageScore $file)
	done
else
	echo "$1 is not a valid directory."
fi
