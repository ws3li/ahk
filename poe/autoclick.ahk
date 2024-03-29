global gameExeName
global battlefield

global enableAutoClick
global autoClickSendKey
global autoClickTimeout
global needLeftClick

startAutoClick()
{
  Random autoClickTimeout, autoClickTimeoutMin, autoClickTimeoutMax
  if (battlefield && WinActive(gameExeName))
  {
    KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
    If ErrorLevel = 1 ; held for 1 second
    {
      send %autoClickSendKey%
    }

    SetTimer, startAutoClick, -200
  }
  else
  {
    SetTimer, startAutoClick, -200
  }
}