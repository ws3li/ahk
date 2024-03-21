; ##################################################
; This is to keep pressing key for not going AFK
; ##################################################
class AFK
{
  Start()
  {
    Splash("AFK prevention ON")
    SetTimer, AFK, 13000
    Gosub, AFK
  }

  Stop()
  {
    Splash("AFK prevention OFF")
    SetTimer, AFK, Off
  }
}

AFK:
  ; talk to vendor
  MouseMove, 1224, 495
  Sleep 200
  Click

  ; sell items
  Sleep 300
  MouseMove, 1724, 1010
  Sleep 200
  Click Right

  MouseMove, 1795, 1010
  Sleep 200
  Click Right

  MouseMove, 1871, 1010
  Sleep 200
  Click Right

  MouseMove, 1940, 1010
  Sleep 200
  Click Right

  MouseMove, 2013, 1010
  Sleep 200
  Click Right

  MouseMove, 2088, 1010
  Sleep 200
  Click Right

  MouseMove, 2167, 1010
  Sleep 200
  Click Right

  MouseMove, 2233, 1010
  Sleep 200
  Click Right

  ; open season rewards
  Sleep 300
  Send u
  Sleep 300
  MouseMove, 360, 725
  Sleep 200
  Click

  ; undo reward
  Sleep 300
  MouseMove, 868, 697
  Sleep 200
  Click Right
  Sleep 300

  MouseMove, 1174, 879
  Sleep 200
  Click

  Sleep 300
  MouseMove, 868, 697
  Sleep 200
  Click Right
  Sleep 300

  MouseMove, 1174, 879
  Sleep 200
  Click

  Sleep 300
  MouseMove, 868, 697
  Sleep 200
  Click Right
  Sleep 300

  MouseMove, 1174, 879
  Sleep 200
  Click

  Sleep 300
  MouseMove, 868, 697
  Sleep 200
  Click Right
  Sleep 300

  MouseMove, 1174, 879
  Sleep 200
  Click

  ; esc reward
  Send {Esc}
  Sleep 200
  Send {Esc}
  Sleep 200

  ; talk to vendor
  MouseMove, 1224, 495
  Sleep 200
  Click

  ; buy back
  Sleep 300
  MouseMove, 198, 1207
  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  Sleep 200
  Click Right

  ; open season rewards
  Sleep 500
  Send u
  Sleep 500
  MouseMove, 360, 725
  Sleep 200
  Click

  ; upgrade reward
  Sleep 300
  MouseMove, 868, 697
  Sleep 200
  Click

  Sleep 200
  Click

  Sleep 200
  Click

  Sleep 200
  Click

  ; esc reward
  Sleep 200
  Send {Esc}
  Sleep 200
  Send {Esc}
  Sleep 200

return
