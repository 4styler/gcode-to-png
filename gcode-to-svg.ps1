$var9 = [hashtable]::Synchronized(@{})

#Enter here your Settings
$var9.LogicalProcessors = 8 #Threads of PC
$var9.NozzleSize = 0.05 #mm
$var9.Bed_Size_X = 115 #mm
$var9.Bed_Size_Y = 60 #mm
$var9.Move_X = 25 #mm
$var9.Move_Y = 30 #mm
$var9.Scale_Object = 1 #factor
$var9.Stroke_Color = "white"
$var9.Fill_Color = "black"
$var9.BackgroudColor = "black"
$var9.Picture_Size = "1024x1024"
$var9.Picture_Scale = "100%"#Scales the Pixels up or down. Nearly the Same as Size but only one Value

    $block = {
        param($layer)
        cd $($var9.ScriptFolder.ToString())

        $share1.header = '<svg height="' + $var9.Bed_Size_Y + '" width="' + $var9.Bed_Size_X + '" stroke="' + $var9.Stroke_Color + '" fill="' + $var9.Fill_Color + '" stroke-width="' + $var9.NozzleSize + '"><rect width="100%" height="100%" style="fill:' + $var9.BackgroudColor + ';stroke-width:3;stroke:' + $var9.BackgroudColor + '" />'
        $var11[$layer] = $var10[$layer].replace("M","DELETE") | select-string -NotMatch "DELETE|;"
        $var12[$layer] = $var11[$layer] -Replace "X","" -Replace "Y",""
        if ($var9.Use_Firmware_G0 -match "true"){$var13[$layer] = $var12[$layer].Replace("G0","M").Replace("G1","L")}
        else{
            $var13[$layer] = $var12[$layer] | foreach{
                if ($($_ | Select-String -NotMatch "E[0-9]")){$_.Replace("G1","M")}
                else {$_.Replace("G1","L")}
            }
        }

        $var14[$layer] = $var13[$layer] | Select-String "M|L"
        $var15[$layer] = $var14[$layer] | foreach{
            $a = $_.Line.split()
            if ($a[1] -match "F"){$a[0] + ' ' + $a[2] + ' ' + $a[3]}
            else{$a[0] + ' ' + $a[1] + ' ' + $a[2]}
        } | Select-String -NotMatch '(L Z|L E|M Z|M E)'

        $path = '<path d="'
        $path += $var15[$layer]
        $path += 'z" transform="translate(' + $var9.Move_X + ' ' + $var9.Move_Y + ') scale(' + $var9.Scale_Object + ')"/>'
        $end = $share1.header + $path + '</svg>'
        [IO.File]::WriteAllText("$($var9.ScriptFolder.ToString())\Temp\$layer.svg", $($end).ToString())
        .\ImageMagick\magick.exe -size $var9.Picture_Size "$($var9.ScriptFolder.ToString())\Temp\$layer.svg" -resize $var9.Picture_Scale "$($(Split-Path $var9.OpenFileDialog.FileName).ToString())\PNG_Out\$layer.png"
    }

    #Vorbereiten der Runspaces
    #Create the sessionstate variable entry to use Synchronized hashtable
    $Jobs = @()
    $var1_main = [hashtable]::Synchronized(@{})
    $var10 = [hashtable]::Synchronized(@{})
    $var11 = [hashtable]::Synchronized(@{})
    $var12 = [hashtable]::Synchronized(@{})
    $var13 = [hashtable]::Synchronized(@{})
    $var14 = [hashtable]::Synchronized(@{})
    $var15 = [hashtable]::Synchronized(@{})
    $var16 = [hashtable]::Synchronized(@{})
    $var17 = [hashtable]::Synchronized(@{})
    $share1 = [hashtable]::Synchronized(@{})
    $runspacepools1 = [hashtable]::Synchronized(@{})

    Add-Type -AssemblyName System.Windows.Forms
    $var9.scriptpath = $MyInvocation.InvocationName
    $var9.ScriptFolder = Split-Path $($var9.scriptpath) -Parent
    cd $var9.ScriptFolder

    $var9.OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $var9.OpenFileDialog.initialDirectory = $initialDirectory
        $var9.OpenFileDialog.filter = "gcode | *.gc*"
        $var9.OpenFileDialog.ShowDialog() | Out-Null
        if (!$($var9.OpenFileDialog.FileName)){exit}

    $var9.OpenFileDialog
    $var9.gcode = $var9.OpenFileDialog.FileName

    if(!(Test-Path -Path "$($var9.ScriptFolder.ToString())\Temp")){New-Item -ItemType directory -Path "$($var9.ScriptFolder.ToString())\Temp"}
    else{Remove-Item "$($var9.ScriptFolder.ToString())\Temp\*.*"}

    if(!(Test-Path -Path "$(Split-Path $var9.OpenFileDialog.FileName)\PNG_Out")){New-Item -ItemType directory -Path "$(Split-Path $var9.OpenFileDialog.FileName)\PNG_Out"}
    else{Remove-Item "$(Split-Path $var9.OpenFileDialog.FileName)\PNG_Out\*.*"}

    $Variable1 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var9',$var9,$Null
    $Variable11 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var10',$var10,$Null
    $Variable12 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var11',$var11,$Null
    $Variable13 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var12',$var12,$Null
    $Variable14 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var13',$var13,$Null
    $Variable15 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var14',$var14,$Null
    $Variable16 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var15',$var15,$Null
    $Variable17 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'share1',$share1,$Null
    $Variable18 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var16',$var16,$Null
    $Variable19 = New-object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'var17',$var17,$Null
    $InitialSessionState1 = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()

    #Add the variable to the sessionstate
    $InitialSessionState1.Variables.Add($Variable1)
    $InitialSessionState1.Variables.Add($Variable11)
    $InitialSessionState1.Variables.Add($Variable12)
    $InitialSessionState1.Variables.Add($Variable13)
    $InitialSessionState1.Variables.Add($Variable14)
    $InitialSessionState1.Variables.Add($Variable15)
    $InitialSessionState1.Variables.Add($Variable16)
    $InitialSessionState1.Variables.Add($Variable17)

    #Create the runspacepool using the defined sessionstate variable
    $runspacepools1.RunspacePool = [runspacefactory]::CreateRunspacePool(1,100,$InitialSessionState1,$Host)
    $runspacepools1.RunspacePool.ApartmentState = "STA" #Vorher STA
    $runspacepools1.RunspacePool.Open()

    $time = Measure-Command{
        $file = [IO.File]::ReadAllLines($var9.gcode)
        write-host Read File
        $layers = .\grep.exe -ni 'layer' $var9.gcode | .\grep -v '   ' | .\grep -vi 'Count'
        if (!$(.\grep.exe -ni 'G0' $var9.gcode)){$var9.Use_Firmware_G0 = "false"}else{$var9.Use_Firmware_G0 = "true"}
    }
    write-host "$($time.TotalSeconds) Seconds to find $($layers.count) Layers"

    Measure-Command{
        $var10.clear
        $var11.clear
        $var12.clear
        $var13.clear
        $var14.clear
        $var15.clear
            $i = 0
            for ($i=0; $i -lt $layers.count; $i++) {
               $startlayer = $layers[$i].split(":")[0]
               if ($layers[$($i+1)]) {$endlayer = $layers[$($i+1)].split(":")[0]}
               if (!$($endlayer)){$endlayer = $file.count}
               if ($($endlayer -eq $startlayer)){$endlayer = $file.count}
               $var10['Layer_' + $($i.ToString("D8"))] = $($file[$($startlayer) .. $($endlayer)])
               write-host $startlayer $endlayer
               write-host $i $_ Saved
            }

        $Jobs = @()
        $i=0
        $save = 1
        if ($save -eq 1){
            $var10.Keys | foreach {
                $i++
                $Job = [powershell]::Create().AddScript($block).AddArgument($_)
		        $Job.RunspacePool = $runspacepools1.RunspacePool
		        $Jobs += New-Object PSObject -Property @{Job_ID = "Job_ID: " + $_; Runspace = $Job; Result = $Job.BeginInvoke()}
                while ($($jobs.Result.IsCompleted | select-string "False").count -gt $var9.LogicalProcessors){
                   Start-Sleep -Milliseconds 1
                }
                write-host $i $_
            }
        }
    }
pause
exit
exit
close
#Remove-Item ".\Temp\*.*"