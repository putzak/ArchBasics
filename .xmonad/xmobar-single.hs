----------------------
--XMOBAR CUSTOM CONF--
----------------------

Config 
    {  position = TopSize L 100 24
    , font = "xft:monospace:weight=bold:pixelsize=14:antialias=true:hinting=true"
    , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=11:antialias=true:hinting=true"
                        , "xft:Font Awesome 5 Free Solid:pixelsize=12"
                        , "xft:Font Awesome 5 Brands:pixelsize=12"
                        ]
    , border = BottomB
    , borderColor = "black"
    , bgColor = "#282c34"
    , fgColor = "#ff6c6b"
    , lowerOnStart = True
    , hideOnStart = False
    , allDesktops = True
    , persistent = True
    , commands = [
                   Run UnsafeStdinReader
                 , Run Date "<fc=#da8548>%a %0d %b </fc>" "date" 10
                 , Run DateZone "<fc=#a9a1e1>%H:%M </fc> " "" "Europe/London" "gmt" 10
                 , Run Weather "EHLE"
                     [ "-t", "<tempC> <fc=#dfdfdf>°C </fc>"
                     , "-L", "8", "-H", "25"
                     , "--normal", "green", "--high", "red", "--low", "lightblue"
                     ] 36000
                 ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = " %UnsafeStdinReader% }{ %EHLE% %date% %gmt% " 
    }
