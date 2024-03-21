; detect whether to keep looping and running the script
global detectionPointX := 1018 ; X-l : x coordinate (left)
global detectionPointY := 1247 ; Y-t : y coordinate (top)
global detectionPointColor := 0x1E3741 ; hexColor : hex color to match

; detect low HP to toggle auto flask
global potionKeybind := 1 ; keyboard set in game for potion
global hpX := 684 ; X-l : x coordinate (left)
global hpY := 1274 ; Y-t : y coordinate (top)
global hpColor := 0x15185C ; hexColor : hex color to match

; addtional detection on top of the above low hp check (more precise)
global noHpDetection := 1 ; turn on or off (1 or 0)
global noHPX := 684 ; X-l : x coordinate (left)
global noHPY := 1252 ; Y-t : y coordinate (top)
global noHPColor := 0x1A2762 ; hexColor : hex color to match

; track if inventory is opened
global F_INV_CHECK := 1 ; feature on/off flag
global invXColor := 0x151531 ; x color for inventory
global invXColorX := 937 ; x position
global invXColorY := 57 ; y position