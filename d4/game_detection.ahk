global inGameDetected := 0
global inTownDetected := 0

gameDetection()
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

inTownDetection()
{
  global inTownDetected
  found := isInTown()

  if (found){
    inTownDetected = 1
  } else {
    inTownDetected = 0
  }
  SetTimer, inTownDetection, 1000
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

isInTown()
{
  global offAbilitycolor := 0x323131 ; color of abilities turned off
  global box1X := 1090 ;
  global box1Y := 1300 ;

  global box2X := 1175 ;
  global box2Y := 1300 ;

  global box3X := 1260 ;
  global box3Y := 1300 ;

  global box4X := 1345 ;
  global box4Y := 1300 ;

  global box5X := 1430 ;
  global box5Y := 1300 ;

  global box6X := 1515 ;
  global box6Y := 1300 ;

  squareSpacing := 10

  box1 := colorExists(box1X, box1Y, box1X + squareSpacing, box1Y + squareSpacing, offAbilitycolor, 10, "box1")
  box2 := colorExists(box2X, box2Y, box2X + squareSpacing, box2Y + squareSpacing, offAbilitycolor, 10, "box2")
  box3 := colorExists(box3X, box3Y, box3X + squareSpacing, box3Y + squareSpacing, offAbilitycolor, 10, "box3")
  box4 := colorExists(box4X, box4Y, box4X + squareSpacing, box4Y + squareSpacing, offAbilitycolor, 10, "box4")
  box5 := colorExists(box5X, box5Y, box5X + squareSpacing, box5Y + squareSpacing, offAbilitycolor, 10, "box5")
  box6 := colorExists(box6X, box6Y, box6X + squareSpacing, box6Y + squareSpacing, offAbilitycolor, 10, "box6")

  abilitiesOff := box1 && box2 && box3 && box4 && box5 && box6

  static gm := 0
  lockedwinnum := 2
  if (abilitiesOff)
  {
    if (!gm){
      gm = 1
      message("INTWN", lockedwinnum)
    }
  } else {
    if (gm){
      gm = 0
      closeProgress(lockedwinnum)
    }
  }

  return box1 && box2 && box3 && box4 && box5 && box6
}