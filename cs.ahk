#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

splash("Start CS", 1000)

splash(m, timeout)
{
   SplashTextOn, 200, 50, Splash, %m%
   Sleep timeout
   SplashTextOff
}

!r::
   Reload
return

v::
  MouseGetPos, xpos, ypos 
  PixelGetColor, mcol, xpos+2, ypos+2
  loopcheck(mcol, xpos+2, ypos+2)
Return

^v::
  MouseGetPos, xpos, ypos 
  PixelGetColor, mcol, xpos+2, ypos+2
  loopcheck(mcol, xpos+2, ypos+2)
Return

loopcheck(initcolor, x, y)
{
  MouseGetPos, newx, newy
  while(x == newx+2 && y == newy+2)
  {
    PixelSearch, OutputVarX, OutputVarY, x-1, y-1, x+1, y+1, initcolor, 10, Fast
    if (ErrorLevel)
    {
      SendInput, {Click}
      return
    }
  }
}

