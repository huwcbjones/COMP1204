#!/bin/bash

function reviewcount () {
	grep -c "<Author>" $1
}

function averageScore() {
	t=$1
	n=$2
	
	mean=$((t/n))
	dp=$(( 10 * (t % n) / n ))
	
	echo "$mean.$dp"
}


function getTotalScore() {
	Scores=$(grep "<Overall>" $1)
	TotalScore=0
	while read -r line; do
		TotalScore=$((TotalScore + ${line:(-1)}))
	done <<< "$Scores"
	echo $TotalScore
}

function getAverageScore() {
	HotelFile=$1
	
	ReviewCount=$(reviewcount $HotelFile)
	TotalScore=$(getTotalScore $HotelFile)
	echo $(averageScore $TotalScore $ReviewCount)
}

function getTrimmedHotelFile() {
	filePath=$1
	fileName=$2
	hotelName=${fileName#$filePath/}
	hotelName=${hotelName%.dat}
	echo $hotelName
}

if [ -d $1 ]
then
	for file in $1/*
	do
		echo $(getTrimmedHotelFile $1 $file) $(getAverageScore $file)
	done
else
	echo "$1 is not a valid directory."
fi
