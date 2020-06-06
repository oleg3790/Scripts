# Will search a file(text) for a pattern, reformatting the results 
# into a vin, version(date), url file 

$resultFilename = "recomposed_search_result.txt"
$searchItem = Read-Host -Prompt 'Search Item'
$searchFile = Read-Host -Prompt 'Search File'
$delim = Read-Host -Prompt 'File Delimiter'
$excludeImages = Read-Host -Prompt 'Exclude records with less than 3 images? (true or false)'

$searchCollection = New-Object System.Collections.ArrayList
Select-String -Path $searchFile -Pattern $searchItem | foreach {$searchCollection.Add($_)}

$dataStore = New-Object System.Collections.ArrayList

foreach($item in $searchCollection)
{
	$delimited = $item -split $delim
	$dataCells = "",""
	
	foreach($elem in $delimited)
	{
		
		if ($elem -match "^[A-Z0-9]{17}$")
		{
			$dataCells[0] = $elem			
		}		
		
		if ($elem -match "http")
		{
			$dataCells[1] = $elem
			
			if ($excludeImages -eq "true")
			{
				$images = $elem -split ','
				if ($images.Count -lt 3)
				{
					$dataCells[1] = ""
				}
			}			
		}				
	}
	
	if ($dataCells[0] -ne "" -and $dataCells[1] -ne "")
	{
		$dataStore.Add([string]::Format('"{0}","{1}","{2}"', $dataCells[0], (Get-Date).ToString("MM/dd/yyyy hh:mm"), $dataCells[1]))
	}	
}
$dataStore > $resultFilename
