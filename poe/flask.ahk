#include helper.ahk
; ##################################################
; Auto Flask
; ##################################################

global toggle_hp
global toggle_mana
global toggle_qs
global gameExeName

Class Flask
{
   ToggleHP(showMsg := 1)
   {
      global toggle_hp
      toggle_hp := !toggle_hp
      If toggle_hp
      {
         if (showMsg)
         {
            Splash("Auto HP Enabled")
         }
         GoSub, healthLoop
      }
      else
      {
         if (showMsg)
         {
            Splash("Auto HP Disabled")
         }
         SetTimer, healthLoop, Off
      }
   }

   ToggleMana(showMsg := 1)
   {
      global toggle_mana
      toggle_mana := !toggle_mana
      If toggle_mana
      {
         if (showMsg)
         {
            Splash("Auto Mana Enabled")
         }
         GoSub, manaloop
      }
      else
      {
         if (showMsg)
         {
            Splash("Auto Mana Disabled")
         }
         SetTimer, manaloop, Off
      }
   }

   ToggleQS(showMsg := 1)
   {
      global toggle_qs
      toggle_qs := !toggle_qs
      If toggle_qs
      {
         if (showMsg)
         {
            Splash("Auto QS Enabled")
         }
         GoSub, qsloop
      }
      else
      {
         if (showMsg)
         {
            Splash("Auto QS Disabled")
         }
         SetTimer, qsloop, Off
      }
   }

   StartAutoFlask()
   {
      this.ToggleHP(0)
      this.ToggleMana(0)
      this.ToggleQS(0)
   }
}

; ######################################
; Auto HP (flask slot 1 and 2)
; ######################################
healthLoop:
   global battlefield
   global instantFlask

   if toggle_hp
   {
      if (!battlefield){
         SetTimer, healthLoop, -50
         return
      }

      activatedWaitFlask := instantFlask == 1 ? -200 : -2200
      hp := colorExists(119, 1202, 129, 1212, 0x281E7B, 10, "hpglobe")

      if (!hp && WinActive(gameExeName))
      {
         if (!colorExists(432, 1399, 442, 1409, 0x111212, 10, "hpflaskemptycolor1")) ; is it empty if not then run code
         {
            Send, 1
            SetTimer, healthLoop, %activatedWaitFlask%
            return
         }
         else if (!colorExists(494, 1399, 504, 1409, 0x111212, 10, "hpflaskemptycolor2")) ; is it empty if not then run code
         {
            Send, 2
            SetTimer, healthLoop, %activatedWaitFlask%
            return
         }
      }
      SetTimer, healthLoop, -50
   }
Return

; ######################################
; Auto Mana (flask slot 3)
; ######################################
manaloop:
   global battlefield
   if toggle_mana
   {
      if (!battlefield)
      {
         SetTimer, manaloop, -50
         return
      }

      mana := colorExists(2359, 1369, 2369, 1379, 0x6E330E, 10, "managlobe")
      if (!mana && WinActive(gameExeName))
      {
         Send, 3
         SetTimer, manaloop, -1500
         return
      }

      SetTimer, manaloop, -50
   }
Return

; ######################################
; Auto QS (flask slot 4 and 5)
; ######################################
qsloop:
   global battlefield
   if toggle_qs
   {
      if (!battlefield)
      {
         SetTimer, qsloop, -200
         return
      }

      if (WinActive(gameExeName))
      {
         KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
         if ErrorLevel = 1 ; held for 1 second
         {
            if (colorExists(614, 1397, 624, 1407, 0x51AE2D, 10, "qsflask4"))
            {
               Send, 4
               SetTimer, qsloop, -6200
               return
            }
            else if (colorExists(676, 1397, 686, 1407, 0x51AE2D, 10, "qsflask5"))
            {
               Send, 5
               SetTimer, qsloop, -6200
               return
            }
         }
      }

      SetTimer, qsloop, -200
   }
Return