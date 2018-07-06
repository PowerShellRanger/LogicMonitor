function Get-LogicMonDevice
{
    <#
    .Synopsis
        Get a device from LogicMonitor.
    .DESCRIPTION
        Use this function to get devices from LogicMonitor.
    .EXAMPLE
        Get-LogicMonDevice -DeviceName 'foo' -AccessKey 'AccessKey -AccessId 'AccessId -Company 'someCompany' -Verbose

        Description
        -----------
        Get a device from LogicMonitor by name. 
        Access Key and Id come from LogicMonitor's portal. 
    .EXAMPLE
        Get-LogicMonDevice -DeviceId 1234 -AccessKey 'AccessKey -AccessId 'AccessId -Company 'someCompany' -Verbose

        Description
        -----------
        Get a device from LogicMonitor by Id. 
        Access Key and Id come fromLogicMonitor's portal. 
    #>
    [OutputType(
        [LogicMonApiDevice],
        [LogicMonApiDevice[]]
    )]
    [CmdletBinding(
        DefaultParameterSetName = 'GetDeviceByName'
    )]
    param
    (
        # Name of device
        [Parameter(
            Mandatory,
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'GetDeviceByName'
        )]
        [string[]]$DeviceName,

        # LogicMon Id of device
        [Parameter(            
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'GetDeviceById'
        )]
        [int[]]$DeviceId,

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
        if ($PSBoundParameters['DeviceName'])
        {
            foreach ($server in $DeviceName)  
            {
                Write-Verbose "Get Device by Name: $server."
                [LogicMonApiDevice]::GetDeviceByName($server, $AccessKey, $AccessId, $Company)
            }
        }

        if ($PSBoundParameters['DeviceId'])
        {
            foreach ($id in $DeviceId)
            {                    
                Write-Verbose "Get Device by Id: $id."
                [LogicMonApiDevice]::GetDeviceById($id, $AccessKey, $AccessId, $Company)
            }
        }
    }
    end
    {
    }
}
