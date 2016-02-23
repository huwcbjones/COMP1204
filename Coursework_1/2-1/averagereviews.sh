#!/bin/bash

# Gets number of reviews
function getScores () {
	grep "<Overall>" $1 | sed -e 's:<Overall>::' -e 's:\r::'
}

# Gets the average review of the hotel
function getAverageScore() {
	echo -e "$(getScores $1)" | awk '
	BEGIN {
		TotalScore=0;
		n=0;
	}

	{
		TotalScore += $0;
		n++;
	}

	END {
		printf ("%.2f\n", (TotalScore / n));
	}
	'
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
