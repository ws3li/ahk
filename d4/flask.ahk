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
   global inTown
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
      if (!inGameDetected || inTown){
         SetTimer, healthLoop, -200
         return
      }

      hp := colorExists(hpX, hpY, hpX + squareSpacing, hpY + squareSpacing, hpColor, 20, "hpglobe")

      nohp := 1
      if (noHpDetection) {
         nohp := colorExists(noHPX, noHPY, noHPX + squareSpacing, noHPY + squareSpacing, noHPColor, 20, "nohpColor")
      }

      if (!hp && nohp)
      {
         Send, 1
         SetTimer, healthLoop, -2000
      }
      else
      {
         SetTimer, healthLoop, -200
      }
   }
}