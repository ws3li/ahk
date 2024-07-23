startAutoClick()
{
  ; autopressr()
}

autopressr()
{
  global inGameDetected
  if (inGameDetected && WinActive("ahk_exe Diablo IV.exe"))
  {
    autoClickR()
  }

  SetTimer, autopressr, -500
}

autoClickR()
{
  ; check if skill is off
  dsavailablecd := colorExists(1426, 1311, 1426 + 10, 1311 + 10, 0x0A0D0A, 0, "offcooldown")

  if (!dsavailablecd)
  {
    Send f
  }
}