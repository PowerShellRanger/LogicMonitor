#active discovery 
Import-Module -Name F5BigIP -ErrorAction Stop

Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$hostname = '##HOSTNAME##'
$f5User = '##f5.user##'
$f5Pass = '##f5.pass##'

# build a credential object
$securePass = ConvertTo-SecureString -String $f5Pass -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential ($f5User, $securePass)

$sslCerts = Get-F5SslCertificate -F5Name $hostname -Credential $credential -GetAllCertificates

if ($sslCerts)
{
    foreach ($sslCert in $sslCerts)
    {
        "$($sslCert.Name)##$($sslCert.Name)"
    }
}

#collector attributes
Import-Module -Name F5BigIP -ErrorAction Stop

Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$hostname = '##HOSTNAME##'
$f5User = '##f5.user##'
$f5Pass = '##f5.pass##'
$certificateName = '##WILDVALUE##'
$date = Get-Date

# build a credential object
$securePass = ConvertTo-SecureString -String $f5Pass -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential ($f5User, $securePass)

$sslCert = Get-F5SslCertificate -F5Name $hostname -Credential $credential -CertificateName $certificateName

$epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0)
$expirationDate = $epoch.AddSeconds($sslCert.expirationDate)

if ($sslCert)
{
    $timeSpan = New-TimeSpan -Start $date -End $expirationDate
    return $timeSpan.Days
}
else
{
    return "Failed to get certificate: $certificateName."
}

