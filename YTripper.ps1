$WorkingDirectory = (Split-Path $MyInvocation.MyCommand.Path)
$ScriptDir = (Split-Path $MyInvocation.MyCommand.Path)

if ($PSVersionTable["Platform"].Equals("Unix")) {
    $aria2cThreads = '16'
    }else{    
    $aria2cThreads = '32'
}



if ($PSVersionTable["Platform"].Equals("Unix")) {
    $os = '/'
    }else{    
    $os = '\'
}


$inifile = "$($ScriptDir)$($os)config$($os)ripper.ini"

Function Out-IniFile {  
    <#  
    .Synopsis  
        Write hash content to INI file  
          
    .Description  
        Write hash content to INI file  
          
    .Notes  
        Author        : Oliver Lipkau <oliver@lipkau.net>  
        Blog        : http://oliver.lipkau.net/blog/  
        Source        : https://github.com/lipkau/PsIni 
                      http://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91 
        Version        : 1.0 - 2010/03/12 - Initial release  
                      1.1 - 2012/04/19 - Bugfix/Added example to help (Thx Ingmar Verheij)  
                      1.2 - 2014/12/11 - Improved handling for missing output file (Thx SLDR) 
          
        #Requires -Version 2.0  
          
    .Inputs  
        System.String  
        System.Collections.Hashtable  
          
    .Outputs  
        System.IO.FileSystemInfo  
          
    .Parameter Append  
        Adds the output to the end of an existing file, instead of replacing the file contents.  
          
    .Parameter InputObject  
        Specifies the Hashtable to be written to the file. Enter a variable that contains the objects or type a command or expression that gets the objects.  
  
    .Parameter FilePath  
        Specifies the path to the output file.  
       
     .Parameter Encoding  
        Specifies the type of character encoding used in the file. Valid values are "Unicode", "UTF7",  
         "UTF8", "UTF32", "ASCII", "BigEndianUnicode", "Default", and "OEM". "Unicode" is the default.  
          
        "Default" uses the encoding of the system's current ANSI code page.   
          
        "OEM" uses the current original equipment manufacturer code page identifier for the operating   
        system.  
       
     .Parameter Force  
        Allows the cmdlet to overwrite an existing read-only file. Even using the Force parameter, the cmdlet cannot override security restrictions.  
          
     .Parameter PassThru  
        Passes an object representing the location to the pipeline. By default, this cmdlet does not generate any output.  
                  
    .Example  
        Out-IniFile $IniVar "C:\myinifile.ini"  
        -----------  
        Description  
        Saves the content of the $IniVar Hashtable to the INI File c:\myinifile.ini  
          
    .Example  
        $IniVar | Out-IniFile "C:\myinifile.ini" -Force  
        -----------  
        Description  
        Saves the content of the $IniVar Hashtable to the INI File c:\myinifile.ini and overwrites the file if it is already present  
          
    .Example  
        $file = Out-IniFile $IniVar "C:\myinifile.ini" -PassThru  
        -----------  
        Description  
        Saves the content of the $IniVar Hashtable to the INI File c:\myinifile.ini and saves the file into $file  
  
    .Example  
        $Category1 = @{“Key1”=”Value1”;”Key2”=”Value2”}  
    $Category2 = @{“Key1”=”Value1”;”Key2”=”Value2”}  
    $NewINIContent = @{“Category1”=$Category1;”Category2”=$Category2}  
    Out-IniFile -InputObject $NewINIContent -FilePath "C:\MyNewFile.INI"  
        -----------  
        Description  
        Creating a custom Hashtable and saving it to C:\MyNewFile.INI  
    .Link  
        Get-IniContent  
    #>  
      
    [CmdletBinding()]  
    Param(  
        [switch]$Append,  
          
        [ValidateSet("Unicode","UTF7","UTF8","UTF32","ASCII","BigEndianUnicode","Default","OEM")]  
        [Parameter()]  
        [string]$Encoding = "UTF8",  
 
          
        [ValidateNotNullOrEmpty()]  
        [ValidatePattern('^([a-zA-Z]\:)?.+\.ini$')]  
        [Parameter(Mandatory=$True)]  
        [string]$FilePath,  
          
        [switch]$Force,  
          
        [ValidateNotNullOrEmpty()]  
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]  
        [Hashtable]$InputObject,  
          
        [switch]$Passthru  
    )  
      
    Begin  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started"}  
          
    Process  
    {  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing to file: $Filepath"  
          
        if ($append) {$outfile = Get-Item $FilePath}  
        else {$outFile = New-Item -ItemType file -Path $Filepath -Force:$Force}  
        if (!($outFile)) {Throw "Could not create File"}  
        foreach ($i in $InputObject.keys | Sort-Object)  
        {  
            if (!($($InputObject[$i].GetType().Name) -eq "Hashtable"))  
            {  
                #No Sections  
                Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing key: $i"  
                Add-Content -Path $outFile -Value "$i=$($InputObject[$i])" -Encoding $Encoding  
            } else {  
                #Sections  
                Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing Section: [$i]"
                Add-Content -Path $outFile -Value "[$i]" -Encoding $Encoding  
                Foreach ($j in $($InputObject[$i].keys | Sort-Object -Property Name ))  
                {  
                    if ($j -match "^Comment[\d]+") {  
                        Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing comment: $j"  
                        Add-Content -Path $outFile -Value "$($InputObject[$i][$j])" -Encoding $Encoding  
                    } else {  
                        Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing key: $j"  
                        Add-Content -Path $outFile -Value "$j=$($InputObject[$i][$j])" -Encoding $Encoding  
                    }  
                      
                }  
                Add-Content -Path $outFile -Value "" -Encoding $Encoding  
            }  
        }  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Finished Writing to file: $path"  
        if ($PassThru) {Return $outFile}  
    }  
          
    End  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended"}  
} 
Function Get-IniContent {  
    <#  
    .Synopsis  
        Gets the content of an INI file  
          
    .Description  
        Gets the content of an INI file and returns it as a hashtable  
          
    .Notes  
        Author        : Oliver Lipkau <oliver@lipkau.net>  
        Blog        : http://oliver.lipkau.net/blog/  
        Source        : https://github.com/lipkau/PsIni 
                      http://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91 
        Version        : 1.0 - 2010/03/12 - Initial release  
                      1.1 - 2014/12/11 - Typo (Thx SLDR) 
                                         Typo (Thx Dave Stiff) 
          
        #Requires -Version 2.0  
          
    .Inputs  
        System.String  
          
    .Outputs  
        System.Collections.Hashtable  
          
    .Parameter FilePath  
        Specifies the path to the input file.  
          
    .Example  
        $FileContent = Get-IniContent "C:\myinifile.ini"  
        -----------  
        Description  
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent  
      
    .Example  
        $inifilepath | $FileContent = Get-IniContent  
        -----------  
        Description  
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent  
      
    .Example  
        C:\PS>$FileContent = Get-IniContent "c:\settings.ini"  
        C:\PS>$FileContent["Section"]["Key"]  
        -----------  
        Description  
        Returns the key "Key" of the section "Section" from the C:\settings.ini file  
          
    .Link  
        Out-IniFile  
    #>  
      
    [CmdletBinding()]  
    Param(  
        [ValidateNotNullOrEmpty()]  
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".ini")})]  
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]  
        [string]$FilePath  
    )  
      
    Begin  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started"}  
          
    Process  
    {  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Processing file: $Filepath"  
              
        $ini = @{}  
        switch -regex -file $FilePath  
        {  
            "^\[(.+)\]$" # Section  
            {  
                $section = $matches[1]  
                $ini[$section] = @{}  
                $CommentCount = 0  
            }  
            "^(;.*)$" # Comment  
            {  
                if (!($section))  
                {  
                    $section = "No-Section"  
                    $ini[$section] = @{}  
                }  
                $value = $matches[1]  
                $CommentCount = $CommentCount + 1  
                $name = "Comment" + $CommentCount  
                $ini[$section][$name] = $value  
            }   
            "(.+?)\s*=\s*(.*)" # Key  
            {  
                if (!($section))  
                {  
                    $section = "No-Section"  
                    $ini[$section] = @{}  
                }  
                $name,$value = $matches[1..2]  
                $ini[$section][$name] = $value  
            }  
        }  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Finished Processing file: $FilePath"  
        Return $ini  
    }  
          
    End  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended"}  
} 


$FileContent = Get-IniContent $inifile


#############Get lastest Video IDs
foreach($key in $FileContent.keys)
{
    If ($FileContent[$key]["ID"].StartsWith("PL")) { #determine if User or Playlist
        $ID = $FileContent[$key]["ID"] 
        $rssurl = "https://www.youtube.com/feeds/videos.xml?playlist_id=$ID"
        $DNurl = "https://www.youtube.com/playlist?list=$ID"
    }else{
        $ID = $FileContent[$key]["ID"]
        $rssurl = "https://www.youtube.com/feeds/videos.xml?channel_id=$ID"
        $DNurl = "https://www.youtube.com/channel/$ID"
    }
    
    if ($FileContent[$key]["720p"].Equals("1")) {$res = "720p"}
    if ($FileContent[$key]["720p"].Equals("0")) {$res = "1080p"}

    if ($FileContent[$key]["lastid"].Equals("")) {
        $path = $FileContent[$key]["directory"]
        $RSS = try { Invoke-RestMethod $rssurl } catch { $_.Exception.Response }
        if ($RSS.Count -eq 0) {$RSS = try { Invoke-RestMethod $rssurl } catch { $_.Exception.Response } }
        $FileContent[$key]["lastid"] = $RSS.videoId[0]
        $arguments = '-i --add-metadata  --restrict-filenames --no-warnings --ignore-config --write-sub --embed-subs --ignore-errors --retries 16 --download-archive /PSripper/config/archive.txt --external-downloader aria2c --external-downloader-args "--file-allocation=none -c -j 5 -x '+$aria2cThreads+' -s '+$aria2cThreads+' -k 1M"  -f "bestvideo[height<=?'+$res+'][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -o "'+$path+''+$os+'%(upload_date)s - %(title)s[%(id)s].%(ext)s" ' +$DNurl
#       $arguments = '-i --add-metadata  --no-warnings --ignore-config --write-sub --embed-subs --ignore-errors --retries 16 --external-downloader aria2c --external-downloader-args "--file-allocation=none -c -j 5 -x 32 -s 32 -k 1M"  -f "bestvideo[height<=?'+ $res +'][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -o "'+$path+'\%(upload_date)s - %(title)s[%(id)s].%(ext)s" ' +$DNurl
         Start-Process -FilePath "youtube-dl" -ArgumentList $arguments -WorkingDirectory $WorkingDirectory -Wait -NoNewWindow
         Out-IniFile -InputObject $FileContent -FilePath $inifile -Force
    }
}

#############Get lastest Video IDs


##########Updatecheck
$a = 1
#debug check $b = 1
DO
{
    foreach($key in $FileContent.keys)
    {
        If ($FileContent[$key]["ID"].StartsWith("PL")) { #determine if User or Playlist
            $ID = $FileContent[$key]["ID"] 
            $rssurl = "https://www.youtube.com/feeds/videos.xml?playlist_id=$ID"
            $DNurl = "https://www.youtube.com/playlist?list=$ID"
        }else{
            $ID = $FileContent[$key]["ID"]
            $rssurl = "https://www.youtube.com/feeds/videos.xml?channel_id=$ID"
            $DNurl = "https://www.youtube.com/channel/$ID"
        }
#Read-Host -Prompt "Press Enter to continue"
        
        if ($FileContent[$key]["720p"].Equals("1")) {$res = "720p"}
        if ($FileContent[$key]["720p"].Equals("0")) {$res = "1080p"}
        $path = $FileContent[$key]["directory"]
        $RSS = try { Invoke-RestMethod $rssurl } catch { $_.Exception.Response }
        if ($RSS.Count -eq 0) {$RSS = try { Invoke-RestMethod $rssurl } catch { $_.Exception.Response } }
        If ($FileContent[$key]["lastid"].Equals($RSS.videoId[0])) {
            "$key not updated"
        }else{
            "$key Updated"
            $FileContent[$key]["lastid"] = $RSS.videoId[0]
            $arguments = '-i --add-metadata  --restrict-filenames --no-warnings --ignore-config --write-sub --embed-subs --ignore-errors --retries 16 --download-archive /PSripper/config/archive.txt --external-downloader aria2c --external-downloader-args "--file-allocation=none -c -j 5 -x '+$aria2cThreads+' -s '+$aria2cThreads+' -k 1M"  -f "bestvideo[height<=?'+$res+'][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -o "'+$path+''+$os+'%(upload_date)s - %(title)s[%(id)s].%(ext)s" ' +$DNurl
#           $arguments = '-i --add-metadata  --no-warnings --ignore-config --write-sub --embed-subs --ignore-errors --retries 16 --download-archive archive.txt --external-downloader aria2c --external-downloader-args "--file-allocation=none -c -j 5 -x 32 -s 32 -k 1M"  -f "bestvideo[height<=?'+$res+'][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -o "'+$path+'\%(upload_date)s - %(title)s[%(id)s].%(ext)s" ' +$DNurl
            Start-Process -FilePath "youtube-dl" -ArgumentList $arguments -WorkingDirectory $WorkingDirectory -wait -NoNewWindow
            Out-IniFile -InputObject $FileContent -FilePath $inifile -Force
            $logline = "$(Get-Date) - $key"
            Add-content "$($ScriptDir)$($os)config$($os)log.txt" -value $logline
        }
        Start-Sleep -s 30
    }   

} While ($a -le 2)

##########Updatecheck
