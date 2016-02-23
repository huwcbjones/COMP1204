#!/bin/bash
function getScores() {
	grep "<Overall>" $1 | sed -e 's:<Overall>::'
}

function getN() {
	echo -e "$(getScores $1)" | wc -l
}

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
		print (TotalScore / n);
	}
	'
}

function getSD() {
	file="$1"
	mean="$2"
	echo -e "$(getScores $1)" | awk '
		BEGIN {
			Total=0;
			n=0;
		}

		{
			Total += (($0 - '$mean')^2);
			n++;
		}

		END {
			var = Total/(n-1);
			print sqrt(var);
		}
	'
}

# Gets the hotel ID from hotel file
function getTrimmedHotelFile() {
	echo $1 | sed -e 's:^[/a-zA-Z_0-9\-]*\/::' -e 's:.dat::'
}

# Calculates the common standard deviation
function getSx1x2() {
	S2X1=$1
	nX1=$2
	S2X2=$3
	nX2=$4
	
	awk '
	BEGIN {
		numer=( ('$nX1' - 1) * '$S2X1') + ( ('$nX2' - 1) * '$S2X2');
		denom=( '$nX1' + '$nX2' - 2 );
		frac = numer / denom;
		print sqrt(frac);
	}
	'
}

# Calculates the t-statistic
function getT_Statistic() {
	M1=$1
	n1=$2
	M2=$3
	n2=$4
	Sx1x2=$5
	awk '
	BEGIN {
		numer=( '$M1' - '$M2' );
		denom=( '$Sx1x2' * sqrt( 1/'$n1' + 1/'$n2'));
		print (numer/denom);
	}
	'
}

function round(){
	awk 'BEGIN { printf ("%.'$2'f\n", '$1') }'
}


# Trim hotel files down to the name
hotel1=$(getTrimmedHotelFile $1)
hotel2=$(getTrimmedHotelFile $2)

# Convert hotel IDs to file-names/paths
hotel1_file=$(echo $1.dat)
hotel2_file=$(echo $2.dat)

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

# Get number of reviews
hotel1_n=$(getN $hotel1_file)
hotel2_n=$(getN $hotel2_file)

# Get hotel means
hotel1_mean=$(getAverageScore $hotel1_file)
hotel2_mean=$(getAverageScore $hotel2_file)

# Get t-statistic
hotel1_sd=$(getSD $hotel1_file $hotel1_mean)
hotel2_sd=$(getSD $hotel2_file $hotel2_mean)

Sx1x2=$(getSx1x2 $hotel1_sd $hotel1_n $hotel2_sd $hotel2_n)
t_stat=$(getT_Statistic $hotel1_mean $hotel1_n $hotel2_mean $hotel2_n $Sx1x2)

echo "t: $(round $t_stat 2)"
echo "Mean $hotel1:"$'\t'"$(round $hotel1_mean 2),"$'\t'"SD: $(round $hotel1_sd 2)"
echo "Mean $hotel2:"$'\t'"$(round $hotel2_mean 2),"$'\t'"SD: $(round $hotel2_sd 2)"
