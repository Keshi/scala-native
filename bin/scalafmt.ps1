# Format Scala code using scalafmt.
#
# Usage: scalafmt [--test]
#
# no parameters: format files
#      "--test": test correctness

param (
    [ValidateSet("--test", "--install")] 
    [string]$testMode
)

$SCALAFMT_VERSION="0.6.8"
$SCALAFMT="$PSScriptRoot\.scalafmt-$SCALAFMT_VERSION.jar"
$SCALAFMTTEST="$PSScriptRoot\.scalafmt-CI-$SCALAFMT_VERSION.jar"
$COURSIER="$PSScriptRoot/coursier.ps1"

Try
{
    if ($testMode -eq "--install")
    {
        &$COURSIER bootstrap com.geirsson:scalafmt-cli_2.11:$SCALAFMT_VERSION --main org.scalafmt.cli.Cli -o $SCALAFMTTEST -f
        #$scalafmtExists = Test-Path $SCALAFMTTEST
        #if ($scalafmtExists -ne $True)
        #{
        #    throw [System.IO.FileNotFoundException] "$SCALAFMTTEST not found."
        #}
    }
    else
    {
        $ScalaFmtRun = ""
        if ($testMode -eq "--test") {
            &$COURSIER bootstrap com.geirsson:scalafmt-cli_2.11:$SCALAFMT_VERSION --main org.scalafmt.cli.Cli -o $SCALAFMTTEST -f
            $ScalaFmtRun = $SCALAFMTTEST
        }
        else {
            &$COURSIER bootstrap --standalone com.geirsson:scalafmt-cli_2.11:$SCALAFMT_VERSION -o $SCALAFMT -f --main org.scalafmt.cli.Cli
            $ScalaFmtRun = $SCALAFMT
        }

        $scalafmtExists = Test-Path $ScalaFmtRun
        if ($scalafmtExists -ne $True)
        {
            if ($testMode -eq "--test") {
                &$COURSIER bootstrap com.geirsson:scalafmt-cli_2.11:$SCALAFMT_VERSION --main org.scalafmt.cli.Cli -o $SCALAFMTTEST -f
            }
            else {
                &$COURSIER bootstrap --standalone com.geirsson:scalafmt-cli_2.11:$SCALAFMT_VERSION -o $SCALAFMT -f --main org.scalafmt.cli.Cli
            }
            $scalafmtExists = Test-Path $ScalaFmtRun
            if ($scalafmtExists -ne $True)
            {
                throw [System.IO.FileNotFoundException] "$ScalaFmtRun not found."
            }
        }

        $log = ""
        if ($testMode) {
            $log = &java -jar $ScalaFmtRun $testMode
        }
        else {
            $log = &java -jar $ScalaFmtRun
        }
        Write-Host $log
    }
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    Write-Host $ErrorMessage
    exit 1
}