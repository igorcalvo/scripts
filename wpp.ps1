While ($true)
{ 
	Start-Process "chrome.exe" "https://web.whatsapp.com/",'--profile-directory="Default"' -PassThru
	Start-Sleep -s 8
	$wshell = New-Object -ComObject wscript.shell
	$wshell.SendKeys("^w")
	start-sleep -seconds 900
}
