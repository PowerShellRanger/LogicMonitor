#active discovery 
Import-Module -Name F5BigIP -ErrorAction Stop

$hostname = '##HOSTNAME##'
$f5User = '##f5.user##'
$f5Pass = '##f5.pass##'

# build a credential object
$securePass = ConvertTo-SecureString -String $f5Pass -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential ($f5User, $securePass)

$token = New-F5RestApiToken -F5Name $hostname -Credential $credential -Confirm:$false -ErrorAction Stop
$sslCerts = Get-F5SslCertificate -F5Name $hostname -Token $token.Token -GetAllCertificates

if ($sslCerts)
{
    foreach ($sslCert in $sslCerts)
    {
        "$($sslCert.Name)##$($sslCert.Name)"
    }
}


#collector attributes
Import-Module -Name F5BigIP -ErrorAction Stop

$hostname = '##HOSTNAME##'
$f5User = '##f5.user##'
$f5Pass = '##f5.pass##'
$certificateName = '##WILDVALUE##'
$date = Get-Date

# build a credential object
$securePass = ConvertTo-SecureString -String $f5Pass -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential ($f5User, $securePass)

$token = New-F5RestApiToken -F5Name $hostname -Credential $credential -Confirm:$false -ErrorAction Stop
$sslCert = Get-F5SslCertificate -F5Name $hostname -Token $token.Token -CertificateName $certificateName

$epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0)
$expirationDate = $epoch.AddSeconds($sslCert.expirationDate)

if ($sslCert)
{
    $timeSpan = New-TimeSpan -Start $date -End $expirationDate
    return @{Days = $timeSpan.Days}
}
else
{
    return "Failed to get certificate: $certificateName."
}

