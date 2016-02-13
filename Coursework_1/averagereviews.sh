#!/bin/bash

# Gets number of reviews
function getReviewCount () {
	grep -c "<Author>" $1
}

# Gets average score to 1dp
#function averageScore() {
#	t=$1
#	n=$2
#	
#	mean=$((t/n))
#	dp=$(( 10 * (t % n) / n ))
#	
#	echo "$mean.$dp"
#}

# Gets the sum of all review scores
function getTotalScore() {
	Scores=$(grep "<Overall>" $1 | sed -e 's:<Overall>::')
	echo $Scores
#	TotalScore=0
#	while read -r line; do
#		TotalScore=$((TotalScore + line))
#	done < "$Scores"
#	echo $TotalScore
}

# Gets the average review of the hotel
function getAverageScore() {
	HotelFile=$1

	ReviewCount=$(getReviewCount $1)
#	echo "ReviewCount: $ReviewCount"
#	TotalScore=$(getTotalScore $HotelFile)
#	echo "TotalScore: $TotalScore"
#	echo $(averageScore $TotalScore $ReviewCount)
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	echo $1 | sed -e 's:^[a-zA-Z_0-9\-]*\/::' -e 's:.dat::'
}

# Checks argument passed was a directory
if [ -d $1 ]
then
	# Loops through all files and prints HOTEL_ID AVERAGE_REVIEW
	for file in $1/*
	do
#		echo $(getTrimmedHotelFile $1 $file) $(getTotalScore $file)
		echo $(getTrimmedHotelFile $1 $file) $(getAverageScore $file)
	done
else
	echo $(getTrimmedHotelFile $1) $(getAverageScore $file)
#	echo "$1 is not a valid directory."
fi
