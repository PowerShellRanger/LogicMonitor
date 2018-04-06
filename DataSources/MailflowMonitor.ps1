
$mailbox = "##WILDVALUE##"
$officeUser = '##office365.user##'
$officePass = '##office365.pass##'

# build a credential object
$securePass = ConvertTo-SecureString -String $officePass -AsPlainText -Force
$userCredential = New-Object -TypeName System.Management.Automation.PSCredential ($officeUser, $securePass)

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $userCredential -Authentication Basic -AllowRedirection

if (-not $exchangeSession) 
{
    Start-Sleep -Seconds 60
    $exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $userCredential -Authentication Basic -AllowRedirection -ErrorAction Stop
}

[void](Import-PSSession $exchangeSession -AllowClobber -DisableNameChecking)

$mailboxInbox = @(Get-MailboxFolderStatistics -Identity $mailbox -FolderScope Inbox -IncludeOldestAndNewestItems).where({ $_.FolderPath -eq '/Inbox' }) #| select OldestItemReceivedDate, ItemsInFolder

Remove-PSSession -Session $exchangeSession -Confirm:$false

if (-not $mailboxInbox.OldestItemReceivedDate) 
{
    Write-Verbose "There were zero items in the OldestItemReceiveDate property for $($mailboxInbox.Identity)."
    # LogicMon exit code
    return 0
}
else 
{
    return [math]::Round((New-TimeSpan -Start $mailboxInbox.OldestItemReceivedDate.ToUniversalTime() -End (Get-Date).ToUniversalTime()).TotalMinutes)
}

