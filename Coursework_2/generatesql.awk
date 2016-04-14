BEGIN {
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
		# Get hotel properties (first, or 0th record)
		if(recordNum == 0){
			if(match($i, "<Overall Rating>")){
				sub(/<Overall\ Rating>/, "", $i);
				overall = $i;
			} else if(match($i, "<Avg. Price>")){
				sub(/<Avg. Price>\$/, "", $i);
				avgPrice = $i;
			} else if(match($i, "<URL>")){
				sub(/<URL>/, "", $i);
				URL = $i;
			} else if(match($i, "<Avg. Price>")){
				sub(/<Avg\. Price>/, "", $i);
				avgPrice = $i;
			}
			next;
		}
		# Get the record fields
		if(match($i, "<Author>")){
			sub(/<Author>/, "", $i);
			data[recordNum]["author"] = $i;
		} else if(match($i, "<Business Service>")){
			sub(/<Business Service>/, "", $i);
			data[recordNum]["business"] = $i;
		} else if(match($i, "<Check in / front desk>")){
			sub(/<Check in \/ front desk>/, "", $i);
			data[recordNum]["checkin"] = $i;
		} else if(match($i, "<Cleanliness>")){
			sub(/<Cleanliness>/, "", $i);
			data[recordNum]["cleanliness"] = $i;
		} else if(match($i, "<Content>")){
			sub(/<Content>/, "", $i);
			data[recordNum]["cleanliness"] = $i;
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