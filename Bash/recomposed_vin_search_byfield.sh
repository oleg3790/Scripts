#!/usr/bin/bash
# file content search and recomposition by column number

search_item=""
version=$(date +"%Y-%m-%d")
echo; echo; 
echo "Search Item: "; read search_item
outputfile=${search_item}"_"$(date +"%m%d%Y")".txt"

echo
if [ -z "$search_item" ]; then
		echo "Invalid Search Item"
else 
		echo "Search filename: "; read filename 
		fileformat=$(echo $filename | wc -c)
		
		if [ -f $filename ]; then
			echo; 
			echo "Initiating archive file reformat..."
			zgrep $search_item $filename | 
			awk -F '|' '{if ($30 != null) print "\""$2"\",\"'$version' 00:00:00\",\""$30"\""}' > $outputfile
			echo; echo;
			echo "Recomposed file "$outputfile" created"
		else
			echo "File not found"
		fi
fi 
