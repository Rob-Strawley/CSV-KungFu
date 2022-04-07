
#Open up worksheet

$excel = new-object -comobject Excel.Application
$excel.visible = $false
$workbook =
$excel.workbooks.open("Directory:\Filepath\file.csv")
$worksheet = $workbook.Worksheets.Item(1)

## Enter Formula

[void]$worksheet.Cells.replace("oldText","NewText")

## Repeat Formula as necessary

$excel.visible = $true