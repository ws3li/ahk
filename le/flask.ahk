; ##################################################
; Auto Flask
; ##################################################

global toggle_hp

startAutoFlask()
{
   toggleHP(0)
}

toggleHP(showMsg := 1)
{
   toggle_hp := !toggle_hp

   If toggle_hp
   {
      if (showMsg)
      {
         Splash("Auto HP Enabled")
      }

      healthLoop()
   }
   else
   {
      if (showMsg)
      {
         Splash("Auto HP Disabled")
      }

      random, rnd, 1, 100
      healthLoop_fn := Func("healthLoop").bind(rnd, healthLoop_prm := {})
      healthLoop_prm.fn := healthLoop_fn
      SetTimer, % healthLoop_fn, Off
   }
}

healthLoop()
{
   global charDetected
   global hpX
   global hpY
   global hpColor

   global noHpDetection
   global noHPX
   global noHPY
   global noHPColor

   squareSpacing := 10

   if (GetKeyState("LButton", "P"))
   {

   }

   if toggle_hp
   {
      if (!charDetected){
         SetTimer, healthLoop, -200
         return
      }

      hp := colorExists(hpX, hpY, hpX + squareSpacing, hpY + squareSpacing, hpColor, 20, "hpglobe")
      invOp := isInvOpenedCheck()

      if (!hp && !invOp && GetKeyState("LButton", "P"))
      {
         If WinActive("ahk_exe Last Epoch.exe")
         {
            Send, 1
            SetTimer, healthLoop, -1000
         }
         else
         {
            SetTimer, healthLoop, -200
         }
      }
      else
      {
         SetTimer, healthLoop, -200
      }
   }
}

isInvOpenedCheck()
{
   global invXColor
   global invXColorX
   global invXColorY1

   squareSpacing := 10

   invX := colorExists(invXColorX, invXColorY, invXColorX + squareSpacing, invXColorY + squareSpacing, invXColor, 10, "invX")

   return invX
}