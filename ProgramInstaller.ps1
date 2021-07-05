# Init
## Timestamp
filter timestamp {"$(Get-Date -Format G): $_"}
## Web Download
$WebClient = New-Object System.Net.WebClient
## Error Log File
Set-Content -Path ./FailedInstall.txt -Value '"name","url","type","installer"'
## Create Installers Folder
$installerpath = -join("$pwd", "\Installers")
if ((Test-Path $installerpath) -eq $false) {
	New-Item -Path $installerpath -ItemType directory | Out-Null
	echo "Generated Folder `"Installers`"" | timestamp
}

# Set Options on Closing
function close () {
	# Delete Installers 
	$EraseInstallerFolder = Read-Host "Enter [y] to erase all installer files"
	if ($EraseInstallerFolder -eq "y") {
		RD $installerpath -Recurse
		echo "Erased `"Installers`" Folder" | timestamp
	}

	# Reset Restrict Policy
	$RestrictPolicyInput = Read-Host "Enter [r] to set ExcutionPolicy Restricted"
	if ($RestrictPolicyInput -eq "r") {
		Set-ExecutionPolicy Restricted
		echo "Set ExecutionPolicy Restricted" | timestamp
	} else {
		echo "Warning : ExcutionPolicy is Unrestricted" | timestamp
	}

	echo "Ending Installer" | timestamp
}

# Write Error File
function errorlog ($name, $url, $type, $installername="") {
	echo "`"$name`",`"$url`",`"$type`",`"$installername`"" | Add-Content -Path ./FailedInstall.txt
	echo "Wrote $name to FailedInstall.txt" | timestamp
}

# Download Install File and Install
function programDI ($name, $url, $type, $installername) {
	$downloadErrorFlag = $false
	$installErrorFlag = $false
	if ($type -eq "1") { # exe
		# Download
		echo "Downloading $name Install File..." | timestamp
		$path = -join("$pwd", "\Installers\", "$name", "Installer.exe")
		try {
			$WebClient.DownloadFile($url, $path)
		}
		catch {
			echo "Error : Error During $name Installer Download" | timestamp
			errorlog $name $url $type 
			$downloadErrorFlag = $true
		}
		
		# Install
		if ($downloadErrorFlag -eq $false) {				
			echo "Runnig $name Installer.exe..." |timestamp
			try {
				Start-Process -Wait -FilePath $path
			} 
			catch {
				echo "Error : Error During $name Installing" | timestamp
				errorlog $name $url $type
				$installErrorFlag = $true
			}
			echo "Installer Closed" | timestamp
			if ($installErrorFlag -eq $false) {
				$writeError = Read-Host "Do you want to write the program to FailedInstall.txt? [y]"
				if ($writeError -eq "y") {
					errorlog $name $url $type
				}
			}	
		}
	}elseif($type -eq 2) { # msi
		# Download
		echo "Downloading $name Install File..." | timestamp
		$path = -join("$pwd", "\Installers\", "$name", "Installer.msi")
		try {
			$WebClient.DownloadFile($url, $path)
		}
		catch {
			echo "Error : Error During $name Installer Download" | timestamp
			errorlog $name $url $type
			$downloadErrorFlag = $true
		}
		
		# Install
		if ($downloadErrorFlag -eq $false) {				
			echo "Runnig $name Installer.msi..." |timestamp
			try {
				Start-Process -Wait -FilePath $path
			} 
			catch {
				echo "Error : Error During $name Installing" | timestamp
				errorlog $name $url $type
				$installErrorFlag = $true
			}
			echo "Installer Closed" | timestamp
			if ($installErrorFlag -eq $false) {
				$writeError = Read-Host "Do you want to write the program to FailedInstall.txt? [y]"
				if ($writeError -eq "y") {
					errorlog $name $url $type
				}
			}	
		}	
	}elseif($type -eq 3) { # zip
		# Download
		echo "Downloading $name Install File..." | timestamp
		$path = -join("$pwd", "\Installers\", "$name", "Installer.zip")
		$zippath = -join("$pwd", "\Installers\", "$name")
		
		try {
			$WebClient.DownloadFile($url, $path)
		}
		catch {
			echo "Error : Error During $name Installer Unzipping" | timestamp
			errorlog $name $url $type $installername
			$downloadErrorFlag = $true
		}
		
		# Unzip
		if ($downloadErrorFlag -eq $false) {
			# Unzip
			echo "Unzipping $name Install File..." | timestamp
			try {
				Expand-Archive $path -DestinationPath $zippath
			}
			catch {
				echo "Error : Error During $name Installer Unzipping" | timestamp
				errorlog $name $url $type $installername
				$downloadErrorFlag = $true
			}		
		}
		
		# Install 
		if ($downloadErrorFlag -eq $false) {
			$zipexe = -join("$zippath", "\", $installername)
			echo "Runnig "$name"Installer.exe..." |timestamp
			try {
				Start-Process -Wait -FilePath $zipexe
			} 
			catch {
				echo "Error : Error During $name Installing" | timestamp
				errorlog $name $url $type $installername
				$installErrorFlag = $true
			}
			echo "Installer Closed" | timestamp
			if ($installErrorFlag -eq $false) {
				$writeError = Read-Host "Do you want to write the program to FailedInstall.txt? [y]"
				if ($writeError -eq "y") {
					errorlog $name $url $type $installername
				}
			}
		}
		
	}else{ # Exception
		echo "Error : Invalid Type" | timestamp
		errorlog $name $url $type
	}
	
}

# Main
function main () {
	$filename = Read-Host "Enter file name : "
	Import-Csv $filename | ForEach-Object {
		programDI $($_.name) $($_.url) $($_.type) $($_.installer)
	}
	close
}

main