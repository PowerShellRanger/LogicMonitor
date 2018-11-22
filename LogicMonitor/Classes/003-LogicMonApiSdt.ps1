class LogicMonApiSdt
{

    static [string] SetWebsiteSdt([int]$serviceId, [string]$comment, [int]$duration,
        [string]$accessKey, [string]$accessId, [string]$company, [string]$errorAction)
    {
        $httpVerb = 'POST'
        $resourcePath = 'sdt/sdts'
        $data = @{
            sdtType       = 1
            type          = 'ServiceSDT'
            serviceId     = $serviceId
            comment       = $comment
            startDateTime = New-EpochTimeSpan
            endDateTime   = New-EpochTimeSpan -AddMinutes $duration
        }
        $uri = "https://$company.logicmonitor.com/santaba/rest/$resourcePath"
        $body = $data | ConvertTo-Json
        $requestData = "$body/$resourcePath"
        $splatNewLogicMonHeader = @{
            AccessKey = $accessKey
            AccessId  = $accessId
            Verb      = $httpVerb
            Data      = $requestData
        }
        $headers = (New-LogicMonHeader @splatNewLogicMonHeader).Header

        $splatSetDeviceSdt = @{
            Headers     = $headers
            Method      = $httpVerb
            Uri         = $uri
            Body        = $body
            ErrorAction = $errorAction
        }
        Write-Verbose "Invoke Rest Method to: $uri"
        return Invoke-RestMethod @splatSetDeviceSdt
    }
    <#
    static [string] SetWebsiteGroupSdt([string]$serviceGroupName, [int]$serviceGroupId,
        [string]$accessKey, [string]$accessId, [string]$company)
    {
        $type = 'ServiceGroupSDT'
    }

    static [string] SetDeviceSdt([string]$deviceDisplayName, [int]$deviceId,
        [string]$accessKey, [string]$accessId, [string]$company)
    {
        $type = 'DeviceSDT'
    }

    static [string] SetDeviceGroupSdt([string]$deviceGroupFullPath, [int]$deviceGroupId,
        [string]$accessKey, [string]$accessId, [string]$company)
    {
        $type = 'DeviceGroupSDT'
    }
    #>
}
