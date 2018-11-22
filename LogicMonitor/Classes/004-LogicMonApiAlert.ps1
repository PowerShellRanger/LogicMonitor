class LogicMonApiAlert
{
    static [PSCustomObject[]] GetAlertByFilter([string[]]$queryParams, [string]$accessKey, [string]$accessId, [string]$company)
    {
        #$alerts = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        $count = 1
        $addParameter = '?filter='

        foreach($queryParam in $queryParams)
        {
            if($queryParams.count -gt $count)
            {
                $addParameter = $addParameter + $queryParam + ","
            }
            else
            {
                $addParameter = $addParameter + $queryParam
            }
            $count++
        }

        $uri = "https://$company.logicmonitor.com/santaba/rest/alert/alerts" + $addParameter
        $httpVerb = 'GET'
        $requestData = '/alert/alerts'

        $splatNewLogicMonHeader = @{
            AccessKey = $accessKey
            AccessId  = $accessId
            Verb      = $httpVerb
            Data      = $requestData
        }
        $headers = (New-LogicMonHeader @splatNewLogicMonHeader).Header

        $splatGetAlertByFilter = @{
            Headers = $headers
            Method  = $httpVerb
            Uri     = $uri
        }
        Write-Verbose "Invoke Rest Method to: $uri"
        $response = Invoke-RestMethod @splatGetAlertByFilter

        $data = $response.data.items

        return $data #,$splatGetAlertByFilter
    }

    static [PSCustomObject[]] GetAlertsByDeviceId([string[]]$queryParams,[int]$deviceId, [string]$accessKey, [string]$accessId, [string]$company)
    {
        #$alerts = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        $count = 1
        if($queryParams)
        {
            $addParameter = '?filter='
            foreach($queryParam in $queryParams)
            {
                if($queryParams.count -gt $count)
                {
                    $addParameter = $addParameter + $queryParam + ","
                }
                else
                {
                    $addParameter = $addParameter + $queryParam
                }
                $count++
            }
        }
        else
        {
            $addParameter = $null
        }

        $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices/" + $deviceId + "/alerts" + $addParameter
        $httpVerb = 'GET'
        $requestData = '/device/devices/' + $deviceId + '/alerts'

        $splatNewLogicMonHeader = @{
            AccessKey = $accessKey
            AccessId  = $accessId
            Verb      = $httpVerb
            Data      = $requestData
        }
        $headers = (New-LogicMonHeader @splatNewLogicMonHeader).Header

        $splatGetDeviceAlertByFilter = @{
            Headers = $headers
            Method  = $httpVerb
            Uri     = $uri
        }
        Write-Verbose "Invoke Rest Method to: $uri"
        $response = Invoke-RestMethod @splatGetDeviceAlertByFilter

        $data = $response.data.items

        return $data
    }
}