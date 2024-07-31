# GokuPower: A script to find keys containing a specified search term within the config map of the spec object.

# find keys with a case-insensitive match
function Find-Keys {
    param (
        [string]$searchKey,
        [hashtable]$spec,
        [hashtable]$foundKeys = @{}
    )

    foreach ($key in $spec.Keys) {
        $value = $spec[$key]
        if ($key.ToLower().Contains($searchKey.ToLower())) {
            $foundKeys[$key] = $value
        }
        if ($value -is [hashtable]) {
            Find-Keys -searchKey $searchKey -spec $value -foundKeys $foundKeys
        } elseif ($value -is [array]) {
            foreach ($item in $value) {
                if ($item -is [hashtable]) {
                    Find-Keys -searchKey $searchKey -spec $item -foundKeys $foundKeys
                }
            }
        }
    }
    return $foundKeys
}

# Example of the map input (Hashtable)
$spec

# Search for keys containing 'hostname'
$result = Find-Keys -searchKey "hostname" -spec $spec
$matches = $result | ConvertTo-Json -Depth 10

# Print the spec
Write-Output "========================= CONFIG SPEC ========================="
Write-Output "`t$($spec | ConvertTo-Json -Depth 10)"

try {
    # Print the matches
    Write-Output "========================= SPEC MATCHES ========================="
    Write-Output "`t$matches"
} catch {
    Write-Output "Key not found in spec"
    Write-Output "$($_.Exception.Message)"
}

# Example of updating the hostName via the spec
# $hostNameOverride = "ueqbal"
# $spec.hostName = $hostNameOverride
