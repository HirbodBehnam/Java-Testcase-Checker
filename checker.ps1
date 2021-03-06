# Compile
mkdir ./build > $null
javac -d ./build -sourcepath ./src ./src/*.java
# Now run each test
$FileCounter = 1
while ($true) {
    $InputPath = -join("./in/in", $FileCounter, ".txt")
    if (!(Test-Path $InputPath)) {
        break
    }
    Write-Host "Checking in$FileCounter.txt..."
    # Run the code and get the result
    $OutputPath = -join("./out/out", $FileCounter, ".txt")
    $OutputData = Get-Content $InputPath | java -classpath ./build Main
    $DiffData = Compare-Object ($OutputData) (Get-Content $OutputPath) | Out-String
    if (!([String]::IsNullOrWhiteSpace($DiffData))) {
        $OutputDiffPath = -join("./out-diff/out", $FileCounter, ".txt")
        $OutputData | Out-File $OutputDiffPath
        Write-Host $DiffData
    }
    $FileCounter++
}
# Cleanup
Remove-Item -Force -Recurse ./build