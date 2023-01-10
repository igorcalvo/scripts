$rootFolder = "C:\Users\Igor\AppData\Local\Discord\"
cd $rootFolder
$folder = Get-ChildItem $rootFolder | Sort-Object -Property Name | Select-Object -Skip 1 | Select-Object -First 1
cd $folder
$cmd = ".\" + "Discord.exe"
Invoke-Expression $cmd
exit