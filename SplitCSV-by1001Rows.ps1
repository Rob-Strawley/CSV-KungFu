# This script takes a large csv file with 1405 rows and separates the Workbook into individual CSV files with 1000 Row limit, excluding Column header
# Number of rows can be changed so long as the number immediately preceeding and following the target number is used in this script
# Example- if 1000 lines are the limit for each csv, the you must use "-first 999" and "$startrow += 1001;"

$sourceCSV = "Directory:\Filepath\Filename.csv"
$startrow = 0;
$counter = 1 ;
# -lt is last Row in sheet
while ($startrow -lt 1405)
	{
import-csv $sourceCSV | Select-object -skip $startrow -first 999 | Export-CSV "Directory:\Filepath\Filename$($counter).csv" -NoCLobber -NoTypeInformation;
$startrow += 1001;
$counter++;
}