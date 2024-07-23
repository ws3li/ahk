global gameExeName
global battlefield
global autoClickSendKey

startAutoClick()
{
  clicking()
}

clicking()
{
  if (battlefield && WinActive(gameExeName) && autoClickSendKey)
  {
    KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
    If ErrorLevel = 1 ; held for 1 second
    {
      send %autoClickSendKey%
    }

    SetTimer, clicking, -50
  }
  else
  {
    SetTimer, clicking, -50
  }
}