<#
Copyright (c) 2018-2020 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]
    $Server,

    [Parameter(Mandatory = $true)]
    [string]
    $User,

    [Parameter(Mandatory = $true)]
    [string]
    $Password
)

$Password = $Password | ConvertTo-SecureString -AsPlainText -Force
$script:vCenterCredential = New-Object System.Management.Automation.PSCredential($User, $Password)

$script:loggingLevel = 'Warning'
$script:eventMaxAgeEnabled = $false
$script:eventMaxAge = 40
$script:taskMaxAgeEnabled = $false
$script:taskMaxAge = 40

$script:configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}

$moduleFolderPath = (Get-Module VMware.vSphereDSC -ListAvailable).ModuleBase
$integrationTestsFolderPath = Join-Path (Join-Path $moduleFolderPath 'Tests') 'Integration'

Configuration vCenterSettings_WithLoggingLevel_Config {
    Import-DscResource -ModuleName VMware.vSphereDSC

    Node localhost {
        vCenterSettings vCenterSettings {
            Server = $Server
            Credential = $script:vCenterCredential
            LoggingLevel = $script:loggingLevel
        }
    }
}

Configuration vCenterSettings_WithEventMaxAge_Config {
    Import-DscResource -ModuleName VMware.vSphereDSC

    Node localhost {
        vCenterSettings vCenterSettings {
            Server = $Server
            Credential = $script:vCenterCredential
            EventMaxAgeEnabled = $script:eventMaxAgeEnabled
            EventMaxAge = $script:eventMaxAge
        }
    }
}

Configuration vCenterSettings_WithTaskMaxAge_Config {
    Import-DscResource -ModuleName VMware.vSphereDSC

    Node localhost {
        vCenterSettings vCenterSettings {
            Server = $Server
            Credential = $script:vCenterCredential
            TaskMaxAgeEnabled = $script:taskMaxAgeEnabled
            TaskMaxAge = $script:taskMaxAge
        }
    }
}

Configuration vCenterSettings_WithMotdAndIssue_Config {
    Import-DscResource -ModuleName VMware.vSphereDSC

    Node localhost {
        vCenterSettings vCenterSettings {
            Server = $Server
            Credential = $script:vCenterCredential
            Motd = $script:motd
            Issue = $script:issue
        }
    }
}

vCenterSettings_WithLoggingLevel_Config -OutputPath "$integrationTestsFolderPath\vCenterSettings_WithLoggingLevel_Config" -ConfigurationData $script:configurationData
vCenterSettings_WithEventMaxAge_Config -OutputPath "$integrationTestsFolderPath\vCenterSettings_WithEventMaxAge_Config" -ConfigurationData $script:configurationData
vCenterSettings_WithTaskMaxAge_Config -OutputPath "$integrationTestsFolderPath\vCenterSettings_WithTaskMaxAge_Config" -ConfigurationData $script:configurationData
vCenterSettings_WithMotdAndIssue_Config -OutputPath "$integrationTestsFolderPath\vCenterSettings_WithMotdAndIssue_Config" -ConfigurationData $script:configurationData