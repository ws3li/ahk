#include helper.ahk
; ##################################################
; Auto gem level
; ##################################################

Class Gem
{
  Run()
  {
    BlockInput MouseMove
    ; save current mouse position
    MouseGetPos, xpos, ypos

    ; we are looking for lvl up gem text colorExists ("up" - p)
    ; we check if found on mini map hidden then shown
    foundOnMapHidden := this.textShownOnMapHidden()
    foundOnMapShown := this.textShownOnMapShown()

    ; we did not find the lvl up text
    if (!foundOnMapHidden && !foundOnMapShown)
    {
      BlockInput MouseMoveOff
      return
    }

    ; level up button (square with the plus sign) - X and Y coordinate
    levelupButtonX := 2473 ; this does not change
    levelupButtonY := foundOnMapHidden ? 276 : 407 ; ; this changes depending whether the map is opened or not

    ; move the mouse to the lvl up buttons
    MouseMove levelupButtonX, levelupButtonY, 0 ; 0 is instant move

    ; loop to see if we still see the text color so that we can keep levelling up any subsequent gems
    ; if so we loop and click on each gem level up
    while (this.foundLevellingText(foundOnMapHidden))
    {
      Click
      Sleep 75 ; need to keep this sleep here so that the UI reflects the change after the click
    }

    ; return to saved mouse position
    MouseMove xpos, ypos, 0 ; 0 is instant move
    BlockInput MouseMoveOff
  }

  textShownOnMapHidden()
  {
    foundOnMapHidden := colorExists(2436, 273, 2446, 283, 0x165587, 10, "lvluphiddentext")
    return foundOnMapHidden
  }

  textShownOnMapShown()
  {
    foundOnMapShown := colorExists(2436, 403, 2446, 413, 0x165587, 10, "lvlupshowntesx")
    return foundOnMapShown
  }

  foundLevellingText(foundOnMapHidden)
  {
    if (foundOnMapHidden)
    {
      val := this.textShownOnMapHidden()
      return val
    }

    return this.textShownOnMapShown()
  }
}
