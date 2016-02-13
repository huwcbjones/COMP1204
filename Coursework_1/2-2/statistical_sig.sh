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


# Check 2 arguments were passed


hotel1=$1
hotel2=$2

# Convert hotel IDs to file-names/paths


# Check the hotel files exist

# Get hotel means
hotel1_mean=$(getAverageScore $hotel1)
hotel2_mean=$(getAverageScore $hotel2)

# Get t-statistic
hotel1_sd=""
hotel2_sd=""

echo "Mean $hotel_1: $hotel_1_mean, SD: $hotel1_sd"
echo "Mean $hotel_2: $hotel_2_mean, SD: $hotel2_sd"
