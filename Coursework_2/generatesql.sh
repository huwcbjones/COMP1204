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
	echo $1 | sed -e 's:^.*\/hotel_::' -e 's:.dat::'
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
	overallRating=$(getField $1 '<Overall Rating>')
	averagePrice=$(getField $1 '<Avg. Price>\$')
	URL=$(getField $1 '<URL>')
	file=$(sed -e "s:\r\n:\n:" -e "s:\r:\n:" $1)
	echo -e "$file"	| awk \
		-v hotelID="$hotelID" \
	'BEGIN {
		# Set record separator to ""
		RS = "";
		# Set field separator to "\n"
		FS = "\n";
		# Set record counter to 0
		recordNum = 0;
	}
	{
		# Loop through all fields in record.
		# NF is number of fields
		for (i = 0; i < NF; i++){
			# Get hotel properties
			if(match($i, "<Overall Rating>")){
				sub(/<Overall Rating>/, "", $i);
				overall = $i;
			} else if(match($i, "<Avg. Price>")){
				sub(/<Avg. Price>\$/, "", $i);
				avgPrice = $i;
			} else if(match($i, "<URL>")){
				sub(/<URL>/, "", $i);
				URL = $i;
			} else if(match($i, "<Avg. Price>")){
				sub(/<Avg. Price>/, "", $i);
				avgPrice = $i;
			} else if(match($i, "<Author>")){
				sub(/<Author>/, "", $i);
				data[recordNum]["author"] = $i;
			}
		}
		recordNum++;
	}
	END {
		print "Hotel ID: " hotelID;
		print "URL     : " URL;
		print "OverallS: " overall;
		print "AvgPrice: " avgPrice;
		for(record in data) {
			for (field in data[record]){
				print data[record][field];
			}
		}
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
