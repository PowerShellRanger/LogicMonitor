function New-EpochTimeSpan
{
    <#
    .Synopsis
       
    .DESCRIPTION
       
    .EXAMPLE
       
    .EXAMPLE
       
    #>
    [CmdletBinding()]
    param
    (        
    )
    begin
    {                        
    }
    process
    {        
        [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)
    }
    end
    {
    }
}

