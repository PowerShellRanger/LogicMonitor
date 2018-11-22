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
        # Add hours to epoch
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [int]$AddHours,

        # Add minutes to epoch
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [int]$AddMinutes,

        # Add seconds to epoch
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [int]$AddSeconds
    )
    begin
    {
    }
    process
    {
        $splatNewTimeSpan = @{
            Start = Get-Date -Date "1/1/1970"
            End   = (Get-Date).ToUniversalTime()
        }

        if ($PSBoundParameters.ContainsKey('AddHours'))
        {
            $splatNewTimeSpan['End'] = (Get-Date).ToUniversalTime().AddHours($AddHours)
        }

        if ($PSBoundParameters.ContainsKey('AddMinutes'))
        {
            $splatNewTimeSpan['End'] = (Get-Date).ToUniversalTime().AddMinutes($AddMinutes)
        }

        if ($PSBoundParameters.ContainsKey('AddSeconds'))
        {
            $splatNewTimeSpan['End'] = (Get-Date).ToUniversalTime().AddSeconds($AddSeconds)

        }

        [Math]::Round((New-TimeSpan @splatNewTimeSpan).TotalSeconds)

    }
    end
    {
    }
}

