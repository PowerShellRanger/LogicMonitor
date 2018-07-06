function New-LogicMonDevice
{
    <#
    .Synopsis
       
    .DESCRIPTION
       
    .EXAMPLE
       
    .EXAMPLE
       
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "High"        
    )]
    param
    (
        # Name of device
        [Parameter(
            Mandatory,
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [string]$DeviceName,

        # Display name of device
        [Parameter(            
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [string]$DisplayName,

        # Preferred Collector Id of device
        [Parameter(  
            Mandatory,          
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [int]$PreferredCollectorId,

        # Host Group Ids of device
        [Parameter(  
            Mandatory,          
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [string[]]$HostGroupId,

        # Access Key from LogicMon for your user account
        [Parameter(
            Mandatory, 
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName
        )]
        [string]$AccessKey,

        # Access ID from LogicMon for your user account
        [Parameter(
            Mandatory, 
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName
        )]
        [string]$AccessId,

        # LogicMon Company Name
        [Parameter(
            Mandatory, 
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName
        )]
        [string]$Company
    )
    begin
    {
    }
    process
    {        
        if ($PSCmdlet.ShouldProcess("Create new device: $DeviceName in $Company's LogicMonitor."))
        { 
            $errorAction = $ErrorActionPreference
            if ($PSBoundParameters["ErrorAction"])
            {
                $errorAction = $PSBoundParameters["ErrorAction"]
            }

            $device = [LogicMonApiDevice]::New($DeviceName, $DisplayName, $PreferredCollectorId, $HostGroupId)

            Write-Verbose "Create new device: $DeviceName in $Company's LogicMonitor."
            $device.Create($AccessKey, $AccessId, $Company, $errorAction)
        }
    }
    end
    {
    }
}