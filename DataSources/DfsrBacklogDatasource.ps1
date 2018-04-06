#LogicMon active discovery part
function Get-DfsShareLogicMon
{
     <#
    .Synopsis
        This cmdlet gets DFS shares on a Windows server.
    .DESCRIPTION
        Use this cmdlet to retreive Shares on a Windows server.
    .EXAMPLE

    .EXAMPLE
    #>
    [CmdletBinding()]
    Param
    (
        # ComputerName
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )
    begin
    {
    }
    process
    {
        foreach ($computer in $ComputerName) {
            $shares = (Get-WmiObject -ComputerName $computer -Namespace "root\MicrosoftDFS" -Class "DfsrReplicatedFolderInfo").ReplicatedFolderName | Select -Unique            

            foreach ($share in $shares) {
                [PSCustomObject] @{
                    ShareName = "$($share)##$($share)"
                }
            }
        }
    }
    end
    {        
    }
}

$hostname = "##HOSTNAME##"

$shares = $hostname | Get-DfsShareLogicMon

$shares.ShareName
return 0

#LogicMon collector part
function Get-DfsrBacklogLogicMon
{
     <#
    .Synopsis
        This cmdlet checks the DFSR backlog for DFS shares on a Windows server.
    .DESCRIPTION
        Use this cmdlet to check the DFSR backlog for DFS shares on a Windows server.
    .EXAMPLE

    .EXAMPLE
    #>
    [CmdletBinding()]
    Param
    (
        # ComputerName
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

        # FolderName
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$FolderName
    )
    begin
    {
    }
    process
    {
        foreach ($computer in $ComputerName) {

            try {
                $replicatedFolder = Get-DfsReplicatedFolder -FolderName $FolderName -ErrorAction Stop
                $dfsrMembers = Get-DfsrMember -GroupName $replicatedFolder.GroupName -ErrorAction Stop
            }
            catch {
                Write-Verbose "An error occured and the cmdlet was not able to check the backlog for $FolderName." 
                Write-Error $_
                [PSCustomObject] @{                    
                    Error = $true
                }
                continue
            }

            $sourceDfsrMember = ($dfsrMembers.Where({ $_.DnsName -eq $computer })).DnsName    
            $destinationDfsrMember = ($dfsrMembers.Where({ $_.DnsName -ne $computer })).DnsName    

            if ($sourceDfsrMember -and $destinationDfsrMember) {
                
                try {
                    $backlog = [int](Get-DfsrBacklog -GroupName $($replicatedFolder.GroupName) -FolderName $($replicatedFolder.FolderName) -SourceComputerName $sourceDfsrMember -DestinationComputerName $destinationDfsrMember -ErrorAction Stop -Verbose 4>&1).Message.Split(':')[2]
                }
                catch {
                    Write-Verbose "An error occured and the cmdlet was not able to check the backlog for $($replicatedFolder.FolderName)."                    
                    [PSCustomObject] @{                        
                        Error = $true
                    }
                    continue
                }                               
                [PSCustomObject] @{
                    Backlog = $backlog
                    Error = $false
                }             
            }
        }
    }
    end
    {        
    }
}

$hostname = "##HOSTNAME##"
$folder = "##WILDVALUE##"

if (-not ((Get-WindowsFeature -Name "RSAT-DFS-Mgmt-Con").InstallState -eq "Installed")) {
    Install-WindowsFeature -Name "RSAT-DFS-Mgmt-Con" -Confirm:$false -ErrorAction Stop | Out-Null
}

if (-not (Get-Module| where {$_.Name -like "DFSR"})) {
    Import-Module DFSR -ErrorAction Stop
}

$backlog = $hostname | Get-DfsrBacklogLogicMon -FolderName $folder

if ($backlog.Error) {
    # LogicMon error exit code
    return 1
}
else {
    $backlog.Backlog
    # LogicMon exit code
    return 0
}