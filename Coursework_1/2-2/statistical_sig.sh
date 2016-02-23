#!/bin/bash
function getScores() {
	grep "<Overall>" $1 | sed -e 's:<Overall>::'
}

function getAverageScore() {
	echo $(getScores $1 | awk '
	BEGIN {
		TotalScore=0;
		n=0;
	}

	{
		TotalScore += $0;
		n += 1;
	}

	END {
		printf ("%.2f\n", (TotalScore / n));
	}
	')
}
function getSD() {
	file=$1
	mean=$2
	echo -e "$(getScores $1)" | awk '
		BEGIN {
			Total=0;
			n=0;
		}

		{
			Total += (($0 - $'$mean')^2);
			n++;
		}

		END {
			var = Total/(n-1);
			printf ("%.2f\t%.2f\t%.2f\n", Total, var, sqrt(var));
		}
	'
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
hotel1_mean=$(getAverageScore $hotel1_file)
echo "hotel1_mean=$hotel1_mean"
echo hotel1_sd=$(getSD $hotel1_file $hotel1_mean)

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
hotel1_sd=$(getSD $hotel1_file $hotel1_mean)
hotel2_sd=""

echo "Mean $hotel1: $hotel_1_mean, SD: $hotel1_sd"
echo "Mean $hotel2: $hotel_2_mean, SD: $hotel2_sd"
