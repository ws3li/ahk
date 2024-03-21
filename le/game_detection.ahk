global notInTown := 0
characterDetection()
{
  global notInTown
  found := isCharacterDetected()

  if (found){
    notInTown = 1
  }else {
    notInTown = 0
  }
  SetTimer, characterDetection, 300
}

isCharacterDetected()
{
  ; Statue Color
  Xpoint := 496
  horizontalSpacing := 10
  Ypoint := 1308
  statue := 0x89CCBB
  charhp := colorExists(Xpoint, Ypoint, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing, statue, 50, "statue")

  ; XP Color
  xpXpoint := 1019
  xphorizontalSpacing := 10
  xpYpoint := 1410
  xpColor := 0x00A4FF
  xpchar := colorExists(xpXpoint, xpYpoint, xpXpoint + xphorizontalSpacing, xpYpoint + xphorizontalSpacing, xpColor, 50, "xpcolor")

  detected := charhp && xpchar

  static gm := 0
  lockedwinnum := 1
  if (!detected)
  {
    if (!gm){
      gm = 1
      message("Character not detected", lockedwinnum)
    }
  } else {
    if (gm){
      gm = 0
      closeProgress(lockedwinnum)
    }
  }

  return detected
}
