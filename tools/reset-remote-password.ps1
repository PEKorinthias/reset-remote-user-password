param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Username
)
$otherusername = $Username
if ($otherusername -EQ "") {
    Write-Output "No username given"
}
else {
    # Define remote server credentials
    $Server = "server name or ip"           # Replace with the server's name or IP

    # #$Username = "administrator username"    # Replace with your username
    # #$Password = "administrator password"    # Replace with your password

    # # Secure the password
    # #$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    # #$Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
    $Credential = Get-Credential


    # Define the command to run on the remote server
    $RemoteCommand = {
        param($otherusername)
        # $otherusername = 'other username'
        if ($otherusername -EQ "") {
            Write-Output "No username given"
        }
        else {
            if (Get-LocalUser -Name $otherusername -ErrorAction SilentlyContinue) {
                $otherpassword = Invoke-WebRequest -Uri "https://korinthia.ppel.gov.gr/passwd/" | Select-Object -ExpandProperty Content
                Write-Host "Setting password for " -NoNewline
                Write-Host $otherusername -ForegroundColor Cyan -NoNewline
                Write-Host " to " -NoNewline
                Write-Host $otherpassword -ForegroundColor Cyan -NoNewline
                Write-Host ""
                net user $otherusername $otherpassword
            }
            else {
                Write-Output "User does not exist"
            }
        }
    }

    # Run the command on the remote server
    Invoke-Command -ComputerName $Server -Credential $Credential -ScriptBlock $RemoteCommand -ArgumentList $otherusername
}

pause
