startAutoClick()
{
  darkshroudInit()
}

darkshroudInit()
{
  global R_AUTO_CLICK_DS
  global inGameDetected
  global inTown

  if (!R_AUTO_CLICK_DS)
  {
    return
  }

  if (inGameDetected && !inTown)
  {
    autoClickDarkShroud()
  }

  SetTimer, darkshroudInit, 2000
}

autoClickDarkShroud()
{
  ; Check if skill is available
  dsavailableColor := 0x9ACCDF
  dsavailableX := 1303
  dsavailableY := 1312
  dsavailable := colorExists(dsavailableX, dsavailableY, dsavailableX + squareSpacing, dsavailableY + squareSpacing, dsavailableColor, 3, "dsavailable")

  ; check if skill is on CD
  dsavailablecd := colorExists(dsavailableX, dsavailableY, dsavailableX + squareSpacing, dsavailableY + squareSpacing, 0x2C3446, 0, "dsavailablecd")

  if (dsavailable && !dsavailablecd)
  {
    Send r
  }
}