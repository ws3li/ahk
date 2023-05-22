#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#IfWinActive, Path of Exile ahk_class POEWindowClass

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

#Include, globals.ahk

MonitorPoints := Object() ; Object to store all the monitor points
Splash("Running Build - Minion Leveling", 2000)
characterDetection()

Profile := 1 ;default profile
; flask := new Flask()
; flask.StartAutoFlask()

; ##################################################
; This is to Suspend and unspend keys
; ##################################################
Suspended := 0
!`::
   Suspend
   if (Suspended < 1){
      SplashTextOn ,150, 30, Splash, Script suspended
      Suspended := 1
   }else  {
      SplashTextOn ,150, 30, Splash, Script running
      Suspended := 0
   }
   Sleep 1000
   SplashTextOff
return

; ##################################################
; This is to keep pressing key for not going AFK
; ##################################################
afk := new AFK()
^!k::
   afk.Start()
return

^!l::
   afk.Stop()
return

; ######################################
; This is to auto reset map instance
; ######################################
^Numpad9::
   MouseMove, 1392, 374
   Click
   Sleep, 400
   Send {LControl Down}
   MouseMove, 282, 280
   Sleep, 100
   Click
   Send {LControl Up}
   Sleep, 400
   MouseMove, 480, 332
   Sleep, 100
   Click
return

; ######################################
; TP Back to Hideout
; ######################################

$!t::
   Send i
   MouseMove, 2500, 820
   Sleep, 100
   MouseClick, right
   MouseMove, 835, 545
   Sleep, 100
   Click
return

; Travel to hideout / menagerie / logout login
; ######################################

^h::
   Send {enter}
   Send, /hideout
   Send {enter}
return

^g::
   Send {enter}
   Send, /menagerie
   Send {enter}
return

!$ESC::
   Send {enter}
   Send, /exit
   Send {enter}
   Sleep 1200
   Send {enter}
return


; ######################################
; Trade Message
; ######################################

^$1::
   Send ^{enter}
   Send, In delve. Can you wait a few seconds?
   Send {enter}
return

^$2::
   Send ^{enter}
   Send, Sounds good. I will get back to you right when I am ready
   Send {enter}
return

^$4::
   Send ^{enter}
   Send, Thank you and have a nice day
   Send {enter}

   Send {enter}
   Send, /kick %playerName%
   Send {enter}

   Send {enter}
   Send, /hideout
   Send {enter}
return


; ######################################
; Helper Functions
; ######################################

closeProgress(n)
{
   Progress, %n%: off
}

message(msg, winNum := 0, timer := 0)
{
   mx := 1
   my := 1420
   
   ; m {1, 2, 3} locked, rotation between 4-10
   static m := 4
   progressnum := winNum
   
   if (!progressnum){
      if (m == 10){
         m = 4
      }else  {
         m++
      }
      progressnum = %m%
   }
   
   Progress, %progressnum%: cw465155 CTFFFFFF W200 ZX1 ZY1 x%mx% y%my% m b fs10 zh0, %msg%, , , Arial
   if (timer){
      closeProgress_fn := Func("closeProgress").bind(progressnum)
      SetTimer, % closeProgress_fn, -%timer%
   }
}

; ######################################
; Get Mouse position
; ######################################
!c::
   MouseGetPos, xpos, ypos 
   PixelGetColor, mcol, xpos, ypos
   position := xpos-5 . ", " . ypos-5 . ", " . xpos+5 . ", " . ypos+5 . ", " . mcol
   
   r1 := Rect(xpos-5, ypos-5, 10, 10, BGRToRGB(mcol))
   cleanrect_fn := Func("CleanRect").bind(r1)
   SetTimer,  % cleanrect_fn, 1000
   
   Clipboard := position
return

; Get All recorded points
^!c::
   DrawAllPoints()
return


; ######################################
; FLASK helper
; ######################################

FlipBlueAndRed(c) ; takes RGB or BGR and swaps the R and B
{
   return (c&255)<<16 | (c&65280) | (c>>16)
}

DecToHex(dec)
{
   oldfrmt := A_FormatInteger
   hex := dec
   SetFormat, IntegerFast, hex
   hex += 0
   hex .= ""
   SetFormat, IntegerFast, %oldfrmt%
   return hex
}

BGRToRGB(c)
{
   rgbC := DecToHex(FlipBlueAndRed(c))
   StringTrimLeft, rgbC, rgbC, 2
   return rgbC
}

global charDetected := 0
characterDetection()
{
   global charDetected
   found := isCharacterDetected()

   if (found){
      charDetected = 1
   }else  {
      charDetected = 0
   }
   SetTimer, characterDetection, 300
}

isCharacterDetected()
{
   global charDetectYPoint
   global esAsMana
   global smootherEnabled

   Xpoint := 1210
   Xspace := 13
   horizontalSpacing := 10
   Ypoint := charDetectYPoint

   ; Color
   hpbar := 0x2E9E1E
   manabarColor := 0xBC4C1E
   ESasManaColor := 0xAFB592

   manabar := esAsMana == 1 ? ESasManaColor : manabarColor

   charhp := colorExists(Xpoint, Ypoint, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing, hpbar, 50, "hpbar")
   charmana := colorExists(Xpoint, Ypoint + Xspace, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing + Xspace, manabar, 10, "manabar")
   
   ; Without smoother

   if (smootherEnabled == 0)
   {
      Ypoint := Ypoint - 25
      charhp := colorExists(Xpoint, Ypoint, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing, hpbar, 50, "hpbar")
      charmana := colorExists(Xpoint, Ypoint + Xspace, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing + Xspace, manabar, 10, "manabar")
   }
   
   detected := charhp && charmana
   
   static gm := 0
   lockedwinnum := 1
   if (!detected) 
   {
      if (!gm){
         gm = 1
         message("Character not detected", lockedwinnum)
      }
   } else {
      if (gm){
         gm = 0
         closeProgress(lockedwinnum)
      }
   }
   
   return detected
}

; ######################################
; Auto Flask
; ######################################
!q::
   flask.ToggleQS()
return

!m::
   flask.ToggleMana()
return

!h::
   flask.ToggleHP()
return

; ######################################
; Auto click
; ######################################
AutoClick()
{
   if (GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P"))
   {
      while(GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P"))
      {
         SendInput, ^+{Click}
         Sleep, 30
      }
   }
   else if (GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P"))
   {
      while(GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P"))
      {
         SendInput, ^{Click}
         Sleep, 30
      }
   }
   else if (GetKeyState("LButton", "P") && GetKeyState("Shift", "P"))
   {
      while(GetKeyState("LButton", "P") && GetKeyState("Shift", "P"))
      {
         SendInput, +{Click}
         Sleep, 100
      }
   }
}

^LButton::
   SendInput, ^{Click}
   SetTimer, AutoClick, -200
return

^+LButton::
   SendInput, ^+{Click}
   SetTimer, AutoClick, -200
return

+LButton::
   SendInput, +{Click}
   SetTimer, AutoClick, -200
return

; ######################################
; Auto gem level
; ######################################
gem := new Gem()
!s::
   gem.Run()
return

; ######################################
; Reload this script
; ######################################

^!r::
   Reload
return

; ######################################
; Reload PoeAPIKit
; ######################################

; !r::
;    DetectHiddenWindows, On
;    IfWinNotExist, PoEapikit.ahk
;       Splash("Running poe kit", 2000)
;    Run, "E:\poe\PoEapikit-1.10.1\PoEapikit.ahk"
; return

; ######################################
; Gem Swap
; ######################################
!a::
     Send, i
     Send, x
     Click, 2385 370 Right
     Click, 2147 470
     Click, 2385 370
     Send, x
     Send, i
return

; ######################################
; Setup Profiles
; ######################################

$!1::
   Profile := 1
   Splash("Build: Minion lvl")
return

$!2::
   Profile := 2
   Splash("Splash, Build: Minion lvl + Smoke Mine")
return

$!3::
   Profile := 3
   Splash("Splash, Build: Aura Minion")
return


; ##################
; Minion Leveling
; ##################
#If Profile = 1

[::
   Send, t
return

]::
   Send, t
return


; ##################
; Minion Leveling + Smoke Mine
; ##################
#If Profile = 2

[::
   Send, 1234
return

]::
   Send, t
return

$Space::
   Send t
   Sleep, 400
   Send d
   Sleep, 250
   Send {space}
return

; ##################
; Minion Aura Stacker
; ##################
#If Profile = 3

[::
   Send, 1234
return

]::
   Send, qwert
return

!a::
   aura := new Aura()
   aura.Activate()
return


#include helper.ahk
#include aura.ahk
#include afk.ahk
#include gem.ahk
#include flask.ahk