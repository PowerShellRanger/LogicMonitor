function Get-LogicMonDevice
{
    <#
    .Synopsis
       Get a device from Logic Monitor.
    .DESCRIPTION
       Use this function to get devices from Logic Monitor.
    .EXAMPLE
       
    .EXAMPLE
       
    #>
    [CmdletBinding()]
    param
    (
        # Name of device
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$DeviceName,

        # Access Key from LogicMon for your user account
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$AccessKey,

        # Access ID from LogicMon for your user account
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$AccessId,

        # LogicMon Company Name
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Company
    )
    begin
    {
    }
    process
    {
        foreach ($server in $DeviceName)
        {                    
            Write-Verbose "Building URL for Invoke-RestMethod cmdlet."
            $url = "https://" + $Company + ".logicmonitor.com/santaba/rest" + "/device/devices?filter=displayName~$server"
            
            Write-Verbose "Building a new LogicMon header."
            $header = New-LogicMonHeader -AccessKey $AccessKey -AccessId $AccessId -Verb Get            
            
            try
            {
                Write-Verbose "Trying to get data from LogicMon's rest API."               
                $response = Invoke-RestMethod -Uri $url -Method Get -Header $header -ErrorAction Stop
            }
            catch
            {
                throw $_
            }            
            
            [PSCustomObject] @{
                Name      = $($response.data.items.name)
                DeviceId  = $($response.data.items.id)
                Company   = $Company
            }            
        }
    }
    end
    {
    }
}
