$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$rubyRoot = 'D:\Program\acad-homepage-build-env\ruby'
$rubyCommand = Join-Path $rubyRoot 'bin\ridk.cmd'

if (-not (Test-Path -LiteralPath $rubyCommand)) {
    throw "Ruby build environment not found: $rubyRoot"
}

$mapping = subst R: 2>$null
if (-not $mapping) {
    subst R: $projectRoot | Out-Null
} elseif (-not (Test-Path -LiteralPath 'R:\_config.yml')) {
    throw "Drive R: is already mapped to another directory."
}

Push-Location 'R:\'
try {
    $env:GEMRC = Join-Path (Split-Path -Parent $rubyRoot) 'gemrc'
    & $rubyCommand exec bundle exec jekyll serve --livereload
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}
