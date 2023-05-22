#include helper.ahk
; ##################################################
; This is to keep pressing key for not going AFK
; ##################################################
class AFK
{
  Start()
  {
   Splash("AFK prevention ON")
   SetTimer, AFK, 5000
   Gosub, AFK
  }

  Stop()
  {
   Splash("AFK prevention OFF")
   SetTimer, AFK, Off
  }
}

AFK:
  Send {q down}
  Sleep 10
  Send {q up}
  Sleep 10
return


