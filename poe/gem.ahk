#include helper.ahk
; ##################################################
; Auto gem level
; ##################################################

Class Gem
{
  ; common color 
  static crossBlask := 0x000000
  static crossOrange := 0x08CBFC

  ; button coordinate start x (bx1) and end x (bx2) of
  ; square to check color
  static bx1 := 2473
  static bx2 := 2483

  Run()
  {
    ; save current mouse position
    MouseGetPos, xpos, ypos 

    ; we are looking for lvl up gem text colorExists
    ; we check if found on mini map hidden then shown
    foundOnMapHidden := colorExists(2436, 273, 2446, 283, 0x165587, 10, "lvluphidden")
    foundOnMapShown := colorExists(2437, 401, 2447, 411, 0x165587, 10, "lvlupshown")

    ; we did not find the lvl up text 
    if (!foundOnMapHidden && !foundOnMapShown)
    {
      return
    }

    if (foundOnMapHidden)
    {
      ; we found on map hidden
      ; we need toupdate the vertical coordinates
      this.by1 := 276
      this.by2 := 286
    }
    else
    {
      ; we found on map hidden
      ; we need toupdate the vertical coordinates
      this.by1 := 407
      this.by2 := 417
    }


    ; check if we found the button
    ; check color black and orange
    ; if so we loop and click on each gem level up
    while (this.FoundButton())
    {
      SendInput, {Click}
    }

    ; return to saved mouse position
    MouseMove xpos, ypos
  }

  FoundButton()
  { 
    MouseMove this.bx1, this.by1
    Sleep, 80

    foundBlack := colorExists(this.bx1, this.by1, this.bx2, this.by2, this.crossBlask, 10, "buttonblack")
    foundOrange := colorExists(this.bx1, this.by1, this.bx2, this.by2, this.crossOrange, 10, "buttonorange")

    return foundBlack && foundOrange
  }
}
