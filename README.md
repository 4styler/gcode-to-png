# gcode-to-png
(License: grep(GNU GENERAL PUBLIC LICENSE), ImageMagick(ImageMagick License) see Licence File)

Create a png file of each Layer of a GCode (optimized for CURA and Simplify3D GCode files)

(Can Anyone tell me if i can attach grep and ImageMagick directly here? Or is that a licence problem?)

You need for that tool:
grep.exe  
Download: http://gnuwin32.sourceforge.net/packages/grep.htm

You need the Binarys download for that. In the Zipfile you will find the needed file in the folder "bin".

Take it in the same folder as the gcode-to-png.ps1 script is.

You also need ImageMagick for this. Download it under: 

x64 Bit: https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-35-portable-Q16-x64.zip

x32 Bit: https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-35-portable-Q16-x86.zip


create a folder "ImageMagick" in the same folder of the gcode-to-png.ps1 script and unzip it in the "ImageMagick" folder.

After that start the script with powershell, choose a gcode file and wait for the output.

It is not really fast but it do his job. I hope it will help the DLP-3D-Printer community a little bit.

It is made for "Formware Print Controller" but it will also work with other tools.
https://www.formware.co/dlpprintcontroller/

That are the settings in the Script:

$var9.LogicalProcessors = 8 #Threads of PC
  - Will change the running threads. Sometimes less is more.
  
$var9.NozzleSize = 0.05 #mm
  - Enter here the nozzle size you have used for the gcode. Perhabs a little bit more.
  
$var9.Bed_Size_X = 115 #mm
  - That option will scale the hole image. Use youre Bed Size
  
$var9.Bed_Size_Y = 60 #mm
  - That option will scale the hole image. Use youre Bed Size
  
$var9.Move_X = 25 #mm
  - That will move your object "Gcode" to another position.
  
$var9.Move_Y = 30 #mm
  - That will move your object "Gcode" to another position.
  
$var9.Scale_Object = 1 #factor
  - With this option you can scale the Object to get the correct size on the Screen
  
$var9.Stroke_Color = "white"
  - Colour of the Lines in the gcode.
  
$var9.Fill_Color = "black"
  - Colour of infill (doesnt really need)
  
$var9.BackgroudColor = "black"
  - Colour of the Background. Should always be black.
  
$var9.Picture_Size = "1024x1024"
  - The size of the Picture. It should mach your Screensize. Be Patient. It will make much more CPU load.
  
$var9.Picture_Scale = "100%"#Scales the Pixels up or down. Nearly the Same as Size but only one Value
  - Same as above in Percent.
  
  
If you have Fragments or something like this you should take a look on the Filter in "block" part of the script.

It will dont filter correctly.

I hope you will find this tool helpfully. Have a lot of fun with it.

