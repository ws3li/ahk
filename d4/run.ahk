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
#include autoclick.ahk

Splash("D4 Running", 2000)

gameDetection() ; Perform Game detection
startAutoFlask() ; Perform Auto Flask
startAutoClick() ; Perform Auto Clicks

; ^ = ctrl
; ! = alt

!c::
   getCursorData()
return

; Get All recorded points
^!c::
   DrawAllPoints()
return

; ######################################
; Auto Flask
; ######################################
!h::
   toggleHP()
return

; ######################################
; Reload this script
; ######################################
^!r::
   Reload
return

; ######################################
; Suspend code
; ######################################
!`::
   Suspend
   Pause,,1
   If A_IsSuspended {
      SplashTextOn, 100, 25, Suspended,
      WinMove, Suspended, , 0, 0 ; Move the splash window to the top left corner.
   } Else {
      SplashTextOff
   }
Return

; ######################################
; AFK
; ######################################
#include afk.ahk
afk := new AFK()

^!k::
   afk.Start()
return

^!l::
   afk.Stop()
return