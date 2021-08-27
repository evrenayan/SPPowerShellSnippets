# You can download a file from your SharePoint site using PowerShell
$siteurl = "http://yoursite"
$sourcefile = "SharedDocuments/Book1.xlsx"
$destinationfile = "C:\Temp\Book1.xlsx"
$web = Get-SPWeb $siteurl
$file = $web.GetFile($sourcefile)
$filebytes = $file.OpenBinary()
$filestream = New-Object System.IO.FileStream($destinationfile, "Create")
$binarywriter = New-Object System.IO.BinaryWriter($filestream)
$binarywriter.write($filebytes)
$binarywriter.Close()
