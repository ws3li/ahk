#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#IfWinActive, Path of Exile ahk_class POEWindowClass

   SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
   SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
   SetTitleMatchMode, 2

   #Include, globals.ahk

   MonitorPoints := Object() ; Object to store all the monitor points
   Splash("Running POE AHK", 2000)
   inBattleField()

   Profile := 1 ;default profile
   flask := new Flask()
   flask.StartAutoFlask()

   #include autoclick.ahk
   startAutoClick()

   ; ##################################################
   ; This is to Suspend and unspend keys
   ; ##################################################
   Suspended := 0
   !`::
      Suspend
      if (Suspended < 1){
         SplashTextOn ,150, 30, Splash, Script suspended
         Suspended := 1
         BlockInput MouseMoveOff
      } else {
         SplashTextOn ,150, 30, Splash, Script running
         Suspended := 0
      }
      Sleep 1000
      SplashTextOff
   return

   ; ##################################################
   ; This is to keep pressing key for not going AFK
   ; ##################################################
   afk := new AFK()
   ^!k::
      afk.Start()
   return

   ^!l::
      afk.Stop()
   return

   ; ######################################
   ; This is to auto reset map instance
   ; ######################################
   ; ^Numpad9::
   ;    MouseMove, 1392, 374
   ;    Click
   ;    Sleep, 400
   ;    Send {LControl Down}
   ;    MouseMove, 282, 280
   ;    Sleep, 100
   ;    Click
   ;    Send {LControl Up}
   ;    Sleep, 400
   ;    MouseMove, 480, 332
   ;    Sleep, 100
   ;    Click
   ; return

   ; ######################################
   ; TP Back to Hideout
   ; ######################################
   ; $!t::
   ;    Send, !t
   ;    Sleep, 100
   ;    MouseMove, (A_ScreenWidth / 2), (A_ScreenHeight / 2)
   ;    Sleep, 100
   ;    Click
   ; return

   ; Travel to hideout / menagerie / logout login
   ; ######################################

   ^h::
      Send {enter}
      Send, /hideout
      Send {enter}
   return

   ^g::
      Send {enter}
      Send, /menagerie
      Send {enter}
   return

   !$ESC::
      Send {enter}
      Send, /exit
      Send {enter}
      while(!colorExists(2323, 814, 2333, 824, 0x053084, 10, "relogmacro"))
      {
      }
      Send {enter}
   return

   ; ######################################
   ; Trade Message
   ; ######################################

   ^$1::
      Send ^{enter}
      Send, finishing a blight map. Can you wait for a minutes?
      Send {enter}
   return

   ^$2::
      Send ^{enter}
      Send, Sounds good. I will get back to you as soon as I am done.
      Send {enter}
   return

   ^$4::
      Send ^{enter}
      Send, Thank you and have a nice day
      Send {enter}

      Send {enter}
      Send, /kick %playerName%
      Send {enter}
      Send {enter}
      Send, /kick %playerName2%
      Send {enter}

      Send {enter}
      Send, /hideout
      Send {enter}
   return

   ; ######################################
   ; Map filters
   ; ######################################

   Numpad1::
      mg := """" . "t of no|% of e|ll ma|stea|ot r|ss re|s poi|% mor" . """"
      Send, ^f
      Send, %mg%
   return

   Numpad2::
      mg := """" . "rge on|ck sp|ind on|ss arm|th vul" . """"
      Send, ^f
      Send, %mg%
   return

   Numpad3::
      mg := """" . "ever|tiles$|poss|f ph|ra c|rke|na a|rby|sou" . """"
      Send, ^f
      Send, %mg%
   return

   Numpad4::
      mg := """" . "\d+% to al|eec|son$|ot g|efe|s rec|'v|mav|gen" . """"
      Send, ^f
      Send, %mg%
   return

   ; ######################################
   ; Helper Functions
   ; ######################################

   closeProgress(n)
   {
      Progress, %n%: off
   }

   message(msg, winNum := 0, timer := 0)
   {
      mx := 1
      my := 1420

      ; m {1, 2, 3} locked, rotation between 4-10
      static m := 4
      progressnum := winNum

      if (!progressnum){
         if (m == 10){
            m = 4
         }else {
            m++
         }
         progressnum = %m%
      }

      Progress, %progressnum%: cw465155 CTFFFFFF W200 ZX1 ZY1 x%mx% y%my% m b fs10 zh0, %msg%, , , Arial
      if (timer){
         closeProgress_fn := Func("closeProgress").bind(progressnum)
         SetTimer, % closeProgress_fn, -%timer%
      }
   }

   ; ######################################
   ; Get Mouse position
   ; ######################################
   !c::
      MouseGetPos, xpos, ypos
      PixelGetColor, mcol, xpos, ypos
      position := "X-l= " . xpos-5 . ", Y-t= " . ypos-5 . ", X-r= " . xpos+5 . ", Y-b= " . ypos+5 . ", hexColor= " . mcol . ", readableColor= " . BGRToRGB(mcol)

      r1 := Rect(xpos-5, ypos-5, 10, 10, BGRToRGB(mcol))
      cleanrect_fn := Func("CleanRect").bind(r1)
      SetTimer, % cleanrect_fn, 1000

      Clipboard := position
   return

   ; Get All recorded points
   !l::
      DrawAllPoints()
   return

   ; ######################################
   ; FLASK helper
   ; ######################################

   FlipBlueAndRed(c) ; takes RGB or BGR and swaps the R and B
   {
      return (c&255)<<16 | (c&65280) | (c>>16)
   }

   DecToHex(dec)
   {
      oldfrmt := A_FormatInteger
      hex := dec
      SetFormat, IntegerFast, hex
      hex += 0
      hex .= ""
      SetFormat, IntegerFast, %oldfrmt%
      return hex
   }

   BGRToRGB(c)
   {
      rgbC := DecToHex(FlipBlueAndRed(c))
      StringTrimLeft, rgbC, rgbC, 2
      return rgbC
   }

   global battlefield := 0
   inBattleField()
   {
      global battlefield
      found := isBattleFieldDetected()

      if (found){
         battlefield = 1
      }else {
         battlefield = 0
      }
      SetTimer, inBattleField, 300
   }

   isBattleFieldDetected()
   {
      global rightButtonIconYPoint

      Xpoint := 2181
      horizontalSpacing := 10
      Ypoint := rightButtonIconYPoint
      rightButtonColor := 0x3C6EB9 ; Color

      buttonEnabledColor := colorExists(Xpoint, Ypoint, Xpoint + horizontalSpacing, Ypoint + horizontalSpacing, rightButtonColor, 50, "rightbutton")
      detected := buttonEnabledColor

      static gm := 0
      lockedwinnum := 1
      if (!detected)
      {
         if (!gm){
            gm = 1
            message("Character not in battle field", lockedwinnum)
         }
      } else {
         if (gm){
            gm = 0
            closeProgress(lockedwinnum)
         }
      }

      return detected
   }

   ; ######################################
   ; Auto Flask
   ; ######################################
   !q::
      flask.ToggleQS()
   return

   !m::
      flask.ToggleMana()
   return

   !h::
      flask.ToggleHP()
   return

   ; ######################################
   ; Auto click for quick unload
   ; ######################################
   AutoClick()
   {
      if (GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P"))
      {
         while(GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P"))
         {
            SendInput, ^+{Click}
            Sleep, 30
         }
      }
      else if (GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P"))
      {
         while(GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P"))
         {
            SendInput, ^{Click}
            Sleep, 30
         }
      }
      else if (GetKeyState("LButton", "P") && GetKeyState("Shift", "P"))
      {
         while(GetKeyState("LButton", "P") && GetKeyState("Shift", "P"))
         {
            SendInput, +{Click}
            Sleep, 100
         }
      }
   }

   ^LButton::
      SendInput, ^{Click}
      SetTimer, AutoClick, -200
   return

   ^+LButton::
      SendInput, ^+{Click}
      SetTimer, AutoClick, -200
   return

   +LButton::
      SendInput, +{Click}
      SetTimer, AutoClick, -200
   return

   ; ######################################
   ; Auto gem level
   ; ######################################
   gem := new Gem()
   !s::
      gem.Run()
   return

   ; ######################################
   ; Mouse Click 5
   ; ######################################
   XButton2::
      Send, i
   return

   ; ######################################
   ; Auto click feature
   ; ######################################
   global autoClickREnabled
   !+r::
      autoClickREnabled := !autoClickREnabled

      state := autoClickREnabled ? "enabled" : "disabled"
      Splash("auto click R: " . state)
   return

   global autoClickTEnabled
   !+t::
      autoClickTEnabled := !autoClickTEnabled

      state := autoClickTEnabled ? "enabled" : "disabled"
      Splash("auto click T: " . state)
   return

   ; ######################################
   ; Leap Blink
   ; ######################################
   global leapblinkEnabled
   !+space::
      leapblinkEnabled := !leapblinkEnabled

      state := leapblinkEnabled ? "enabled" : "disabled"
      Splash("leap blink: " . state)
   return

   space::
      if (leapblinkEnabled && battlefield)
      {
         Send, t
         Sleep, 600
         SendEvent, {Space}
      }
      else
      {
         SendEvent, {Space}
      }
   return

   ; ######################################
   ; Reload this script
   ; ######################################

   ^!r::
      Reload
   return

   ; ######################################
   ; Reload PoeAPIKit
   ; ######################################

   ; !r::
   ;    DetectHiddenWindows, On
   ;    IfWinNotExist, PoEapikit.ahk
   ;       Splash("Running poe kit", 2000)
   ;    Run, "E:\poe\PoEapikit-1.10.1\PoEapikit.ahk"
   ; return

   ; ######################################
   ; Gem Swap
   ; ######################################
   ; !a::
   ;    Send, i
   ;    Send, x
   ;    Click, 2385 370 Right
   ;    Click, 2147 470
   ;    Click, 2385 370
   ;    Send, x
   ;    Send, i
   ; return

   ; ######################################
   ; Setup Profiles
   ; ######################################

   $!1::
      Profile := 1
      Splash("Build: Minion lvl")
   return

   $!2::
      Profile := 2
      Splash("Splash, Build: Minion lvl + Smoke Mine")
   return

   $!3::
      Profile := 3
      Splash("Splash, Build: Aura Minion")
   return

; ##################
; Minion Leveling
; ##################
#If Profile = 1

   [::
      Send, t
   return

   ]::
      Send, t
   return

; ##################
; Minion Leveling + Smoke Mine
; ##################
#If Profile = 2

   [::
      Send, 1234
   return

   ]::
      Send, t
   return

   $Space::
      Send t
      Sleep, 400
      Send d
      Sleep, 250
      Send {space}
   return

; ##################
; Minion Aura Stacker
; ##################
#If Profile = 3

   [::
      Send, 1234
   return

   ]::
      Send, qwert
   return

   !a::
      aura := new Aura()
      aura.Activate()
   return

   #include helper.ahk
   #include aura.ahk
   #include afk.ahk
   #include gem.ahk
   #include flask.ahk