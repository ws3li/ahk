global inGameDetected := 0
global inTown := 0
global inventoryOpened := 0

gameDetection()
{
  gameFocusedCheck()
  ; inTownCheck()
  ; inventoryOpenedCheck()
}

gameFocusedCheck()
{
  global inGameDetected
  found := isGameDetected()

  if (found){
    inGameDetected = 1
  }else {
    inGameDetected = 0
  }
  SetTimer, gameDetection, 300
}

inTownCheck()
{
  global inTown
  global F_IN_TOWN

  if (!F_IN_TOWN)
  {
    inTown := 0
    return
  }

  found := isInTown()

  if (found){
    inTown = 1
  }else {
    inTown = 0
  }

  SetTimer, inTownCheck, 2000
}

inventoryOpenedCheck()
{
  global inventoryOpened
  global F_INV_CHECK

  if (F_INV_CHECK)
  {
    found := isInvOpened()

    if (found){
      inventoryOpened = 1
    } else {
      inventoryOpened = 0
    }

    SetTimer, inventoryOpenedCheck, 100
  }
}

isGameDetected()
{
  global detectionPointY
  global detectionPointX
  global detectionPointColor

  Xpoint := detectionPointX
  Ypoint := detectionPointY
  squareSpacing := 10

  detected := colorExists(Xpoint, Ypoint, Xpoint + squareSpacing, Ypoint + squareSpacing, detectionPointColor, 10, "gamedetected")

  static gm := 0
  lockedwinnum := 1
  if (!detected)
  {
    if (!gm){
      gm = 1
      message("D4ND", lockedwinnum)
    }
  } else {
    if (gm){
      gm = 0
      closeProgress(lockedwinnum)
    }
  }

  return detected
}

isInvOpened()
{
  global invXColor
  global invXColorX
  global invXColorY
  global invGoldColor
  global invGoldColorX
  global invGoldColorY

  squareSpacing := 10

  invX := colorExists(invXColorX, invXColorY, invXColorX + squareSpacing, invXColorY + squareSpacing, invXColor, 10, "invX")
  invGold := colorExists(invGoldColorX, invGoldColorY, invGoldColorX + squareSpacing, invGoldColorY + squareSpacing, invGoldColor, 10, "invGold")

  return invX && invGold
}

isInTown()
{
  global offAbilitycolor
  global box1X
  global box1Y
  global box2X
  global box2Y
  global box3X
  global box3Y
  global box4X
  global box4Y
  global box5X
  global box5Y
  global box6X
  global box6Y

  squareSpacing := 10

  box1 := colorExists(box1X, box1Y, box1X + squareSpacing, box1Y + squareSpacing, offAbilitycolor, 3, "box1")
  box2 := colorExists(box2X, box2Y, box2X + squareSpacing, box2Y + squareSpacing, offAbilitycolor, 3, "box2")
  box3 := colorExists(box3X, box3Y, box3X + squareSpacing, box3Y + squareSpacing, offAbilitycolor, 3, "box3")
  box4 := colorExists(box4X, box4Y, box4X + squareSpacing, box4Y + squareSpacing, offAbilitycolor, 3, "box4")
  box5 := colorExists(box5X, box5Y, box5X + squareSpacing, box5Y + squareSpacing, offAbilitycolor, 3, "box5")
  ; box6 := colorExists(box6X, box6Y, box6X + squareSpacing, box6Y + squareSpacing, offAbilitycolor, 51, "box6")

  townDetected := box1 && box2 && box3 && box4 && box5
  return townDetected
}