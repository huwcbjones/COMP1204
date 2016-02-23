#!/bin/bash

function getAverageScore() {
	Scores=$(grep "<Overall>" $1 | sed -e 's:<Overall>::')
	echo $(echo -e "$Scores" | awk '
	BEGIN {
		TotalScore=0;
		n=0;
	}

	{
		TotalScore += $0;
		n += 1;
	}

	END {
		printf ("%.1f\n", (TotalScore / n));
	}
	')
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	echo $1 | sed -e 's:^[/a-zA-Z_0-9\-]*\/::' -e 's:.dat::'
}


# Check 2 arguments were passed


hotel1=$1
hotel2=$2

# Convert hotel IDs to file-names/paths
hotel1_file=$(echo $hotel1.dat)
hotel2_file=$(echo $hotel2.dat)

echo hotel1_mean=$(getAverageScore $hotel1_file)

# Check the hotel files exist
if [ ! -f $hotel1_file ]
then
	echo "First hotel was not found."
	exit
fi
if [ ! -f $hotel2_file ]
then
	echo "Second hotel was not found."
	exit
fi

# Get hotel means
hotel1_mean=$(getAverageScore $hotel1_file)
hotel2_mean=$(getAverageScore $hotel2_file)

# Get t-statistic
hotel1_sd=""
hotel2_sd=""

echo "Mean $hotel1: $hotel_1_mean, SD: $hotel1_sd"
echo "Mean $hotel2: $hotel_2_mean, SD: $hotel2_sd"
