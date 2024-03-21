#include helper.ahk
; ##################################################
; Auto Flask
; ##################################################

global toggle_hp
global toggle_mana
global toggle_qs

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
      global esAsMana
      this.ToggleHP(0)
      if (esAsMana == 0)
      {
         this.ToggleMana(0)
      }
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
         SetTimer, healthLoop, -200
         return
      }

      hp := colorExists(119, 1202, 129, 1212, 0x281E7B, 10, "hpglobe")
      if (!hp && WinActive("ahk_exe PathOfExile.exe"))
      {
         flask1 := colorExists(436, 1399, 446, 1409, 0x091351, 10, "hpflask")
         if (flask1)
         {
            Send, 1
         }
         else
         {
            Send, 2
         }
         activatedWaitFlask := instantFlask == 1 ? -200 : -1500
         SetTimer, healthLoop, %activatedWaitFlask%
      }
      else
      {
         SetTimer, healthLoop, -200
      }
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
         SetTimer, manaloop, -200
         return
      }

      mana := colorExists(2359, 1405, 2369, 1415, 0x402214, 10, "manaflask")
      if (!mana && WinActive("ahk_exe PathOfExile.exe"))
      {
         Send, 3
         SetTimer, manaloop, -1000
      }
      else
      {
         SetTimer, manaloop, -300
      }
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

      isMoving := GetKeyState("LButton", "P")
      if (isMoving && WinActive("ahk_exe PathOfExile.exe"))
      {
         qs := colorExists(614, 1397, 624, 1407, 0x51AE2D, 10, "qsflask")
         if (qs)
         {
            Send, 4
         }
         else
         {
            Send, 5
         }
         SetTimer, qsloop, -5000
      }
      else
      {
         SetTimer, qsloop, -500
      }
   }
Return