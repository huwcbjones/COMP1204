#!/bin/bash
if [ $# -ne 1 ]
then
	echo "No argument passed to script.";
	exit 1;
fi

# **
# * Extracts the HotelID from a hotel file name
#
# * @param $1 Hotel File name
# **
function getHotelID() {
	echo $1 | sed -e 's:^.*\/::' -e 's:.dat::'
}

# **
# * Returns the table schema
# **
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

# **
# * Processes an individual hotel file
# *
# * @param $1 Filename of hotel file
# **
function processHotel() {
	hotelID=$(getHotelID $1)
	overallRating=$(getField $1 "<Overall Rating>")
	URL=$(getField $1 "<URL>")
	awk '
	BEGIN {
		HotelID='$hotelID';
		OverallRating='$overallRating';
		URL="'$URL'";
	}
	END {
		print $hotelID, $OverallRating, $URL;
	}
	'
}

# **
# * Returns a field from a string
# *
# * @param $1 String
# * @param $2 Field Name to filter
# **
function getField() {
	grep "$2" $1 | sed -e "s:$2::"
}

echo "$(createTable)" > hotelreviews.sql
if [ -d $1 ]
then
	for f in $1/*
	do
		echo "$(processHotel $f)" >> hotelreviews.sql
	done
else
	echo -e "$(processHotel $1)" 
fi
