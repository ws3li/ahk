MonitorPoints := Object() ; Object to store all the monitor points

; ##################################################
; Messaging
; ##################################################
Splash(m, timeout := 1000)
{
   width := 250
   height := 25

   SplashTextOn, width, height, Splash, %m%
   Sleep timeout
   SplashTextOff
}

; ##################################################
; Bottom left Overlay Messaging
; ##################################################
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

   if (!progressnum) {
      if (m == 10) {
         m = 4
      } else {
         m++
      }
      progressnum = %m%
   }

   Progress, %progressnum%: cw465155 CTFFFFFF W200 ZX1 ZY1 x%mx% y%my% m b fs10 zh0, %msg%, , , Arial
   if (timer) {
      closeProgress_fn := Func("closeProgress").bind(progressnum)
      SetTimer, %closeProgress_fn%, -%timer%
   }
}

; ##################################################
; Color detection, Recording, Draw "recorded" points
; ##################################################
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
   Gui, %n%: -Caption + AlwaysOnTop + ToolWindow + Border
   Gui, %n%: Color, %c%
   Gui, %n%: Show, x%x% y%y% w%w% h%h%
   return n
}

CleanRect(n) {
   Gui, %n%: Destroy
}

; ######################################
; Draw all recorded points
; ######################################
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

; ######################################
; Get Mouse position
; ######################################
getCursorData()
{
   MouseGetPos, xpos, ypos
   PixelGetColor, mcol, xpos, ypos
   position := "X-l= " . xpos - 5 . ", Y-t= " . ypos - 5 . ", X-r= " . xpos + 5 . ", Y-b= " . ypos + 5 . ", hexColor= " . mcol . ", readableColor= " . BGRToRGB(mcol)

   r1 := Rect(xpos - 5, ypos - 5, 10, 10, BGRToRGB(mcol))
   cleanrect_fn := Func("CleanRect").bind(r1)
   SetTimer, %cleanrect_fn%, 1000

   Clipboard := position
   ; take readable color and use on https://www.rapidtables.com/web/color/RGB_Color.html
}

FlipBlueAndRed(c) ; takes RGB or BGR and swaps the R and B
{
   return (c & 255) << 16 | (c & 65280) | (c >> 16)
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

; ##################################################
; Used for passing setTimer for a function
; ref: https://www.autohotkey.com/boards/viewtopic.php?t=13010
; ##################################################
class SelfDeletingTimer {
   __New(period, fn, prms*) {
      this.fn := IsObject(fn) ? fn : Func(fn)
      this.prms := prms
      SetTimer %this%, %period%
   }
   Call() {
      this.fn.Call(this.prms*)
      SetTimer %this%, Delete
   }
}