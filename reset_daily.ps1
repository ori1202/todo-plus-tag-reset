<#
.SYNOPSIS
Resets @daily tasks in a Todo+ file and logs completed/cancelled tasks.

.DESCRIPTION
This script reads the specified .todo file, looks for sections marked with @daily,
logs any modified tasks (done, cancelled, or started) to a log file, and then
resets those tasks to an empty state (☐) while removing time tracking tags.
#>

param (
    [string]$TodoFilePath = "c:\Users\ori88\OneDrive\Desktop\New Text Document.todo",
    [string]$LogFilePath = "c:\Users\ori88\OneDrive\Desktop\daily_todo_log.txt"
)

# Use Unicode characters safely without relying on file encoding
$check = [char]0x2714
$cross = [char]0x2718
$box   = [char]0x2610

# Read all lines
$lines = [System.IO.File]::ReadAllLines($TodoFilePath)
$newLines = @()
$logLines = New-Object System.Collections.Generic.List[string]

$inDailySection = $false
$dateStr = (Get-Date).ToString("yyyy-MM-dd")
$hasChangesToLog = $false
$currentSectionHeader = $null

foreach ($line in $lines) {
    # Check if line is a section header (ends with colon)
    if ($line -match ":\s*$") {
        if ($line -match "@daily") {
            $inDailySection = $true
            $currentSectionHeader = $line
        } else {
            $inDailySection = $false
        }
        $newLines += $line
        continue
    }

    if ($inDailySection) {
        # Check if line is a task using unicode characters
        if ($line -match "^\s*($check|$cross|$box)") {
            # Consider task modified if it's done, cancelled, or has time tags
            $isModified = ($line -match "^\s*($check|$cross)") -or ($line -match "@started") -or ($line -match "@done") -or ($line -match "@cancelled")
            
            if ($isModified) {
                if (-not $hasChangesToLog) {
                    $logLines.Add("=== Log for $dateStr ===")
                    $hasChangesToLog = $true
                }
                if ($null -ne $currentSectionHeader) {
                    $logLines.Add($currentSectionHeader)
                    $currentSectionHeader = $null
                }
                $logLines.Add($line)
            }

            # Reset the checkmarks
            $newLine = $line -replace "$check", "$box"
            $newLine = $newLine -replace "$cross", "$box"
            
            # Remove all the timekeeping tags (with or without parenthesis)
            $newLine = $newLine -replace "\s*@started(\([^)]*\))?", ""
            $newLine = $newLine -replace "\s*@done(\([^)]*\))?", ""
            $newLine = $newLine -replace "\s*@lasted(\([^)]*\))?", ""
            $newLine = $newLine -replace "\s*@cancelled(\([^)]*\))?", ""
            $newLine = $newLine -replace "\s*@wasted(\([^)]*\))?", ""
            
            $newLines += $newLine
        } else {
            $newLines += $line
        }
    } else {
        $newLines += $line
    }
}

# Write to log file if there were any changes (appends to the end)
if ($hasChangesToLog) {
    $logLines.Add("") # Empty line for spacing
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::AppendAllLines($LogFilePath, $logLines, $utf8NoBom)
    Write-Host "Logged daily progress to $LogFilePath"
} else {
    Write-Host "No completed/cancelled daily tasks found to log."
}

# Overwrite the original file with reset tasks (saves as UTF-8 without BOM)
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines($TodoFilePath, $newLines, $utf8NoBom)
Write-Host "Successfully reset daily tasks in $TodoFilePath"
