
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Get-Module -Name $moduleName -All | Remove-Module -Force
Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

InModuleScope -ModuleName $moduleName {

  $sut = Split-Path $MyInvocation.MyCommand.ScriptBlock.File -Leaf
  $cmdletName = $sut.Split('.')[0]
  $cmdlet = Get-Command -Name $cmdletName

  Describe "Get-LogicMonDevice" {

    Context "Testing Parameters" {

      It "Should throw when mandatory parameters are not provided" {
        $cmdlet.Parameters.DeviceName.Attributes.Mandatory | should be $true
        $cmdlet.Parameters.AccessKey.Attributes.Mandatory | should be $true
        $cmdlet.Parameters.AccessId.Attributes.Mandatory | should be $true
        $cmdlet.Parameters.Company.Attributes.Mandatory | should be $true
      }

      It "Should not throw when non-mandatory parameters are not provided" {
        $cmdlet.Parameters.DeviceId.Attributes.Mandatory | should be $false
      }
    }
  }
}
