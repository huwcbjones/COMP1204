#!/bin/bash
if [ $# -ne 1 ]
then
	echo "No argument passed to script.";
	exit 1;
fi

function getHotelID() {
	echo "$1" | sed -e 's:^.*\/::' -e 's:.dat::'
}
function createTable() {
	echo "DROP TABLE HotelReviews;"
	echo "CREATE TABLE HotelReviews ("
	echo "  reviewID INTEGER PRIMARY KEY,"
	echo "  author VARCHAR(256) NOT NULL,"
	echo "  reviewDate DATE NOT NULL,"
	echo "  hotelID INTEGER NOT NULL,"
	echo "  URL VARCHAR(256),"
	echo "  averagePrice INTEGER NOT NULL,"
	echo "  overall INTEGER NOT NULL,"
	echo "  overallRating INTEGER NOT NULL,"
	echo "  businessService INTEGER,"
	echo "  checkIn INTEGER,"
	echo "  cleanliness INTEGER,"
	echo "  rooms INTEGER,"
	echo "  service INTEGER,"
	echo "  value INTEGER,"
	echo "  noReaders INTEGER NOT NULL DEFAULT 0,"
	echo "  noHelpful INTEGER NOT NULL DEFAULT 0"
	echo ");"
}

# Processes an individual hotel file
function processHotel() {
	echo "$1"
	hotelID=$(getHotelID $1)
	overallRating=$(getField $1 "<Overall Rating>")
	URL=$(getField $1 "<URL>")
	echo "$hotelID"
#	awk '
#	BEGIN {
#		HotelID='$hotelID';
#		OverallRating='$overallRating';
#		URL="'$URL'";
#	}
#	END {
#		print $hotelID, $OverallRating, $URL;
#	}
#	'
}

function getField() {
	echo "$2"
	#grep " " "$2" | sed -e "s:$2::"
}

echo "$(createTable)" > hotelreviews.sql
if [ -d $1 ]
then
	for f in $1/*
	do
		echo "$(processHotel $f)" >> hotelreviews.sql
	done
else
	echo "$(processHotel $f)" 
fi
