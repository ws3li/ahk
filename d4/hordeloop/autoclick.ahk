startAutoClick()
{
  autopressr()
}

autopressr()
{
  global inGameDetected
  dsavailablecd := colorExists(1317, 1322, 1327 + 10, 1332 + 10, 0xC7DFE2, 20, "offcooldown")
  if (inGameDetected && WinActive("ahk_exe Diablo IV.exe") && dsavailablecd)
  {
    KeyWait, LButton, T0.5 ; if left button is held for 1 second T = 1 second
    If ErrorLevel = 1 ; held for 1 second
    {
      Send r
    }
  }

  SetTimer, autopressr, -50
}
