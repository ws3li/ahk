﻿; detect whether to keep looping and running the script
global detectionPointX := 1018 ; X-l : x coordinate (left)
global detectionPointY := 1247 ; Y-t : y coordinate (top)
global detectionPointColor := 0x1E3741 ; hexColor : hex color to match

; detect low HP to toggle auto flask
global potionKeybind := 1 ; keyboard set in game for potion
global hpX := 860 ; X-l : x coordinate (left)
global hpY := 1300 ; Y-t : y coordinate (top)
global hpColor := 0x070432 ; hexColor : hex color to match

; addtional detection on top of the above low hp check (more precise)
global noHpDetection := 1 ; turn on or off (1 or 0)
global noHPX := 860 ; X-l : x coordinate (left)
global noHPY := 1285 ; Y-t : y coordinate (top)
global noHPColor := 0x141112 ; hexColor : hex color to match

; track if inventory is opened
global F_INV_CHECK := 1 ; feature on/off flag
global invXColor := 0x07064E ; x color for inventory
global invXColorX := 2531 ; x position
global invXColorY := 103 ; y position
global invAbilityBtnColor := 0x838D93 ; inv "abilities" button color
global invAbilityBtnColorX := 2394 ; inv "abilities" button color
global invAbilityBtnColorY := 59 ; inv "abilities" button color

; detect ability box color
global F_IN_TOWN := 1 ; check if in town feature (on / off)
global offAbilitycolor := 0x070807 ; color of abilities turned off
global box1X := 1090 ;
global box1Y := 1306 ;

global box2X := 1174 ;
global box2Y := 1306 ;

global box3X := 1258 ;
global box3Y := 1306 ;

global box4X := 1342 ;
global box4Y := 1306 ;

global box5X := 1426 ;
global box5Y := 1306 ;

global box6X := 1510 ;
global box6Y := 1306 ;

; perform auto clicks on abilities
global R_AUTO_CLICK_DS := 1 ; auto click the darkshroud (not in town and if not already have one)