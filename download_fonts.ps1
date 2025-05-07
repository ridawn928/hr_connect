$fonts = @(
    @{
        URL = "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Regular.ttf"
        OutFile = "assets/fonts/Roboto-Regular.ttf"
    },
    @{
        URL = "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Medium.ttf"
        OutFile = "assets/fonts/Roboto-Medium.ttf"
    },
    @{
        URL = "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Bold.ttf"
        OutFile = "assets/fonts/Roboto-Bold.ttf"
    }
)

foreach ($font in $fonts) {
    Write-Host "Downloading $($font.URL) to $($font.OutFile)"
    Invoke-WebRequest -Uri $font.URL -OutFile $font.OutFile
    if (Test-Path $font.OutFile) {
        Write-Host "Successfully downloaded $($font.OutFile)"
    } else {
        Write-Host "Failed to download $($font.OutFile)"
    }
}

Write-Host "All done!" 