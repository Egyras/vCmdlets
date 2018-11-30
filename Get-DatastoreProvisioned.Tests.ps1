﻿Describe 'Get-DatastoreProvisioned' -Tag unit {
    ### ARRANGE
    
    # Dot source the function
    . $PSScriptRoot\Get-DatastoreProvisioned.ps1

    ### ACT

    # Connect to the vcsim Docker container running locally
    Connect-VIServer -Server localhost -Port 443 -User u -Password p

    # Capture the datastore for further interaction
    $ds0 = Get-Datastore -Name LocalDS_0
    $ds1 = Get-Datastore -Name LocalDS_1

    $Pipe1 = $ds0 | Get-DatastoreProvisioned
    $Pipe2 = $ds0, $ds1 | Get-DatastoreProvisioned

    ### ASSERT
    
    It 'Receives expected ds0 values from vcsim' {
        # vcsim container defaults
        $ds0.CapacityMB  | Should -Be 58
        $ds0.FreeSpaceMB | Should -Be 53
        $ds0.ExtensionData.Summary.Capacity    | Should -Be 61664044
        $ds0.ExtensionData.Summary.FreeSpace   | Should -Be 56188984
        $ds0.ExtensionData.Summary.Uncommitted | Should -BeNullOrEmpty
    }

    It 'Receives expected ds1 values from vcsim' {
        # Second datastore will have the same values. Just check one
        $ds1.CapacityMB | Should -Be 58
    }

    It 'Correctly calculates values' {
        $Pipe1.FreeSpaceGB    | Should -Be .05
        $Pipe1.CapacityGB     | Should -Be .06
        $Pipe1.ProvisionedGB  | Should -Be .01
        $Pipe1.UsedPct        | Should -Be 8.62
        $Pipe1.ProvisionedPct | Should -Be 9
    }

    It 'Processes multiple objects via the pipeline' {
        $Pipe2.Count | Should -Be 2
    }
}
