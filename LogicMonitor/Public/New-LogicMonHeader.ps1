function New-LogicMonHeader
{
    <#
    .Synopsis
        New LogicMonitor Header 
    .DESCRIPTION
        Use this function to build a header to authenticate with LogicMonitor's Rest API
    .EXAMPLE
        New-LogicMonHeader -AccessKey 'AccessKey' -AccessId 'AccessId' -Verb Get -Verbose       

        Description
        -----------
        Build a header to authenticate with LogicMonitor's Rest Api. 
        Access Key and Id come from LogicMonitor's portal. 
    .EXAMPLE
       
    #>
    [OutputType(
        [LogicMonApiHeader]        
    )]
    [CmdletBinding()]
    param
    (
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
        
        # HTTP Verb (Get, Post, Put, Delete)
        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Put", "Delete")]
        [string]$Verb,

        # LogicMon Id of device
        [Parameter(            
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [int]$DeviceId,

        # LogicMon Data for Puts
        [Parameter(            
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName            
        )]
        [hashtable]$Data
    )
    begin
    {
    }
    process
    {                        
        if ($PSBoundParameters['Id'])
        {            
            Write-Verbose "Generating new header for ID: $id."                    
            return [LogicMonApiHeader]::New($id, $AccessKey, $AccessId, $Verb)
        }

        if ($PSBoundParameters['Data'])
        {   
            Write-Verbose "Generating new header with data injected."                                                 
            return [LogicMonApiHeader]::New($Data, $AccessKey, $AccessId, $Verb)            
        }

        Write-Verbose 'Generating new header'
        [LogicMonApiHeader]::New($AccessKey, $AccessId, $Verb)
    }
    end
    {
    }
}