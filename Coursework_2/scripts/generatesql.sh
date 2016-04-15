#!/bin/bash
if [ $# -ne 1 ]
then
	echo "No argument passed to script.";
	exit 1;
fi

# Extracts the HotelID from a hotel file name
# @param $1 Hotel File name
function getHotelID() {
	echo "$1" | sed -e 's:^.*\/::' -e 's:.dat::' -e 's:hotel_::'
}

# Returns the table schema
function createTable() {
	echo "PRAGMA encoding = \"UTF-8\";"
	echo "DROP TABLE IF EXISTS HotelReviews;"
	echo "CREATE TABLE HotelReviews ("
	echo "  reviewID INTEGER PRIMARY KEY,"
	echo "  author VARCHAR(256) NOT NULL,"
	echo "  reviewDate DATE NOT NULL,"
	echo "  hotelID INTEGER NOT NULL,"
	echo "  URL VARCHAR(256),"
	echo "  averagePrice INTEGER,"
	echo "  content TEXT,"
	echo "  overall INTEGER NOT NULL,"
	echo "  overallRating INTEGER NOT NULL,"
	echo "  businessService INTEGER,"
	echo "  checkIn INTEGER,"
	echo "  cleanliness INTEGER,"
	echo "  rooms INTEGER,"
	echo "  service INTEGER,"
	echo "  value INTEGER,"
	echo "  noReaders INTEGER NOT NULL DEFAULT 0,"
	echo "  noHelpful INTEGER NOT NULL DEFAULT 0,"
	echo "  FOREIGN KEY (hotelID) REFERENCES Hotels(hotelID)"
	echo ");"
}

# Processes an individual hotel file
# @param $1 Filename of hotel file
function processHotel() {
	hotelID=$(getHotelID $1)
	tr -d '\r' < $1 | awk \
		-v hotelID="$hotelID" -E generate_sh.awk
}

# Prints out a progress bar
# @param $1 Current iteration number
# @param $2 Number of iterations
function printProgress() {
	awk '
	BEGIN {
		percentage = ( '$1' / '$2');
		numberHashes = ( percentage * 50 );
		hashString = "";
		for(i = 1; i < numberHashes; i++){
			hashString = hashString "#";
		}
		printf("\rProgress [%-50s] (%.2f%)", hashString, ( percentage * 100 ));
	}'
}

# Returns a field from a string
# @param $1 String
# @param $2 Field Name to filter
function getField() {
	grep "$2" $1 | sed -e "s:$2::"
}

# Create the table
echo "$(createTable)" > hotelreviews.sql

# If the file is a directory, then iterate over the directory
if [ -d $1 ]
then
	fileCount=$(ls -l $1 | wc -l)
	counter=0
	for f in $1/*
	do
		echo "$(processHotel $f)" >> hotelreviews.sql
		counter=$((counter+1))
		printProgress $counter $fileCount
	done
	printProgress $fileCount $fileCount
else
	# Otherwise process one file (useful for testing files that break the script)
	echo -e "$(processHotel $1)" >> hotelreviews.sql
fi

echo -ne "\n"
