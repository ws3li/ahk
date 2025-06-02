Splash(m, timeout := 1000)
{
   width := 250
   height := 25

   SplashTextOn, width, height, Splash, %m%
   Sleep timeout
   SplashTextOff
}

colorExists(x1, y1, x2, y2, inputColor, variant, name := "")
{
   global MonitorPoints
   MonitorPoints[name] := { x1: x1, y1: y1 }
   PixelSearch, OutputVarX, OutputVarY, x1, y1, x2, y2, inputColor, variant, Fast
   return !ErrorLevel
}

Rect(x, y, w, h, c) {
   static n := 0
   n++
   Gui, %n%:-Caption +AlwaysOnTop +ToolWindow +Border
   Gui, %n%:Color, %c%
   Gui, %n%:Show, x%x% y%y% w%w% h%h%
   return n
}

CleanRect(n) {
   Gui, %n%:Destroy
}

DrawAllPoints()
{
   global MonitorPoints
   ; Show results
   rects := []
   for Key, Val in MonitorPoints
   {
      n := Rect(Val.x1, Val.y1, 10, 10, 0xFFFFFF)
      rects.Push(n)
   }

   Sleep, 5000

   for index, element in rects
   {
      CleanRect(element)
   }
}