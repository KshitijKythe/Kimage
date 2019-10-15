


Function Set-WallPaper($Image) {
<#
.SYNOPSIS
Applies a specified wallpaper to the current user's desktop
   
.PARAMETER Image
Provide the exact path to the image
 
.EXAMPLE
Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
 
#>
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
 
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
 
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
 
$fWinIni = $UpdateIniFile -bor $SendChangeEvent
 
$ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}



#Getting a random picture json response from unsplash API using my app's access key
clear
'starting'
$imagePath = 'C:\Users\kulshk\Desktop\TestFolder\unsplashImage.jpg'
$unsplashUrl = 'https://api.unsplash.com/photos/random/?client_id=c04297c0a0e35c2729ff49266c5fe091ce5e6278cc0a675ee893c29cdbd2b43b&auto=format'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$unsplashResponse = Invoke-WebRequest -Uri $unsplashUrl -Method GET
$obj = ConvertFrom-Json -InputObject $unsplashResponse
#$downloadPath =  $obj.links.download
$downloadPath = $obj.urls.raw+"fit=fill" #FIX WIDTH
#$downloadPath
# New-Item -Path $imagePath -ItemType File
# Set-Content $imagePath $obj.links.download
#$output = $imagePath
#Invoke-WebRequest -Uri $downloadPath -OutFile $imagePath
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($downloadPath, $imagePath)
'downloaded'
Set-WallPaper $imagePath
'wallpaper set'


