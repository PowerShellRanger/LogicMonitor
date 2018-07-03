
class LogicMonApiHeader
{        
    # Access Key from LogicMon for your user account
    [System.Collections.Generic.Dictionary[[String],[String]]]$Header    

    LogicMonApiHeader ([string]$accessKey, [string]$accessId, [RestMethod]$verb)
    {
        Write-Verbose "Defining account info for LogicMon."        
        $httpVerb = $verb.ToUpper()
        $data = ''

        Write-Verbose "Getting current time in milliseconds."
        $epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)
        $requestVars = "$httpVerb$epoch$data/device/devices"
        
        Write-Verbose "Constructing signature"
        $hmac = New-Object System.Security.Cryptography.HMACSHA256
        $hmac.Key = [Text.Encoding]::UTF8.GetBytes($accessKey)
        $signatureBytes = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($requestVars))
        $signatureHex = [System.BitConverter]::ToString($signatureBytes) -replace '-'
        $signature = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($signatureHex.ToLower()))
        
        Write-Verbose "Constructing header"
        $auth = 'LMv1 ' + $accessId + ':' + $signature + ':' + $epoch
        $_header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $_header.Add("Authorization", $auth)
        $_header.Add("Content-Type", 'application/json')
        
        $this.Header = $_header
    }

    LogicMonApiHeader ([int]$id, [string]$accessKey, [string]$accessId, [RestMethod]$verb)
    {
        Write-Verbose "Defining account info for LogicMon."        
        $httpVerb = $verb.ToUpper()
        $data = ''

        Write-Verbose "Getting current time in milliseconds."
        $epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)
        $requestVars = "$($httpVerb)$($epoch)$($data)/device/devices/$($id)"
        
        Write-Verbose "Constructing signature"
        $hmac = New-Object System.Security.Cryptography.HMACSHA256
        $hmac.Key = [Text.Encoding]::UTF8.GetBytes($accessKey)
        $signatureBytes = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($requestVars))
        $signatureHex = [System.BitConverter]::ToString($signatureBytes) -replace '-'
        $signature = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($signatureHex.ToLower()))
        
        Write-Verbose "Constructing header"
        $auth = 'LMv1 ' + $accessId + ':' + $signature + ':' + $epoch
        $_header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $_header.Add("Authorization", $auth)
        $_header.Add("Content-Type", 'application/json')
        
        $this.Header = $_header
    }

    LogicMonApiHeader ([hashtable]$data, [string]$accessKey, [string]$accessId, [RestMethod]$verb)
    {
        # TODO: This is not working yet. Need to add data portion
        Write-Verbose "Defining account info for LogicMon."        
        $httpVerb = $verb.ToUpper()        

        Write-Verbose "Getting current time in milliseconds."
        $epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)
        $requestVars = "$($httpVerb)$($epoch)$($data)/device/devices/"
        
        Write-Verbose "Constructing signature"
        $hmac = New-Object System.Security.Cryptography.HMACSHA256
        $hmac.Key = [Text.Encoding]::UTF8.GetBytes($accessKey)
        $signatureBytes = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($requestVars))
        $signatureHex = [System.BitConverter]::ToString($signatureBytes) -replace '-'
        $signature = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($signatureHex.ToLower()))
        
        Write-Verbose "Constructing header"
        $auth = 'LMv1 ' + $accessId + ':' + $signature + ':' + $epoch
        $_header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $_header.Add("Authorization", $auth)
        $_header.Add("Content-Type", 'application/json')
        
        $this.Header = $_header
    }
}

class RestMethod
{
    # HTTP Verb (Get, Post, Put, Delete)    
    [ValidateSet("Get", "Post", "Put", "Delete")]
    [string]$Verb

    RestMethod ([string]$verb)
    {
        $this.Verb = $verb
    }

    [string] ToUpper()
    {
        return $this.Verb.ToUpper()
    }
}