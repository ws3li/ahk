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

Splash("D4 Horde Loop", 2000)

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
Pause, , 1
If A_IsSuspended {
   SplashTextOn, 100, 25, Suspended,
      WinMove, Suspended, , 0, 0 ; Move the splash window to the top left corner.
} Else {
   SplashTextOff
}
Return

^!k::
Splash("start horder loop")
start()
return

^!l::
Splash("lvel up")
level()
return

start2()
{
   customizered := colorExists(1306, 986, 1316, 996, 0x07076B, 20, "customizered")
   if (!customizered)
   {
      Splash("customize" . customizered)
   }
   else
   {
      Splash("customize" . customizered)
   }

}

start()
{
   redbutton := colorExists(1230, 849, 1240, 859, 0x070A65, 30, "redbutton")
   whitebanner := colorExists(1460, 566, 1470, 576, 0x8F958F, 30, "whitebanner")
   if (redbutton && whitebanner)
   {
      Send, { Enter }
      SetTimer, start, -20000
   }

   SetTimer, start, -10000
}

start1() {
   ; check if green tick is there, if so wait 1 min
   greencheckmark := colorExists(2516, 501, 2516 + 10, 501 + 10, 0x17DC44, 10, "greencheckmark")
   if (greencheckmark)
   {
      resethorde(true)
   }
   Else
   {
      ; if not then set timer for 30 sec and run code again
      Splash("not found-rerun in 30 sec")

      bonestomeactive1 := colorExists(1317, 1323, 1317 + 10, 1323 + 10, 0xA9C2D0, 20, "bonestorm1")
      if (bonestomeactive1)
      {
         Sleep 4000
         bonestomeactive2 := colorExists(1317, 1323, 1317 + 10, 1323 + 10, 0xA9C2D0, 20, "bonestorm2")
         if (bonestomeactive2)
         {
            Sleep 4000
            bonestomeactive3 := colorExists(1317, 1323, 1317 + 10, 1323 + 10, 0xA9C2D0, 20, "bonestorm3")
            if (bonestomeactive3)
            {

               MouseClick, left, 2424, 1397, 1, 0, D
               Sleep 3000
               MouseClick, left, 2424, 1397, 1, 0, U

               MouseClick, left, 394, 700, 1, 0, D
               Sleep 3000
               MouseClick, left, 394, 700, 1, 0, U

               Sleep 10000

               bonestomeactive14 := colorExists(1317, 1323, 1317 + 10, 1323 + 10, 0xA9C2D0, 20, "bonestorm4")
               if (bonestomeactive4)
               {
                  Sleep 4000
                  bonestomeactive5 := colorExists(1317, 1323, 1317 + 10, 1323 + 10, 0xA9C2D0, 20, "bonestorm5")
                  if (bonestomeactive5)
                  {
                     resethorde(false)
                  }
               }
            }
         }
      }

      SetTimer, start, -20000
   }
}

resethorde(waitCollect)
{
   if (waitCollect) {
      Splash("found, wait for 1 min")
      Sleep 50000

      ; collect gold by moving
      MouseClick, Left, 1454, 856
      Sleep 2000
      MouseClick, Left, 1236, 381
      Sleep 2000
      MouseClick, Left, 998, 1089
      Sleep 2000
      MouseClick, Left, 1645, 582
      Sleep 2000
      MouseClick, Left, 815, 514
      Sleep 2000
   }

   ; middle mouse
   MouseClick, Middle
   Sleep 2000

   customizered := colorExists(1306, 986, 1316, 996, 0x07076B, 20, "customizered")
   if (!customizered)
   {
      MouseClick, Middle
      Sleep 2000
   }

   MouseClick, Left, 1156, 471
   Sleep 20000

   ; click on I to open inventory
   Send, i
   Sleep, 2000

   ; select second tab for compases
   MouseClick, Left, 2406, 922
   Sleep, 2000

   ; loop through each to find a compass
   widthcount := 0
   heightcount := 0
   width := 74
   height := 107

   Loop
   {
      x := 1725 + (widthcount * width)
      y := 1005 + (heightcount * height)
      compasscolor := colorExists(x, y, x + 10, y + 10, 0x455BC6, 10, "compasscolor")
      If (compasscolor) ; found one
      {
         ; if so, then click
         MouseClick, Right, x, y
         Sleep, 3000

         override := colorExists(1219, 847, 1219 + 10, 847 + 10, 0x07085B, 10, "override")
         If (override)
         {
            MouseClick, Left, 1219, 847
            Sleep, 3000
         }

         override2 := colorExists(1219, 847, 1219 + 10, 847 + 10, 0x07085B, 10, "override2")
         If (override2)
         {
            Send, { Enter }
            Sleep, 3000
         }

         ; left click on dungeon entrance
         MouseClick, Left, 1263, 692

         SetTimer, start, -60000
         Break
      }
      Else
      {
         ; image not found
         widthcount += 1
         If (widthcount == 10) {
            widthcount = 0
            heightcount += 1
         }

         if (heightcount == 3)
         {
            Break ; break the loop
         }
      }
   }
}

level()
{
   ; loop through each to find a compass
   widthcount := 0
   heightcount := 0
   width := 74
   height := 107
   Loop
   {
      x := 1725 + (widthcount * width)
      y := 1005 + (heightcount * height)
      compasscolor := colorExists(x, y, x + 10, y + 10, 0x455BC6, 10, "compasscolor")
      If (compasscolor) ; found one
      {
         ; if so, then click
         Send { Shift down }
         MouseClick, Left, x, y
         Sleep 100
         MouseClick, Left, x, y
         Sleep 100
         MouseClick, Left, x, y
         Sleep 100
         MouseClick, Left, x, y
         Sleep 100
         Send { Shift up }
         Sleep, 500

         ; image not found
         widthcount += 1
         If (widthcount == 10) {
            widthcount = 0
            heightcount += 1
         }

         if (heightcount == 3)
         {
            Break ; break the loop
         }
      }
   }
}