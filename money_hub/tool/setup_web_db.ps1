# Downloads the two files Drift needs to save data in the browser:
#   web/sqlite3.wasm     - SQLite compiled to WebAssembly
#   web/drift_worker.js  - background worker that runs the database
# The versions must match the drift and sqlite3 packages in pubspec.lock,
# so run this again whenever you upgrade those packages.
#
# Run from the project folder:
#   powershell -ExecutionPolicy Bypass -File tool\setup_web_db.ps1

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # much faster downloads in Windows PowerShell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$root = Split-Path -Parent $PSScriptRoot
$lockPath = Join-Path $root 'pubspec.lock'
if (-not (Test-Path $lockPath)) { throw "pubspec.lock not found. Run 'flutter pub get' first." }
$lock = Get-Content $lockPath -Raw

function Get-LockVersion([string]$name) {
  $pattern = "(?m)^  ${name}:\s*\r?\n(?:    .*\r?\n)*?    version: ""([^""]+)"""
  $m = [regex]::Match($lock, $pattern)
  if (-not $m.Success) { throw "Could not find '$name' in pubspec.lock. Run 'flutter pub get' first." }
  return $m.Groups[1].Value
}

$drift  = Get-LockVersion 'drift'
$sqlite = Get-LockVersion 'sqlite3'
Write-Host "Found drift $drift and sqlite3 $sqlite in pubspec.lock"

$web = Join-Path $root 'web'
New-Item -ItemType Directory -Force -Path $web | Out-Null

$files = @(
  @{ Name = 'sqlite3.wasm';    Url = "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$sqlite/sqlite3.wasm" },
  @{ Name = 'drift_worker.js'; Url = "https://github.com/simolus3/drift/releases/download/drift-$drift/drift_worker.js" }
)

foreach ($f in $files) {
  $dest = Join-Path $web $f.Name
  Write-Host "Downloading $($f.Name)..."
  try {
    Invoke-WebRequest -Uri $f.Url -OutFile $dest -UseBasicParsing
  } catch {
    throw "Download failed: $($f.Url)`n$($_.Exception.Message)"
  }
  $kb = [math]::Round((Get-Item $dest).Length / 1KB)
  Write-Host "  saved web\$($f.Name) ($kb KB)"
}

Write-Host ""
Write-Host "Done. Restart 'flutter run' so the web build picks up the files."
