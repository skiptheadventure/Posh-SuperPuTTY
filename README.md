# Posh-SuperPuTTY
## Description
SuperPutty is a Windows GUI Application that allows the PuTTY SSH Client to be opened in Tabs. Additionally there is support for SCP to transfer files. [https://jimradford.github.io/superputty/](https://jimradford.github.io/superputty/)
Posh-SuperPuTTY is a set of PowerShell commands for reading and manipulating the SuperPuTTY XML sessions file.

## Commands
### Connect-SPSession
#### Parameters
-ComputerName
    The SuperPuTTY session name to connect to.
-Username
    Username to connect with.

#### Examples
PS C:\\> Connect-SPSession -ComputerName Foo -Username Bar

### Get-SPSessions
#### Parameters
-Path
    Path to the SuperPuTTY sessions file. Defaults to $env:USERPROFILE\Documents\SuperPuTTY\Sessions.xml.

#### Examples
PS C:\\> Get-SPSessions -Path C:\Foo\Bar\Sessions.xml

### New-SPSession
#### Parameters
-XMLPath
    Path to the SuperPuTTY sessions file. Defaults to $env:USERPROFILE\Documents\SuperPuTTY\Sessions.xml.
-CSVPath
    CSV file to import sessions from.

#### CSV File Header
SessionName,SessionId,ImageKey,Host,Port,Proto,PuttySession,Username,ExtraArgs,SPSLFileName,RemotePath,LocalPath

#### Examples
PS C:\\> New-SPSession -XMLPath C:\Foo\Bar\Sessions.xml -CSVPath C:\Bar\Foo\Sessions_to_Import.csv
