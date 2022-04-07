# ConsolidateRowsCSv.ps1 Summary
#
# This script:
# Takes a csv file where multiple rows are associated with the same Column Header and then consolidated into one Row of a unique ColumnHeader with all other associated rows concatenated into one Row.
# 1. Loads an input .csv
# 2. Concatenates all specified ColumnHeaders per Designated unique ColumnHeader into Summary Object Array
# 3. Filters input.csv for each of hte last row of each unique Column Header
# 4. Created output.csv
# Example use is an API call to download all User Stories, Bugs, Comments, etc. from Azure DevOps into a csv file results in each item (including comments) under a Work Item has its own ID number but all data must be consolidated under a single Work Item (User Story).

$Input_All = Import-CSV "Directory:\Filepath\Filename.csv"

# Get all unique IDs based on ColumnHeader (WorkItemID)

$WorkItemIDs_Unique = ($Input_All | Group-Object -Property WorkItemID).Name

# Loop on the unique WorkItemIDs, filter on a single WorkItemID, Concatenate and create array of WorkItemID_Summary

$WorkItemID_Summary = @()

foreach ($TPWorkItemID in $WorkItemIDs_Unique) {
	Write-Host "WorkItemID = $(WorkItemID)"
	$TaskRows = $Input_All | Where-Object {$_.WorkItemID -eq $WorkItemID } 
#List out ColumnHeaders as Items, repeat as necessary
	$UserStory = (($TaskRows | Goup-Object -Property UserStories).Name | Where-Object {$_ -ne ""}) -join ", "
	$UserStory

	$UserStoryDescription = (($TaskRows | Goup-Object -Property UserStoryDescription).Name | Where-Object {$_ -ne ""}) -join ", "
	$UserStoryDescription

	$UserStoryCommentsDescription = (($TaskRows | Goup-Object -Property UserStoryCommentsDescription).Name | Where-Object {$_ -ne ""}) -join ", "
	$UserStoryCommentsDescription

	$Props = @{
		WorkItemID = $WorkItemID
		UserStory = $UserStory
		UserStoryDescription = $UserStoryDescription
		UserStoryComments = $UserStoryCommentsDescription
}

# Create object with Summary Data
$TaskRow_Result = New-Object psobject -Property $Props | Select-Object -Property WorkItemID,UserStory,UserStoryDescription,UserStoryComments

# Add Row Summary to Summary Array
	$WorkItemID_Summary += $TaskRow_Result
}

# $WorkItemIDSummary
# Filter Input file for only one row for each WorkItemID
	$InputRows_Unique = @()
	foreach (WorkItemID in WorkItemIDs_Unique) {
	# grab one row
	$InputRow_Unique = $Input_All | Where-Object {$_.WorkItemID -eq $WorkItemID } | Select-Object -Last 1

	# Add to Array
	$InputRows_Unique += $InputRow_Unique

}

# $InputRows_Unique
# Join with Summary Data

	$InputRowsWithSummary = @()
	foreach ($Row in $InputRows_Unique) {
	# Get Summary Row
	$WorkItemID_Summary_Row = $WorkItemID_Summary | Where-Object {$Row.WorkItemID -eq $_.WorkItemId}

	$InputRowWithSummary = $Row | Select-Object *,
				
				@[N='UserStory';E={
					($WorkItemID_Summary_Row.UserStory)
					}
				},
				@[N='UserStoryDescription';E={
					($WorkItemID_Summary_Row.UserStoryDescription)
					}
				},
				@[N='UserStoryComments';E={
					($WorkItemID_Summary_Row.UserStoryComments)
					}
				}
			}
	$InputRowsWithSummary += $InputRowWithSummary

	# $InputRowsWithSummary
	# Export to csv

	$InputRowsWithSummary | Export-CSV -Path "Directory:\Filepath\Filename.csv" -Force -NoTypeInformation
	ii "Directory:\Filepath\Filename.csv"