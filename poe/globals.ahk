global playerName := "Prolegend"
global playerName2 := "Prolegend_Boat"

global rightButtonIconYPoint := 1323 ; this is to detect whether action buttons are enabled (in combat/battlefield)
global instantFlask := 0 ; are you using instant flask?
global gameExeName := "ahk_exe PathOfExile.exe"

; auto flask
global toggle_hp := 0   ; slot 1 & 2
global toggle_mana := 0 ; slot 3
global toggle_qs := 1   ; slot 4 & 5

; auto-click (ctrl + shift + <key>)
global autoClickR := "r"
global autoClickREnabled := 1
global autoClickRTimer := 50

global autoClickT := "t"
global autoClickTEnabled := 1
global autoClickTTimer := 7000

; enable leap + blink
; blink in "space" (middle mouse) and leap on "t"
; feature can be enabled with alt+space
global leapblinkEnabled := 0