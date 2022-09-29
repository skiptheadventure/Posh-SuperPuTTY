function Get-SPSessions {
	Param(
		$Path
	)
	
	if (($null -eq $Path) -or ($Path -eq "")){
		$Path = Join-Path -Path $([Environment]::GetFolderPath("MyDocuments")) -ChildPath 'SuperPUTTY\Sessions.xml'
	}
	
	[xml]$Sessions = Get-Content -Path $Path
	$SessionData = $Sessions.ArrayofSessionData.SessionData
	Remove-Variable Sessions
	$objSessions = @()
	
	foreach ($Session in $SessionData){
		if ($Session.SessionID -match "/"){
			$Split = $Session.SessionID -split "/"
			
			if ($Split.Count -gt 2) {
				$Folder = $null
				$index = 0
				
				do {
					$Folder += $Split[$index] + "/"
					$index++				
				} until ($index -eq ($Split.Count - 1))
				
				$Folder = $Folder -replace "/$",""
				$Site = $Split[0]
			} else {
				$Site = $Split[0]
				$Folder = $Site
			}
		}
		else {
			$Site = $Session.SessionID
		}
		
		$objSession = [pscustomobject]@{
			'Site' = $Site
			'Folder' = $Folder
			'Name' = $Session.SessionName
			'IP' = $Session.Host
			'Protocol' = $Session.Proto
		}
		
		$objSessions += $objSession
	}
	
	$global:SPSessions = $objSessions
	return $objSessions
}

Function New-SPSession {
	Param(
		$XMLPath,
		$CSVPath
	)
	
	if (!($XMLPath)){
		$XMLPath = Join-Path -Path $([Environment]::GetFolderPath("MyDocuments")) -ChildPath 'SuperPUTTY\Sessions.xml'
	}
	
	$NewSessions = Import-CSV -Path $CSVPath
	[xml]$SessionXML = Get-Content -Path $XMLPath
	
	foreach($NewSession in $NewSessions) {
		$element = $SessionXML.ArrayofSessionData.SessionData[0].Clone()
		$element.ExtraArgs = $NewSession.ExtraArgs
		$element.Host = $NewSession.Host
		$element.ImageKey = $NewSession.ImageKey
		$element.LocalPath = $NewSession.LocalPath
		$element.Port = $NewSession.Port
		$element.Proto = $NewSession.Proto
		$element.PuttySession = $NewSession.PuttySession
		$element.RemotePath = $NewSession.RemotePath
		$element.SessionId = $NewSession.SessionId
		$element.SessionName = $NewSession.SessionName
		$element.SPSLFileName = $NewSession.SPSLFileName
		$element.Username = $NewSession.Username
		$SessionXML.ArrayofSessionData.AppendChild($element) | Out-Null
	}
	
	return $SessionXML
}
function Connect-SPSession {
	Param (
		$ComputerName,
		$Username
	)
	
	if (!($global:SPSessions)){
		Get-SPSessions | Out-Null
	}
	
	$Session = $global:SPSessions | Where-Object {$_.name -eq $ComputerName}
	
	if (!($Session)){
		Write-Error "$ComputerName not in session list."
		return
	}
	else {
		$SSHParam = "$($Username)@$($Session.IP)"
		ssh $SSHParam
	}
}