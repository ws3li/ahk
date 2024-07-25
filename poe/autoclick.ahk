global gameExeName
global battlefield

startAutoClick()
{
  autoClickingR()
  autoClickingT()
}

autoClickingR()
{
  global autoClickR
  global autoClickREnabled
  global autoClickRTimer

  if (battlefield && WinActive(gameExeName) && autoClickR && autoClickREnabled)
  {
    KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
    If ErrorLevel = 1 ; held for 1 second
    {
      send %autoClickR%
    }

    SetTimer, autoClickingR, -%autoClickRTimer%
  }
  else
  {
    SetTimer, autoClickingR, -50
  }
}

autoClickingT()
{
  global autoClickT
  global autoClickTEnabled
  global autoClickTTimer

  if (battlefield && WinActive(gameExeName) && autoClickT && autoClickTEnabled)
  {
    KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
    If ErrorLevel = 1 ; held for 1 second
    {
      send %autoClickT%
    }

    SetTimer, autoClickingT, -%autoClickTTimer%
  }
  else
  {
    SetTimer, autoClickingT, -50
  }
}

