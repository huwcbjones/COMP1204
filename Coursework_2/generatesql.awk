BEGIN {
	# This allows us to read the file as a series of records separated by blank lines.
	# The fields are deliminated by newlines (\n)
	RS = "";			# Set record separator to ""
	FS = "\n";			# Set field separator to "\n"
	recordNum = 0;		# Set record counter to 0
}

# Checks if a field has a value of -1, and if so, returns 0.
# @param field Field to zero check
function zeroCheck(field){
	if(field == -1){
		return 0;
	} else {
		return field;
	}
}

# Checks if a field has a value of -1, and if so, returns null.
# @param field Field to null check
function nullCheck(field){
	if(field == -1){
		return "NULL";
	} else {
		return field;
	}
}

# Escapes a field to prevent SQL errors
function escapeField(field){
	gsub(/"/, "\"\"", field);
	return field;
}

# Formats the record into a SQL insert statement
# @param rowNumber Row (record) number of the row to format
function formatRow(rowNumber){
	insert = "INSERT INTO HotelReviews (author, reviewDate, hotelID, URL, averagePrice, overallRating, content, overall, businessService, checkIn, cleanliness, location, rooms, service, value, noReaders, noHelpful) VALUES (";
	insert = insert "\"" data[rowNumber "@author"]"\", ";
	insert = insert data[rowNumber "@date"] ", ";
	insert = insert hotelID ", ";
	insert = insert "\"" URL "\", ";
	insert = insert nullCheck(avgPrice) ", ";
	insert = insert overallRating ", ";
	insert = insert "\"" escapeField(data[rowNumber "@content"]) "\", ";
	insert = insert data[rowNumber "@overall"] ", ";
	insert = insert nullCheck(data[rowNumber "@business"]) ", ";
	insert = insert nullCheck(data[rowNumber "@checkin"]) ", ";
	insert = insert nullCheck(data[rowNumber "@cleanliness"]) ", ";
	insert = insert nullCheck(data[rowNumber "@location"]) ", ";
	insert = insert nullCheck(data[rowNumber "@rooms"]) ", ";
	insert = insert nullCheck(data[rowNumber "@service"]) ", ";
	insert = insert nullCheck(data[rowNumber "@value"]) ", ";
	insert = insert zeroCheck(data[rowNumber "@readers"]) ", ";
	insert = insert zeroCheck(data[rowNumber "@helpful"]);
	insert = insert ");";
	return insert;
}

{
	# Loop through all fields in record. NF is number of fields
	for (i = 1; i <= NF; i++){
		if(recordNum == 0){							# Get hotel properties (first, or 0th record)
			if(match($i, "<Overall Rating>")){
				gsub(/<Overall Rating>/, "", $i);
				overallRating = $i;
			} else if(match($i, "<Avg. Price>")){
				gsub(/<Avg. Price>\$/, "", $i);
				# Remove thousand separator
				gsub(/,/, "", $i);
				# Check to see if avg price is not "Unknown" (note, it is spelt correctly here, but the if will check for strings)
				if( $i + 0 != $i ){
					avgPrice = -1;
				} else {
					avgPrice = $i;
				}
			} else if(match($i, "<URL>")){
				gsub(/<URL>/, "", $i);
				URL = $i;
			}
		}
		# Get the record fields
		if(match($i, "<Author>")){					# Author
			gsub("<Author>", "", $i);
			data[recordNum "@author"] = $i;
		} else if(match($i, "<Date>")){				# Date (format to SQL yyyy-mm-dd)
			gsub(/<Date>/, "", $i);
			cmd = "date \"+%Y-%m-%d\" -d \"$i\"";
			cmd | getline date;
			data[recordNum "@date"] = date;
			close(cmd);
		} else if(match($i, "<Overall>")){			# Overall Score
			gsub("<Overall>", "", $i);
			data[recordNum "@overall"] = $i;
		} else if(match($i, "<Business service>")){	# Business Service
			gsub(/<Business service>/, "", $i);
			data[recordNum "@business"] = $i;
		}  else if(match($i, "<Content>")){			# Content
			gsub(/<Content>/, "", $i);
			data[recordNum "@content"] = $i;
		} else if(match($i, "<Check in / front desk>")){	#	Check In
			gsub(/<Check in \/ front desk>/, "", $i);
			data[recordNum "@checkin"] = $i;
		} else if(match($i, "<Cleanliness>")){		# Cleanliness
			gsub(/<Cleanliness>/, "", $i);
			data[recordNum "@cleanliness"] = $i;
		} else if(match($i, "<Location>")){			# Location
			gsub(/<Location>/, "", $i);
			data[recordNum "@location"] = $i;
		} else if(match($i, "<Rooms>")){			# Rooms
			gsub(/<Rooms>/, "", $i);
			data[recordNum "@rooms"] = $i;
		} else if(match($i, "<Service>")){			# Service
			gsub(/<Service>/, "", $i);
			data[recordNum "@service"] = $i;
		} else if(match($i, "<Value>")){			# Value
			gsub(/<Value>/, "", $i);
			data[recordNum "@value"] = $i;
		} else if(match($i, "<No. Reader>")){		# Number of Readers
			gsub(/<No. Reader>/, "", $i);
			data[recordNum "@readers"] = $i;
		} else if(match($i, "<No. Helpful>")){		# Number of Helpful 
			gsub(/<No. Helpful>/, "", $i);
			data[recordNum "@helpful"] = $i;
		}
	}
	if(recordNum != 0){
		print formatRow(recordNum);
	}
	recordNum++;
}
