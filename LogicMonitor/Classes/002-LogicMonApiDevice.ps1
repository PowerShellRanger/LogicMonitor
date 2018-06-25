class LogicMonDevice
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

    LogicMonDevice ([string]$name, [string]$displayName, [int]$preferredCollectorId, [int[]]$hostGroupIds)
    {
        $this.Name = $name
        $this.DisplayName = $displayName
        $this.PreferredCollectorId = $preferredCollectorId
        $this.HostGroupIds = $hostGroupIds
    }

    static [LogicMonDevice[]] GetDeviceByName([string[]]$deviceName, [string]$accessKey, [string]$accessId, [string]$company)
    {        
        $devices = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        foreach ($name in $deviceName)
        {
            $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices?filter=displayName~$name"

            $splatGetDeviceByName = @{
                Headers = [LogicMonApiHeader]::New($accessKey, $accessId, 'GET').Header
                Method  = 'GET'
                Uri     = $uri
            }
            Write-Verbose "Invoke Rest Method to: $uri"
            $response = Invoke-RestMethod @splatGetDeviceByName

            $data = $response.data.items

            $device = [LogicMonDevice]::New($data.name, $data.displayName, $data.preferredCollectorId, $data.hostGroupIds)
            
            $device.Id = $data.id
            $device.DeviceType = $data.deviceType
            $device.CurrentCollectorId = $data.currentCollectorId
            $device.SystemProperties = $data.systemProperties

            [void]$devices.Add($device)
        }
        return $devices
    }

    static [LogicMonDevice[]] GetDeviceById([int[]]$deviceId, [string]$accessKey, [string]$accessId, [string]$company)
    {        
        $devices = New-Object 'System.Collections.Generic.List[PSCustomObject]'
        foreach ($id in $deviceId)
        {
            $uri = "https://$company.logicmonitor.com/santaba/rest/device/devices/$id"
            $httpVerb = 'GET'

            $splatGetDeviceById = @{
                Headers = [LogicMonApiHeader]::New($id, $accessKey, $accessId, $httpVerb).Header
                Method  = $httpVerb
                Uri     = $uri
            }
            Write-Verbose "Invoke Rest Method to: $uri"
            $response = Invoke-RestMethod @splatGetDeviceById

            $data = $response.data

            $device = [LogicMonDevice]::New($data.name, $data.displayName, $data.preferredCollectorId, $data.hostGroupIds)
            
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

        $splatCreateDevice = @{
            Headers     = [LogicMonApiHeader]::New($body, $accessKey, $accessId, $httpVerb).Header                        
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