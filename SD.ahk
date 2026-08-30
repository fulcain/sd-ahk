#NoEnv
SetKeyDelay, 1
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

#Include components\atc.ahk
#Include lib\utils.ahk

; Global variables for GUI toggling
global g_GuiHwnd := ""
global g_MenuStack := []
global g_CurrentItems := []
global g_PathStack := []
global Breadcrumb
global Aircraft := "AIRSD-7"
global CurrentCallsign := ""

;============================
; Toggle GUI with Numpad8
;============================
Numpad8::
if (g_GuiHwnd && WinExist("ahk_id " g_GuiHwnd)) {
Gui, MainMenu:Hide
} else {
g_MenuStack := []
g_PathStack := []
PushRootMenu()
ShowMenuGUI()
GuiControl, MainMenu:, Breadcrumb, Main Menu
}
return

;============================
; Build and show the GUI
;============================
ShowMenuGUI() {
global g_GuiHwnd, g_CurrentItems, Breadcrumb, Aircraft, CurrentCallsign
CurrentCallsign := "Active callsign: " Aircraft

Gui, MainMenu:Destroy
Gui, MainMenu:+AlwaysOnTop -Caption +ToolWindow
Gui, MainMenu:Font, s12 bold, Segoe UI
Gui, MainMenu:Add, Text, w300 Center, MD - SD

Gui, MainMenu:Font, s8 italic norm, Segoe UI
Gui, MainMenu:Add, Text, w300 Center vBreadcrumb, Main Menu
Gui, MainMenu:Font, c000000 s9 bold, Segoe UI
Gui, MainMenu:Add, Text, y+8 w300 Center vCurrentCallsign, %CurrentCallsign%

Gui, MainMenu:Font, s10 norm, Segoe UI
Gui, MainMenu:Add, ListBox, w300 r15 vSelectedItem gListBoxDoubleClick, % BuildItemList()

Gui, MainMenu:Add, Button, x10 y+10 w70 gSelectItem, Select
Gui, MainMenu:Add, Button, x+5 w70 gGoBack, Back
Gui, MainMenu:Add, Button, x+5 w70 gGoHome, Home
Gui, MainMenu:Add, Button, x+5 w70 gCloseMenu, Close

Gui, MainMenu:Show, AutoSize Center, SD Menu
g_GuiHwnd := WinExist()
}

BuildItemList() {
global g_CurrentItems

str := ""

for i, item in g_CurrentItems {
    name := item.name

    if (item.submenu)
        name .= "  +"

    str .= name . "|"
}

return RTrim(str, "|")
}

ListBoxDoubleClick:
Gui, MainMenu:Submit, NoHide

if (SelectedItem != "")
Gosub, SelectItem

return

SelectItem:
Gui, MainMenu:Submit, NoHide

if (SelectedItem = "")
return

for i, item in g_CurrentItems {
displayName := item.name . (item.submenu ? "  +" : "")

if (displayName = SelectedItem) {

    if (item.name = "")
        break

    if (item.submenu) {
        g_MenuStack.Push(g_CurrentItems)
        g_PathStack.Push(item.name)
        g_CurrentItems := item.submenu

        GuiControl,, SelectedItem, % "|" BuildItemList()
        GuiControl, Choose, SelectedItem, 1
        UpdateBreadcrumb()

    } else {
        fn := item.action

        if (fn != "" && IsFunc(fn)) {
            Gui, MainMenu:Hide
            %fn%()
        } else if (fn = "CloseMenu") {
            Gui, MainMenu:Hide
        } else {
            MsgBox, Function "%fn%" not found.
        }
    }

    break
}
}

return

GoBack:
if (g_MenuStack.Length() > 0) {
g_CurrentItems := g_MenuStack.Pop()
g_PathStack.Pop()

GuiControl,, SelectedItem, % "|" BuildItemList()
GuiControl, Choose, SelectedItem, 1

UpdateBreadcrumb()
}

return

GoHome:
g_MenuStack := []
g_PathStack := []

PushRootMenu()

GuiControl,, SelectedItem, % "|" BuildItemList()
GuiControl, Choose, SelectedItem, 1
GuiControl, MainMenu:, Breadcrumb, Main Menu

return

CloseMenu:
Gui, MainMenu:Hide
return

UpdateBreadcrumb() {
global g_PathStack, Breadcrumb

path := "Main Menu"

for i, name in g_PathStack
    path .= " > " . name

GuiControl, MainMenu:, Breadcrumb, % path
}

;============================
; Menu helpers
;============================
AddItem(name, action) {
global g_CurrentItems

if (IsObject(action))
    g_CurrentItems.Push({name: name, submenu: action})
else
    g_CurrentItems.Push({name: name, submenu: false, action: action})
}

AddItemLeaf(ByRef arr, name, action) {
arr.Push({name: name, submenu: false, action: action})
}

;============================
; Root Menu
;============================
PushRootMenu() {
global g_CurrentItems

g_CurrentItems := []

AddItem("ATC", BuildATCMenu())
AddItem("Set Callsign", "SetAircraft")
AddItem("Start watch radio + create unit", "StartServiceRadio")
AddItem("End watch radio + disband unit", "EndServiceRadio")
AddItem("Bodycam on", "BodycamOn")
AddItem("Miranda", "Miranda")
AddItem("[X] Close Menu", "CloseMenu")
}

;============================
; ATC Menu
;============================
BuildATCMenu() {
items := []

;=========================================================
; ASCENDING - SANDY
;=========================================================
AddItemLeaf(items, "Ascending - Sandy - Prio A", "ATCAscendingFromSandyPrioA")
AddItemLeaf(items, "Ascending - Sandy - Prio B", "ATCAscendingFromSandyPrioB")
AddItemLeaf(items, "Ascending - Sandy - Prio C", "ATCAscendingFromSandyPrioC")
AddItemLeaf(items, "Ascending - Sandy - Prio O", "ATCAscendingFromSandyPrioO")

;=========================================================
; ASCENDING - FORT ZANCUDO
;=========================================================
AddItemLeaf(items, "Ascending - Fort Zancudo - Prio A", "ATCAscendingFromFortZancudoPrioA")
AddItemLeaf(items, "Ascending - Fort Zancudo - Prio B", "ATCAscendingFromFortZancudoPrioB")
AddItemLeaf(items, "Ascending - Fort Zancudo - Prio C", "ATCAscendingFromFortZancudoPrioC")
AddItemLeaf(items, "Ascending - Fort Zancudo - Prio O", "ATCAscendingFromFortZancudoPrioO")

;=========================================================
; ASCENDING - DAVIS STATION
;=========================================================
AddItemLeaf(items, "Ascending - Davis Station - Prio A", "ATCAscendingFromDavisStationPrioA")
AddItemLeaf(items, "Ascending - Davis Station - Prio B", "ATCAscendingFromDavisStationPrioB")
AddItemLeaf(items, "Ascending - Davis Station - Prio C", "ATCAscendingFromDavisStationPrioC")
AddItemLeaf(items, "Ascending - Davis Station - Prio O", "ATCAscendingFromDavisStationPrioO")

;=========================================================
; ASCENDING - PALETO PAD
;=========================================================
AddItemLeaf(items, "Ascending - Paleto Pad - Prio A", "ATCAscendingFromPaletoPadPrioA")
AddItemLeaf(items, "Ascending - Paleto Pad - Prio B", "ATCAscendingFromPaletoPadPrioB")
AddItemLeaf(items, "Ascending - Paleto Pad - Prio C", "ATCAscendingFromPaletoPadPrioC")
AddItemLeaf(items, "Ascending - Paleto Pad - Prio O", "ATCAscendingFromPaletoPadPrioO")

;=========================================================
; SEPARATOR
;=========================================================
items.Push({name: "", submenu: false, action: ""})

;=========================================================
; DESCENDING - NO PRIORITY
;=========================================================
AddItemLeaf(items, "Descending - Sandy", "ATCDescendingToSandy")
AddItemLeaf(items, "Descending - Fort Zancudo", "ATCDescendingToFortZancudo")
AddItemLeaf(items, "Descending - Davis Station", "ATCDescendingToDavisStation")
AddItemLeaf(items, "Descending - Paleto Pad", "ATCDescendingToPaletoPad")

return items
}

;============================
; Set Callsign
;============================
SetAircraft() {
global Aircraft, g_GuiHwnd

Gui, Callsign:Destroy
Gui, Callsign:+AlwaysOnTop +OwnerMainMenu
Gui, Callsign:Margin, 18, 16
Gui, Callsign:Color, FFFFFF
Gui, Callsign:Font, s11 bold, Segoe UI
Gui, Callsign:Add, Text, w320, Set active callsign
Gui, Callsign:Font, s9 norm, Segoe UI
Gui, Callsign:Add, Text, y+8 w320, Enter the aircraft or unit callsign:
Gui, Callsign:Add, Edit, y+8 w320 h25 vNewAircraft, %Aircraft%
Gui, Callsign:Add, Button, y+14 w95 h28 gCallsignSave Default, Save
Gui, Callsign:Add, Button, x+8 w95 h28 gCallsignCancel, Cancel
Gui, Callsign:Show, AutoSize Center, Set Callsign
GuiControl, Callsign:Focus, NewAircraft
Send, ^a
return
}

CallsignSave:
global Aircraft, NewAircraft, g_GuiHwnd, CurrentCallsign
Gui, Callsign:Submit, NoHide
NewAircraft := Trim(NewAircraft)
if (NewAircraft = "") {
    MsgBox, 48, Invalid Callsign, Please enter a callsign.
    GuiControl, Callsign:Focus, NewAircraft
    return
}
Aircraft := NewAircraft
CurrentCallsign := "Active callsign: " Aircraft
if (g_GuiHwnd && WinExist("ahk_id " g_GuiHwnd))
    GuiControl, MainMenu:, CurrentCallsign, %CurrentCallsign%
Gui, Callsign:Destroy
MsgBox, 64, Callsign Updated, Callsign set to: %Aircraft%
return

CallsignCancel:
global Aircraft
Gui, Callsign:Destroy
return

;============================
; Existing non-ATC functions
;============================
StartServiceRadio() {
SendCommand("/rlow 29444 starting watch under 242G")
SendCommand("/createunit 242G")
}

EndServiceRadio() {
SendCommand("/r 29944 end of watch")
SendCommand("/disbandunit")
SendCommand("/leaveunit")
}

BodycamOn() {
SendCommand("/melow grabs his bodycam from the locker and attaches the bodycam on his chest mount after turning it on")
SendCommand("/dolow the camera would turn on indicating that it's recording")
SendCommand("/time")
Send, {F1}
}

Miranda() {
SendCommand("You have the right to remain silent")
SendCommand("Anything you say can and will be used against you in a court of law")
SendCommand("You have the right to an Attorney to be present during legal questioning")
SendCommand("If you request one, one will be appointed for you free of charge")
SendCommand("Do you understand these rights?")
}

;============================
; PAUSE / STOP HOTKEY
; Ctrl + Numpad8
;============================
^Numpad8::Pause, Toggle