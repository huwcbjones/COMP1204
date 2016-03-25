#!/bin/bash
if [ $# -ne 1 ]
then
	echo "No argument passed to script.";
	exit 1;
fi

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
}

if [ -d $1 ]
then
	echo "$(createTable)" > hotelreviews.sql
	for f in $1/*
	do
		echo "$(processHotel $f)" >> hotelreviews.sql
	done
else
	echo "Argument provided was not a directory"
fi
