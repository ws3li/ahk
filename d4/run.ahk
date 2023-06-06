#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background

SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

#include globals.ahk
#include helper.ahk
#include game_detection.ahk
#include flask.ahk

Splash("D4 Running", 2000)

gameDetection() ; Perform Game detection
startAutoFlask() ; Perform Auto Flask

; ##################################################
; This is to Pause and suspend keys
; ##################################################
!`::
   Pause
   Suspend

   SplashTextOn ,150, 30, Splash, Script Running
   Sleep 1000
   SplashTextOff
return

; ######################################
; Get Mouse position
; ######################################
!c::
   MouseGetPos, xpos, ypos
   PixelGetColor, mcol, xpos, ypos
   position := "X-l= " . xpos-5 . ", Y-t= " . ypos-5 . ", X-r= " . xpos+5 . ", Y-b= " . ypos+5 . ", hexColor= " . mcol . ", readableColor= " . BGRToRGB(mcol)

   r1 := Rect(xpos-5, ypos-5, 10, 10, BGRToRGB(mcol))
   cleanrect_fn := Func("CleanRect").bind(r1)
   SetTimer, % cleanrect_fn, 1000

   Clipboard := position
; take readable color and use on https://www.rapidtables.com/web/color/RGB_Color.html
return

; ######################################
; Exit dungeon and reset
; ######################################
!d::
   Send, {MButton}
   Click, 1166, 504
   Sleep 15000
   Send {ESC}
   Click, 544, 990
   Sleep 15000
   send {enter}
   Sleep 21000
   Click, 1037, 444
return

; Get All recorded points
^!c::
   DrawAllPoints()
return

; ######################################
; Auto Flask
; ######################################
!h::
   toggleHP(1)
return

; ######################################
; Reload this script
; ######################################
^!r::
   Reload
return

; ^ = ctrl
; ! = alt