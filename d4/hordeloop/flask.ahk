; ##################################################
; Auto Flask
; ##################################################

global toggle_hp
global showMsg

startAutoFlask()
{
   showMsg := 0
   toggleHP()
}

toggleHP()
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
   global inventoryOpened
   global inGameDetected
   global hpX
   global hpY
   global hpColor

   global noHpDetection
   global noHPX
   global noHPY
   global noHPColor

   squareSpacing := 10

   if toggle_hp
   {
      if (!inGameDetected){
         SetTimer, healthLoop, -200

         if (showMsg)
         {
            Splash("Game not detected")
         }

         return
      }

      ; hp := colorExists(hpX, hpY, hpX + squareSpacing, hpY + squareSpacing, hpColor, 20, "hpglobe")
      ; if (showMsg)
      ; {
      ;    Splash("hp: " + hp)
      ; }

      hp := 0

      nohp := 0
      if (noHpDetection) {
         nohp := colorExists(noHPX, noHPY, noHPX + squareSpacing, noHPY + squareSpacing, noHPColor, 20, "nohpColor")
         if (showMsg)
         {
            Splash("nohp: " + nohp)
         }
      }

      invOp := isInvOpenedCheck()
      if (!hp && nohp && !invOp)
      {
         If WinActive("ahk_exe Diablo IV.exe")
         {
            Send, 1
            SetTimer, healthLoop, -500
         }

         SetTimer, healthLoop, -200
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