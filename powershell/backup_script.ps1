<#
.SYNOPSIS
    Automated Backup Script
.DESCRIPTION
    Creates compressed backups of specified directories with rotation policy
.AUTHOR
    Diana Araujo
.EXAMPLE
    .\backup_script.ps1 -SourcePath "C:\ImportantFiles" -DestinationPath "D:\Backups"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    
    [Parameter(Mandatory=$true)]
    [string]$DestinationPath,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxBackups = 10,
    
    [Parameter(Mandatory=$false)]
    [switch]$Compress = $true
)

# Configuration
$DateString = Get-Date -Format "yyyy-MM-dd_HHmmss"
$BackupName = "backup_$DateString"
$LogFile = "$DestinationPath\backup_log.txt"

# Color function for console output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Logging function
function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "$Timestamp [$Type] $Message"
    
    # Console output with colors
    switch ($Type) {
        "ERROR" { Write-ColorOutput Red $LogMessage }
        "WARNING" { Write-ColorOutput Yellow $LogMessage }
        "SUCCESS" { Write-ColorOutput Green $LogMessage }
        default { Write-ColorOutput White $LogMessage }
    }
    
    # Write to log file
    Add-Content -Path $LogFile -Value $LogMessage
}

function Test-PathRequirements {
    # Check source path
    if (-not (Test-Path $SourcePath)) {
        Write-Log "Source path does not exist: $SourcePath" -Type "ERROR"
        return $false
    }
    
    # Check/create destination path
    if (-not (Test-Path $DestinationPath)) {
        Write-Log "Creating destination directory: $DestinationPath" -Type "WARNING"
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }
    
    return $true
}

function Create-Backup {
    Write-Log "Starting backup process..." -Type "INFO"
    Write-Log "Source: $SourcePath" -Type "INFO"
    Write-Log "Destination: $DestinationPath" -Type "INFO"
    
    if ($Compress) {
        # Create compressed backup
        $ZipPath = "$DestinationPath\$BackupName.zip"
        Write-Log "Creating compressed backup: $BackupName.zip" -Type "INFO"
        
        # Use Compress-Archive for compression
        Compress-Archive -Path $SourcePath -DestinationPath $ZipPath -Force
        
        if (Test-Path $ZipPath) {
            $FileSize = (Get-Item $ZipPath).Length / 1MB
            Write-Log "Backup created successfully: $BackupName.zip ($([math]::Round($FileSize,2)) MB)" -Type "SUCCESS"
            return $ZipPath
        }
    } else {
        # Create folder backup
        $BackupPath = "$DestinationPath\$BackupName"
        Write-Log "Creating folder backup: $BackupName" -Type "INFO"
        
        Copy-Item -Path $SourcePath -Destination $BackupPath -Recurse -Force
        
        if (Test-Path $BackupPath) {
            Write-Log "Backup created successfully: $BackupName" -Type "SUCCESS"
            return $BackupPath
        }
    }
    
    return $null
}

function Rotate-Backups {
    Write-Log "Checking backup rotation policy (Max: $MaxBackups)" -Type "INFO"
    
    # Get all backup files/folders
    $Backups = @()
    
    # Get zip files
    $Backups += Get-ChildItem -Path $DestinationPath -Filter "backup_*.zip" | 
        Select-Object @{Name="Path";Expression={$_.FullName}}, 
                     @{Name="Date";Expression={$_.CreationTime}},
                     @{Name="Type";Expression={"zip"}}
    
    # Get backup folders
    $Backups += Get-ChildItem -Path $DestinationPath -Directory | 
        Where-Object {$_.Name -like "backup_*"} | 
        Select-Object @{Name="Path";Expression={$_.FullName}}, 
                     @{Name="Date";Expression={$_.CreationTime}},
                     @{Name="Type";Expression={"folder"}}
    
    # Sort by creation date (oldest first)
    $Backups = $Backups | Sort-Object Date
    
    # Remove old backups if exceeding limit
    while ($Backups.Count -gt $MaxBackups) {
        $OldestBackup = $Backups[0]
        Write-Log "Removing old backup: $($OldestBackup.Path)" -Type "WARNING"
        
        if ($OldestBackup.Type -eq "zip") {
            Remove-Item -Path $OldestBackup.Path -Force
        } else {
            Remove-Item -Path $OldestBackup.Path -Recurse -Force
        }
        
        $Backups = $Backups[1..$Backups.Count]
    }
    
    Write-Log "Backup rotation complete. Current backups: $($Backups.Count)" -Type "SUCCESS"
}

# Main execution
try {
    Write-Host "`n" + "="*60 -ForegroundColor Cyan
    Write-Host "  SYSTEM BACKUP SCRIPT" -ForegroundColor Cyan
    Write-Host "="*60 -ForegroundColor Cyan
    
    if (Test-PathRequirements) {
        $BackupPath = Create-Backup
        
        if ($BackupPath) {
            Rotate-Backups
            Write-Host "`n" + "="*60 -ForegroundColor Green
            Write-Host "  BACKUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
            Write-Host "="*60 -ForegroundColor Green
        } else {
            throw "Backup creation failed"
        }
    }
} catch {
    Write-Log "Backup failed: $_" -Type "ERROR"
    Write-Host "`n" + "="*60 -ForegroundColor Red
    Write-Host "  BACKUP FAILED!" -ForegroundColor Red
    Write-Host "="*60 -ForegroundColor Red
    exit 1
}