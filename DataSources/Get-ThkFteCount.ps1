### LogicMon Active Discovery
if (!((Get-WindowsFeature -Name "RSAT-AD-PowerShell").InstallState -eq "Installed")) {
    try {
        [void](Install-WindowsFeature -Name "RSAT-AD-PowerShell" -Confirm:$false -ErrorAction Stop)
    }
    catch {
        throw $_.ExceptionMessage
    }
}
if (!(Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    try {
        [void](Import-Module -Name ActiveDirectory -ErrorAction Stop)
    }
    catch {
        throw $_.Exception.Message
    }
}

$adGroup = Get-ADGroup -Filter {Name -eq "Think-All Corporate Employees"} -Server paydayone.com

$output = "$($adGroup.Name)##$($adGroup.Name)"

Write-Output $output

### LogicMon Collection
if (!((Get-WindowsFeature -Name "RSAT-AD-PowerShell").InstallState -eq "Installed")) {
    try {
        [void](Install-WindowsFeature -Name "RSAT-AD-PowerShell" -Confirm:$false -ErrorAction Stop)
    }
    catch {
        throw $_.ExceptionMessage
    }
}
if (!(Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    try {
        [void](Import-Module -Name ActiveDirectory -ErrorAction Stop)
    }
    catch {
        throw $_.Exception.Message
    }
}

$adUsers = Get-ADGroup -Filter {Name -eq "Think-All Corporate Employees"} -Server paydayone.com | Get-ADGroupMember -Recursive | select -Unique | Get-ADUser | where {$_.Enabled}

Write-Output $adUsers.Count