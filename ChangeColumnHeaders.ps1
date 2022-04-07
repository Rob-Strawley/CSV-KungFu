$Input_All = Import-CSV "Directory:\Filepath\filename.csv"
$Rows = @()

foreach ($Row in $Input_All) {
	$Props = @{
## Changes Header Column titles: "New Title header" = $Row."Current.Title.Header"
	"Work Item Type" = $Row."Items.ResourceType"
	Description = $Row."Item.Description"
	"Pet Name" = $Row."PetName"
## Repeat as necessary
	}

	$NewRow = New-Object psobject -Property $Props | Select-Object -Property "Work Item Type","Description","Pet Name" 
	
	$Rows += $NewRow
}

## Save as New File

$Rows | Export-csv -Path "Directory:\Filepath\filename.csv" -Force -NoTypeInformation

ii "Directory:\Filepath\filename.csv"