; ════════════════════════════════════════════════════════════════════════════
;  lib/utils.ahk · shared helpers                            AutoHotkey v2
; ════════════════════════════════════════════════════════════════════════════

; ─── game focus ────────────────────────────────────────────────────────────
;  What counts as "the game", tried in order, first match wins. The FiveM
;  console window is skipped on purpose. Add your own class or title here if
;  you ever run a different client.
GAME_WINDOWS := ["ahk_class grcWindow", "ahk_exe FiveM.exe", "ahk_exe FiveM_GTAProcess.exe", "FiveM"]

; Brings FiveM to the foreground so the keys land in the game even when the
; player was tabbed out to the desktop or another app. Returns true when a
; game window is focused, false when there is nothing to focus.
FocusGame() {
    for pattern in GAME_WINDOWS {
        for hwnd in WinGetList(pattern) {
            if InStr(WinGetTitle("ahk_id " hwnd), "console")
                continue                       ; the log window, not the game
            if (WinGetMinMax("ahk_id " hwnd) = -1)
                WinRestore("ahk_id " hwnd)     ; came back from minimised
            if WinActive("ahk_id " hwnd)
                return true

            WinActivate("ahk_id " hwnd)
            if WaitActive(hwnd, 500)
                return Settle()

            ; Windows sometimes refuses to hand focus over (a fullscreen game
            ; that has only just been tabbed out of), so push it a second time.
            DllCall("user32\SetForegroundWindow", "Ptr", hwnd)
            DllCall("user32\BringWindowToTop", "Ptr", hwnd)
            if WaitActive(hwnd, 600)
                return Settle()
        }
    }
    return false
}

WaitActive(hwnd, ms) {
    deadline := A_TickCount + ms
    loop {
        if WinActive("ahk_id " hwnd)
            return true
        if (A_TickCount >= deadline)
            return false
        Sleep 20
    }
}

; Small pause so the game is ready for the first key after an alt-tab.
Settle() {
    Sleep 80
    return true
}

; ─── SendCommand ───────────────────────────────────────────────────────────
;  Opens the FiveM chat, pastes `command` and presses Enter.
;  The clipboard is saved first and restored afterwards, so whatever the
;  player had copied is never clobbered.
;
;  The three delays below are the only knobs worth touching:
;    gap   – press/release gap for a single key
;    wait  – time for the chat box to open / for the paste to land
;    after – breather after Enter before the next command is sent
SendCommand(command) {
    static gap := 50
    static wait := 500
    static after := 300

    ; Never type into whatever happens to be focused – make sure the game is
    ; in front first, and send nothing at all if it is not running.
    if !FocusGame()
        return false

    ; Hotkey/event threads start with the default key delay, so set it here.
    SetKeyDelay(1)

    saved := ClipboardAll()
    try {
        A_Clipboard := command
        ClipWait(2)

        ; open the chat box
        SendEvent "{t down}"
        Sleep gap
        SendEvent "{t up}"
        Sleep wait

        ; paste the command
        SendEvent "{Ctrl down}"
        Sleep gap
        SendEvent "{v down}"
        Sleep gap
        SendEvent "{v up}"
        Sleep gap
        SendEvent "{Ctrl up}"
        Sleep wait

        ; send it
        SendEvent "{Enter down}"
        Sleep gap
        SendEvent "{Enter up}"
        Sleep after
    }

    ; Always hand the clipboard back, even if something above went wrong.
    A_Clipboard := saved
    return true
}
