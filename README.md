# Program Installer
#### About
This Powershell script downloads and installs necessary utilities you need.



#### Before using the program

You have to write Installfiles.txt manually.

The file format is:

```
"name","url","type","installer"
"Program1 name","Program 1 url",1
"Program2 name","Program 2 url",2
"Program3 name","Program 3 url",3,"Program 3 installer"
...
```

For "type":

​	1 if the installer is .exe   

​	2 if the installer is .msi   

​	3 if the installer is .zip. For zip files, you have to add installer name in the zip file. You do not have to for type 1 and 2.




#### How to use
1. Open Powershell as Admin.
2. change directory to the folder with ProgramInstaller.ps1.
```
PS C:\Users> cd C:\Download\ProgramInstaller
PS C:\Download\ProgramInstaller>
```
3. Set ExecutionPolicy to Unrestricted.
```
PS C:\Download\ProgramInstaller> Set-ExecutionPolicy Unrestricted
```
4. Run ProgramInstaller.ps1.
```
PS C:\Download\ProgramInstaller> .\ProgramInstaller.ps1
```
5. Input "Installfiles.txt" file

```
Enter file name : Installfiles.txt
```

6. Installers will keep popping up. Install all the programs.
7. If error occurred during the installer, you can add the program to error log manually with [y] after the installer is closed.
8. When all installations are done, enter [y] to erase all installers downloaded.
9. Enter [r] and set ExecutionPolicy to Restricted.
10. To retry installing failed programs, rerun ProgramInstaller.ps1 and input "FailedInstall.txt".




#### Known Error
- Unable to download Classic Sticky Note and FileZilla from the server
- Unable to download Microsoft Visual Studio Installer



#### Version

**1.0** 

**2.0** 

Changed program logic. 

You can now add programs with InstallFiles.txt.

You can retry installing with Error logs.

Now automatically erase install files.