startAutoClick()
{
  if (GetKeyState("LButton", "P"))
  {
    If WinActive("ahk_exe Last Epoch.exe")
    {
      send {numpad1}{numpad2}{numpad3}
      SetTimer, startAutoClick, -200
    }
    else
    {
      SetTimer, startAutoClick, -200
    }
  }
  else
  {
    SetTimer, startAutoClick, -200
  }
}