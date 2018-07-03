class LogicMonApiDevice
{
    # Device Id
    [int]$Id

    # Device Name
    [string]$Name

    # Device Display Name
    [string]$DisplayName

    # Device Type
    [int]$DeviceType

    # Current Collector Id
    [int]$CurrentCollectorId

    # Preferred Collector Id
    [int]$PreferredCollectorId

    # Host Group Ids
    [int[]]$HostGroupIds

    # Device System Properties
    [psobject]$SystemProperties

    LogicMonApiDevice ([string]$name, [string]$displayName, [int]$preferredCollectorId, [int[]]$hostGroupIds)
    {
        $this.Name = $name
        $this.DisplayName = $displayName
        $this.PreferredCollectorId = $preferredCollectorId
        $this.HostGroupIds = $hostGroupIds
    }

    static [LogicMonApiDevice[]] GetDeviceByName([string[]]$deviceName, [string]$accessKey, [string]$accessId, [string]$company)
    {        
        $devices = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        foreach ($name in $deviceName)
        {
            $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices?filter=displayName~$name"
            $httpVerb = 'GET'
            $headers = (New-LogicMonApiHeader -AccessKey $accessKey -AccessId $accessId -Verb $httpVerb).Header

            $splatGetDeviceByName = @{
                Headers = $headers
                Method  = $httpVerb
                Uri     = $uri
            }
            Write-Verbose "Invoke Rest Method to: $uri"
            $response = Invoke-RestMethod @splatGetDeviceByName

            $data = $response.data.items

            $device = [LogicMonApiDevice]::New($data.name, $data.displayName, $data.preferredCollectorId, $data.hostGroupIds)
            
            $device.Id = $data.id
            $device.DeviceType = $data.deviceType
            $device.CurrentCollectorId = $data.currentCollectorId
            $device.SystemProperties = $data.systemProperties

            [void]$devices.Add($device)
        }
        return $devices
    }

    static [LogicMonApiDevice[]] GetDeviceById([int[]]$deviceId, [string]$accessKey, [string]$accessId, [string]$company)
    {        
        $devices = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        foreach ($id in $deviceId)
        {
            $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices/$id"
            $httpVerb = 'GET'
            $headers = (New-LogicMonApiHeader -AccessKey $accessKey -AccessId $accessId -Verb $httpVerb -DeviceId $id).Header

            $splatGetDeviceById = @{
                Headers = $headers
                Method  = $httpVerb
                Uri     = $uri
            }
            Write-Verbose "Invoke Rest Method to: $uri"
            $response = Invoke-RestMethod @splatGetDeviceById

            $data = $response.data

            $device = [LogicMonApiDevice]::New($data.name, $data.displayName, $data.preferredCollectorId, $data.hostGroupIds)
            
            $device.Id = $data.id
            $device.DeviceType = $data.deviceType
            $device.CurrentCollectorId = $data.currentCollectorId
            $device.SystemProperties = $data.systemProperties

            [void]$devices.Add($device)
        }
        return $devices
    }

    [void] Create([string]$accessKey, [string]$accessId, [string]$company)
    {
        $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices"
        $httpVerb = 'POST'
        $body = @{
            name                 = $this.Name
            displayName          = $this.DisplayName
            preferredCollectorId = $this.PreferredCollectorId
            hostGroupIds         = $this.HostGroupIds
        }
        $headers = (New-LogicMonApiHeader -AccessKey $accessKey -AccessId $accessId -Verb $httpVerb -Data $body).Header

        $splatCreateDevice = @{
            Headers     = $headers
            Method      = $httpVerb
            ContentType = 'application/json'
            Uri         = $uri
            Body        = ($body | ConvertTo-Json)
            ErrorAction = 'Stop'
        }
        Write-Verbose "Invoke Rest Method to: $uri"
        [void](Invoke-RestMethod @splatCreateDevice)
    }
}