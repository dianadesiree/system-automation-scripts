<#
.SYNOPSIS
    Setup script for System Automation Scripts
.DESCRIPTION
    Configures the environment for running automation scripts
#>

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SYSTEM AUTOMATION SCRIPTS - SETUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python installation
Write-Host "Checking Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($pythonVersion -match "Python 3\.[8-9]\.\d+|Python 3\.1\d\.\d+") {
    Write-Host "  ✅ Python $($Matches[0]) found" -ForegroundColor Green
} else {
    Write-Host "  ❌ Python 3.8+ not found. Please install from python.org" -ForegroundColor Red
}

# Install Python dependencies
Write-Host ""
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
if (Test-Path "python\requirements.txt") {
    pip install -r python\requirements.txt
    Write-Host "  ✅ Python dependencies installed" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  python\requirements.txt not found" -ForegroundColor Yellow
}

# Set PowerShell execution policy
Write-Host ""
Write-Host "Configuring PowerShell..." -ForegroundColor Yellow
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -eq "Restricted") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "  ✅ Execution policy updated to RemoteSigned" -ForegroundColor Green
} else {
    Write-Host "  ✅ Execution policy already set: $currentPolicy" -ForegroundColor Green
}

# Create necessary directories
Write-Host ""
Write-Host "Creating directories..." -ForegroundColor Yellow
$directories = @("logs", "temp", "docs\examples", "test_output")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Created: $dir" -ForegroundColor Green
    } else {
        Write-Host "  📁 Already exists: $dir" -ForegroundColor Cyan
    }
}

# Check Git installation
Write-Host ""
Write-Host "Checking Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>&1
if ($gitVersion -match "git version") {
    Write-Host "  ✅ Git found: $($gitVersion)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Git not found. Install from git-scm.com" -ForegroundColor Yellow
}

# Create test files for file organizer
Write-Host ""
Write-Host "Creating test files for demonstration..." -ForegroundColor Yellow
$testFolders = @("test_files\images", "test_files\documents", "test_files\code")
foreach ($folder in $testFolders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Create sample test files
"Sample image content" | Out-File -FilePath "test_files\test.jpg" -Encoding utf8
"Sample document content" | Out-File -FilePath "test_files\test.pdf" -Encoding utf8
"Sample code content" | Out-File -FilePath "test_files\script.py" -Encoding utf8
"Sample text content" | Out-File -FilePath "test_files\notes.txt" -Encoding utf8

Write-Host "  ✅ Test files created in 'test_files' folder" -ForegroundColor Green

# Make bash script executable (if Git Bash is available)
Write-Host ""
Write-Host "Configuring bash scripts..." -ForegroundColor Yellow
if (Get-Command "git" -ErrorAction SilentlyContinue) {
    # Try to make bash script executable using Git Bash
    & "C:\Program Files\Git\bin\bash.exe" -c "chmod +x bash/git_automation.sh 2>/dev/null || true"
    Write-Host "  ✅ Bash script permissions set" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Test Python script: python python/file_organizer.py test_files"
Write-Host "  2. Test PowerShell script: .\powershell\backup_script.ps1 -SourcePath test_files -DestinationPath test_output -Compress"
Write-Host "  3. Test Bash script (Git Bash): bash bash/git_automation.sh ."
Write-Host "  4. Run full test suite: .\test_all.ps1"
Write-Host ""
Write-Host "📊 For more detailed testing, create the test_all.ps1 script" -ForegroundColor Cyan
