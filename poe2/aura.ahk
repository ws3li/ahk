#include helper.ahk

Class Aura
{
  static qButtonCoordinate := { x: 1920, y: 1395 }
  static firstButtomLeftAuraCenter := { x: 1925, y: 1200 }
  static spacing := 85

  Activate()
  {
    ; ######### 1
    this.AuraClick(1, 1)
    ; ######### 2
    this.AuraClick(2, 1)
    this.AuraClick(2, 2)
    this.AuraClick(2, 3)
    ; ######### 3
    this.AuraClick(3, 1)
    this.AuraClick(3, 3)
    ; ######### 4
    this.AuraClick(4, 2)
    this.AuraClick(4, 3)
    ; ######### 5
    this.AuraClick(5, 3)
    ; ######### 6
    this.AuraClick(6, 1)
    this.AuraClick(6, 2)
    ; ######### 7
    ; ######### 8
    this.AuraClick(8, 1)
    this.AuraClick(8, 2)
    ; ######### 9
    ; ######### 10
    this.AuraClick(10, 2)
    ; ######### Return Selected
    this.AuraClick(9, 1)
  }

  ; columnNumber & rowNumber: starting from the bottom
  AuraClick(rowNumber, columnNumber)
  {
    MouseMove, this.qButtonCoordinate.x, this.qButtonCoordinate.y
    Sleep, 500
    Send {Click}

    posx := this.firstButtomLeftAuraCenter.x + ((columnNumber - 1) * this.spacing)
    posy := this.firstButtomLeftAuraCenter.y - ((rowNumber - 1) * this.spacing)

    MouseMove, posx, posy
    Sleep, 500
    Send {Click}
    Send q
    Sleep, 500
  }
}
