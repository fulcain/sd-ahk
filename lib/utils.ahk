#NoEnv
SetKeyDelay, 1
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

;============================
; Utility Functions
;============================
SendCommand(command) {
    OldClipboard := ClipboardAll

    Clipboard := command
    ClipWait, 2

    ; Open FiveM chat
    SendEvent, {t down}
    Sleep, 50
    SendEvent, {t up}
    Sleep, 500

    ; Paste
    SendEvent, {Ctrl down}
    Sleep, 50
    SendEvent, {v down}
    Sleep, 50
    SendEvent, {v up}
    Sleep, 50
    SendEvent, {Ctrl up}
    Sleep, 500

    ; Enter
    SendEvent, {Enter down}
    Sleep, 50
    SendEvent, {Enter up}
    Sleep, 300

    Clipboard := OldClipboard
    VarSetCapacity(OldClipboard, 0)
}
