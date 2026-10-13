#Requires AutoHotkey v2.0
#SingleInstance Force

; ════════════════════════════════════════════════════════════════════════════
;  SD · Sheriff dispatch menu (FiveM SD)                     AutoHotkey v2
; ────────────────────────────────────────────────────────────────────────────
;  Ctrl + 8          open / close the menu
;  Ctrl+Numpad8     pause / resume the script's hotkeys
;
;  Inside the menu
;    type           search every call in the whole menu (works at any depth)
;    Up / Down      move through the list
;    Enter          open a submenu, or run the highlighted command
;    Backspace      back one level (only when the search box is empty)
;    Esc            close the menu
;    drag the top   move the window around, it reopens where you left it
;
;  "Set callsign" swaps the list for a one-line editor; Enter saves it and
;  every ATC call after that is sent with the new callsign.
; ════════════════════════════════════════════════════════════════════════════

#Include components\atc.ahk
#Include lib\utils.ahk

; The callsign every ATC call in components\atc.ahk is sent with. It is the
; only source of truth – the menu shows it and "Set callsign" changes it.
Aircraft := "AIRSD-7"

; ─── theme ─────────────────────────────────────────────────────────────────
T := {
    face:     "Segoe UI",
    bg:       "0F0F14",   ; window
    line:     "25252E",   ; separators
    field:    "1B1B23",   ; search field / inputs
    listBg:   "121218",   ; list background
    text:     "E8E8F0",   ; primary text
    btn:      "C9C9D6",   ; button text
    muted:    "8C8CA0",   ; secondary text
    dim:      "63637A",   ; de-emphasised text
    accent:   "D9A441",   ; sheriff gold
    accentOn: "121218",   ; text on an accent button
    accentHot:"E8B75C",   ; accent button on hover
    surface:  "22222B",   ; button fill
    hover:    "33333F",   ; button fill on hover
    warn:     "E5484D",   ; "callsign can't be empty"
}

; ─── state ─────────────────────────────────────────────────────────────────
G := {
    w: 420, h: 556,

    root: [],            ; the whole menu tree
    index: [],           ; flat copy of every node, for the search
    path: [],            ; nodes we are currently inside
    query: "",
    rows: [],            ; what the list is showing: {label, node}
    count: 0,            ; real row count (excludes the "no matches" filler)
    sel: 0,
    last: "",            ; {label, node} of the last command that was run
    open: false,
    paused: false,
    editing: false,      ; the callsign editor is on screen
    pos: "",
    hover: [],

    gui: "", list: "", search: "", hint: "", crumb: "", status: "", footer: "",
    back: "", home: "", badge: "", title: "", sub: "",
    editLabel: "", editBox: "", editHint: "", save: "", cancel: "",
}

; ─── start up ──────────────────────────────────────────────────────────────
SetWorkingDir A_ScriptDir
SetKeyDelay 1
SetTitleMatchMode 2          ; "FiveM" matches the window wherever the title sits
BuildTree()
BuildGui()

; ─── hotkeys ───────────────────────────────────────────────────────────────
^8::ToggleMenu()
^Numpad8::TogglePause()

#HotIf MenuIsActive() && G.editing
Enter::SaveCallsignEdit()
Esc::CancelCallsignEdit()
#HotIf

#HotIf MenuIsActive() && !G.editing
Up::MoveSelection(-1)
Down::MoveSelection(1)
PgUp::MoveSelection(-10)
PgDn::MoveSelection(10)
Enter::RunSelected()
Esc::HideMenu()
#HotIf

; Only taken over while the search box is empty, so it still deletes text
; normally the moment you start typing a query.
#HotIf MenuIsActive() && !G.editing && SearchIsEmpty()
Backspace::GoBack()
#HotIf

; ════════════════════════════════════════════════════════════════════════════
;  Menu tree
;  A plain nested structure: nodes with `children` are submenus, nodes with an
;  `action` are commands. Normalize() checks every leaf really has a target,
;  so a typo here fails loudly at start-up instead of at 3am in a pursuit.
; ════════════════════════════════════════════════════════════════════════════
MenuTree() {
    return [
        {name: "ATC", children: [
            {name: "Ascend · 1,000 ft", children: [
                {name: "Sandy · Prio A", action: ATCAscendingFromSandyPrioA},
                {name: "Sandy · Prio B", action: ATCAscendingFromSandyPrioB},
                {name: "Sandy · Prio C", action: ATCAscendingFromSandyPrioC},
                {name: "Sandy · Prio O", action: ATCAscendingFromSandyPrioO},
                {name: "Fort Zancudo · Prio A", action: ATCAscendingFromFortZancudoPrioA},
                {name: "Fort Zancudo · Prio B", action: ATCAscendingFromFortZancudoPrioB},
                {name: "Fort Zancudo · Prio C", action: ATCAscendingFromFortZancudoPrioC},
                {name: "Fort Zancudo · Prio O", action: ATCAscendingFromFortZancudoPrioO},
                {name: "Davis Station · Prio A", action: ATCAscendingFromDavisStationPrioA},
                {name: "Davis Station · Prio B", action: ATCAscendingFromDavisStationPrioB},
                {name: "Davis Station · Prio C", action: ATCAscendingFromDavisStationPrioC},
                {name: "Davis Station · Prio O", action: ATCAscendingFromDavisStationPrioO},
                {name: "Paleto Pad · Prio A", action: ATCAscendingFromPaletoPadPrioA},
                {name: "Paleto Pad · Prio B", action: ATCAscendingFromPaletoPadPrioB},
                {name: "Paleto Pad · Prio C", action: ATCAscendingFromPaletoPadPrioC},
                {name: "Paleto Pad · Prio O", action: ATCAscendingFromPaletoPadPrioO},
            ]},
            {name: "Descend", children: [
                {name: "Sandy Helipad", action: ATCDescendingToSandy},
                {name: "Fort Zancudo", action: ATCDescendingToFortZancudo},
                {name: "Davis Station", action: ATCDescendingToDavisStation},
                {name: "Paleto Pad", action: ATCDescendingToPaletoPad},
            ]},
        ]},
        {name: "Set callsign", kind: "callsign"},
        {name: "Start watch radio + create unit", action: StartServiceRadio},
        {name: "End watch radio + disband unit", action: EndServiceRadio},
        {name: "Bodycam on", action: BodycamOn},
        {name: "Miranda", action: Miranda},
        {name: "Close menu", kind: "close"},
    ]
}

BuildTree() {
    global G
    G.root := MenuTree()
    G.index := []
    Normalize(G.root, [], G.index)
}

; Fills in the fields the UI relies on, so nothing is ever read off a node
; that does not have it.
Normalize(nodes, parents, index) {
    for node in nodes {
        if !node.HasProp("kind")
            node.kind := ""
        node.parents := parents
        node.pathText := JoinPath(parents)

        if (node.HasProp("children")) {
            node.action := ""
            index.Push({node: node, name: node.name, path: node.pathText})
            Normalize(node.children, AppendPath(parents, node.name), index)
        } else {
            if (!node.HasProp("action")) {
                if (node.kind = "")
                    throw ValueError('Menu item "' node.name '" has no action')
                node.action := ""
            }
            node.children := []
            index.Push({node: node, name: node.name, path: node.pathText})
        }
    }
}

JoinPath(parts) {
    text := ""
    for i, part in parts {
        if (i > 1)
            text .= " › "
        text .= part
    }
    return text
}

AppendPath(parts, name) {
    copy := parts.Clone()
    copy.Push(name)
    return copy
}

; ════════════════════════════════════════════════════════════════════════════
;  Window
; ════════════════════════════════════════════════════════════════════════════
BuildGui() {
    global G, T, Aircraft

    win := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20000", "SD")
    win.BackColor := T.bg
    RoundCorners(win.Hwnd)

    ; ── title band ─────────────────────────────────────────────────────────
    win.SetFont("s14 bold", T.face)
    G.title := win.AddText("x16 y9 w180 h24 c" T.accent, "SD")
    win.SetFont("s8", T.face)
    G.sub := win.AddText("x17 y30 w220 h16 c" T.muted, CallSignText())

    G.badge := win.AddText("x286 y12 w64 h20 Center c" T.accentOn " Background" T.accent " Hidden", "PAUSED")
    win.SetFont("s12", T.face)
    G.close := win.AddText("x378 y10 w26 h24 Center c" T.btn " Background" T.surface, "×")

    win.AddText("x0 y48 w" G.w " h1 Background" T.line, "")
    win.AddText("x0 y48 w52 h2 Background" T.accent, "")

    ; ── breadcrumb + navigation ────────────────────────────────────────────
    win.SetFont("s9", T.face)
    G.crumb := win.AddText("x16 y60 w260 h18 c" T.muted, "Home")
    win.SetFont("s8", T.face)
    G.home := win.AddText("x284 y58 w54 h22 Center c" T.btn " Background" T.surface, "Home")
    G.back := win.AddText("x346 y58 w58 h22 Center c" T.btn " Background" T.surface, "‹  Back")

    ; ── search ─────────────────────────────────────────────────────────────
    win.SetFont("s10", T.face)
    G.search := win.AddEdit("x16 y88 w388 h28 -E0x200 Background" T.field " c" T.text, "")
    G.hint := win.AddText("x26 y94 w300 h18 c" T.dim " Background" T.field, "Search ATC, callsign and unit commands…")

    ; ── list ───────────────────────────────────────────────────────────────
    win.SetFont("s11", T.face)
    G.list := win.AddListView("x16 y128 w388 h376 -Hdr -Multi +LV0x20 +LV0x10000 -E0x200 Background" T.listBg " c" T.text, [""])
    G.list.ModifyCol(1, 366)
    DarkScrollbar(G.list.Hwnd)

    ; ── callsign editor (hidden until "Set callsign" is picked) ────────────
    win.SetFont("s8", T.face)
    G.editLabel := win.AddText("x16 y146 w388 h16 c" T.dim " Hidden", "ACTIVE CALLSIGN")
    win.SetFont("s13", T.face)
    G.editBox := win.AddEdit("x16 y168 w388 h34 -E0x200 Background" T.field " c" T.text " Hidden", Aircraft)
    win.SetFont("s8", T.face)
    G.editHint := win.AddText("x17 y210 w380 h18 c" T.muted " Hidden", "Enter to save   ·   Esc to cancel")
    win.SetFont("s10", T.face)
    G.save := win.AddText("x16 y252 w120 h30 Center c" T.accentOn " Background" T.accent " Hidden", "Save")
    G.cancel := win.AddText("x144 y252 w120 h30 Center c" T.btn " Background" T.surface " Hidden", "Cancel")

    ; ── footer ─────────────────────────────────────────────────────────────
    win.AddText("x0 y514 w" G.w " h1 Background" T.line, "")
    win.SetFont("s8", T.face)
    G.footer := win.AddText("x16 y524 w260 h18 c" T.dim, "↑↓ Move   ·   Enter Run   ·   Bksp Back   ·   Esc Close")
    G.status := win.AddText("x224 y524 w180 h18 Right c" T.muted, "")

    ; ── behaviour ──────────────────────────────────────────────────────────
    G.close.OnEvent("Click", (*) => HideMenu())
    G.home.OnEvent("Click", (*) => GoHome())
    G.back.OnEvent("Click", (*) => GoBack())
    G.hint.OnEvent("Click", (*) => FocusSearch())
    G.search.OnEvent("Change", (*) => OnSearchChanged())
    G.list.OnEvent("ItemFocus", OnListFocus)
    G.list.OnEvent("DoubleClick", OnListDoubleClick)
    G.save.OnEvent("Click", (*) => SaveCallsignEdit())
    G.cancel.OnEvent("Click", (*) => CancelCallsignEdit())
    win.OnEvent("Escape", (*) => (G.editing ? CancelCallsignEdit() : HideMenu()))
    win.OnEvent("Close", (*) => MarkClosed())

    RegisterHover(G.close, T.surface, T.hover)
    RegisterHover(G.home, T.surface, T.hover)
    RegisterHover(G.back, T.surface, T.hover)
    RegisterHover(G.save, T.accent, T.accentHot)
    RegisterHover(G.cancel, T.surface, T.hover)

    OnMessage(0x0200, OnMouseMove)       ; WM_MOUSEMOVE
    OnMessage(0x0201, OnLButtonDown)     ; WM_LBUTTONDOWN – drag the title band

    G.gui := win
}

; ════════════════════════════════════════════════════════════════════════════
;  Showing / hiding
; ════════════════════════════════════════════════════════════════════════════
ToggleMenu() {
    global G
    if (G.paused) {
        Tip("SD hotkeys are paused  ·  Ctrl+Numpad8 to resume")
        return
    }
    if (G.open)
        HideMenu()
    else
        ShowMenu()
}

ShowMenu() {
    global G
    G.path := []
    ClearSearch()
    RefreshCallsign()
    UpdateCrumb()
    Render()

    G.open := true
    if (IsObject(G.pos))
        G.gui.Show("w" G.w " h" G.h " x" G.pos.x " y" G.pos.y)
    else
        G.gui.Show("w" G.w " h" G.h " Center")
    if !WinActive("ahk_id " G.gui.Hwnd)
        WinActivate("ahk_id " G.gui.Hwnd)
    FocusSearch()
}

HideMenu() {
    global G
    if !G.open
        return
    if (G.editing)
        StopCallsignEdit()
    try {
        G.gui.GetPos(&x, &y)
        G.pos := {x: x, y: y}
    }
    G.gui.Hide()
    G.open := false
}

MarkClosed() {
    global G
    G.open := false
}

MenuIsActive() {
    global G
    return G.open && WinActive("ahk_id " G.gui.Hwnd)
}

; Used by the Backspace hotkey: while a query is typed the key belongs to the
; search box, only an empty box turns it into "go back".
SearchIsEmpty() {
    global G
    return G.search.Value = ""
}

TogglePause() {
    global G
    G.paused := !G.paused
    G.badge.Visible := G.paused
    if (G.paused && G.open)
        HideMenu()
    Tip(G.paused ? "SD hotkeys paused" : "SD hotkeys active")
}

FocusSearch() {
    global G
    G.search.Focus()
}

; ════════════════════════════════════════════════════════════════════════════
;  Callsign
; ════════════════════════════════════════════════════════════════════════════
CallSignText() {
    global Aircraft
    return "CALLSIGN  ·  " Aircraft
}

RefreshCallsign() {
    global G
    G.sub.Text := CallSignText()
    G.editBox.Value := Aircraft
}

; Swaps the list out for a single-line editor in the same window.
EnterCallsignEdit() {
    global G
    G.editing := true
    G.crumb.Text := "Home   ›   Set callsign"

    G.list.Visible := false
    G.search.Visible := false
    G.hint.Visible := false
    G.footer.Text := "Type a callsign   ·   Enter Save   ·   Esc Cancel"
    G.status.Text := "current  ·  " Aircraft

    for ctrl in [G.editLabel, G.editBox, G.editHint, G.save, G.cancel]
        ctrl.Visible := true

    G.editBox.Value := Aircraft
    G.editBox.Focus()
    ; select the whole field (EM_SETSEL) – no synthetic keys, so this cannot
    ; land in the game if the window is not focused yet.
    SendMessage(0x00B1, 0, -1, , "ahk_id " G.editBox.Hwnd)
}

; Puts the list back exactly as it was.
StopCallsignEdit() {
    global G
    G.editing := false

    for ctrl in [G.editLabel, G.editBox, G.editHint, G.save, G.cancel]
        ctrl.Visible := false

    G.list.Visible := true
    G.search.Visible := true
    G.hint.Visible := (G.search.Value = "")
    G.footer.Text := "↑↓ Move   ·   Enter Run   ·   Bksp Back   ·   Esc Close"
    G.editHint.Text := "Enter to save   ·   Esc to cancel"

    UpdateCrumb()
    Render()
    FocusSearch()
}

SaveCallsignEdit() {
    global G, T, Aircraft
    value := Trim(G.editBox.Value)
    if (value = "") {
        G.editHint.Text := "A callsign cannot be empty   ·   Esc to cancel"
        G.editHint.Opt("+c" T.warn)
        G.editBox.Focus()
        return
    }
    Aircraft := value

    G.editHint.Opt("+c" T.muted)
    StopCallsignEdit()
    RefreshCallsign()
    Tip("Callsign set to " Aircraft)
}

CancelCallsignEdit() {
    global G
    StopCallsignEdit()
    RefreshCallsign()
}

; ════════════════════════════════════════════════════════════════════════════
;  List rendering
; ════════════════════════════════════════════════════════════════════════════
Render() {
    global G

    rows := []
    if (G.query = "")
        rows := BrowseRows()
    else
        rows := SearchRows(G.query)

    G.count := rows.Length
    if (rows.Length = 0)
        rows.Push({label: "No matches  ·  try fewer words", node: BlankNode()})

    list := G.list
    list.Opt("-Redraw")
    list.Delete()
    for row in rows
        list.Add(, row.label)
    list.ModifyCol(1, 366)
    list.Opt("+Redraw")

    G.rows := rows
    G.sel := 1
    list.Modify(1, "Select Focus Vis")

    UpdateStatus()
}

BrowseRows() {
    global G
    rows := []

    if (G.path.Length = 0 && IsObject(G.last))
        rows.Push({label: "↺   Repeat · " G.last.label, node: G.last.node})

    children := (G.path.Length) ? G.path[G.path.Length].children : G.root
    for node in children {
        label := (node.children.Length) ? (node.name "    ›") : node.name
        rows.Push({label: label, node: node})
    }
    return rows
}

; Searches the whole menu at once and shows the path of every hit, so a
; command three levels down is still one typed word away.
SearchRows(query) {
    global G
    tokens := StrSplit(RegExReplace(Trim(query), "\s+", " "), " ")
    hits := []

    for entry in G.index {
        haystack := (entry.path = "") ? entry.name : (entry.path " › " entry.name)
        found := true
        for token in tokens {
            if !InStr(haystack, token) {
                found := false
                break
            }
        }
        if (found)
            hits.Push({entry: entry, score: MatchScore(entry, query, tokens)})
    }

    ; Best matches first, without needing a sort: collect by score.
    rows := []
    loop 5 {
        want := A_Index - 1
        for hit in hits {
            if (hit.score != want)
                continue
            label := (hit.entry.path = "") ? hit.entry.name : (hit.entry.path " › " hit.entry.name)
            rows.Push({label: label, node: hit.entry.node})
        }
    }
    return rows
}

MatchScore(entry, query, tokens) {
    name := entry.name
    if (InStr(name, query) = 1)
        return 0                     ; the name itself starts with what was typed

    startsWords := true              ; every word starts a word of the name
    everyInName := true              ; every word is in the name somewhere
    for token in tokens {
        if !StartsWord(name, token)
            startsWords := false
        if !InStr(name, token)
            everyInName := false
    }
    if startsWords
        return 1
    if InStr(name, query)
        return 2
    if everyInName
        return 3
    return 4                         ; only matched through the path above it
}

StartsWord(haystack, needle) {
    if (InStr(haystack, needle) = 1)
        return true
    return InStr(haystack, " " needle) || InStr(haystack, "·" needle)
}

UpdateStatus() {
    global G
    if (G.editing)
        return
    if (G.query != "")
        G.status.Text := G.count " / " G.index.Length " matches"
    else
        G.status.Text := G.count . (G.count = 1 ? " item" : " items")
}

UpdateCrumb() {
    global G
    crumb := "Home"
    for node in G.path
        crumb .= "   ›   " node.name
    G.crumb.Text := crumb
    G.back.Visible := (G.path.Length > 0 || G.query != "")
}

BlankNode() {
    return {name: "", kind: "", action: "", children: [], parents: [], pathText: ""}
}

; ════════════════════════════════════════════════════════════════════════════
;  Navigation
; ════════════════════════════════════════════════════════════════════════════
MoveSelection(delta) {
    global G
    if !G.rows.Length
        return
    G.sel := Min(Max(G.sel + delta, 1), G.rows.Length)
    G.list.Modify(G.sel, "Select Focus Vis")
}

RunSelected() {
    global G
    ActivateRow(G.sel)
}

ActivateRow(row) {
    global G
    if (row < 1 || row > G.rows.Length)
        return

    node := G.rows[row].node
    if node.children.Length {              ; submenu – step into it
        G.path.Push(node)
        ClearSearch()
        UpdateCrumb()
        Render()
    } else {
        RunNode(node)
    }
}

RunNode(node) {
    global G

    if (node.kind = "close") {
        HideMenu()
        return
    }
    if (node.kind = "callsign") {
        EnterCallsignEdit()
        return
    }
    if !IsObject(node.action)
        return

    label := node.name
    if (node.parents.Length)
        label := node.parents[node.parents.Length] " › " node.name
    G.last := {label: label, node: node}

    HideMenu()
    if !FocusGame() {                      ; tabbed out? put the game back in front
        Tip("FiveM window not found  ·  nothing was sent")
        return
    }
    Sleep 120                              ; let the game take focus back first
    try
        node.action.Call()
    catch as err
        MsgBox("Command failed:`n`n" err.Message, "SD menu", "Iconx")
}

GoBack() {
    global G
    if (G.editing) {
        CancelCallsignEdit()
        return
    }
    if (G.query != "") {                   ; clear the filter before going up
        ClearSearch()
        UpdateCrumb()
        Render()
        return
    }
    if (G.path.Length) {
        G.path.Pop()
        UpdateCrumb()
        Render()
    }
}

GoHome() {
    global G
    if (G.editing)
        CancelCallsignEdit()
    G.path := []
    ClearSearch()
    UpdateCrumb()
    Render()
}

ClearSearch() {
    global G
    G.query := ""
    G.search.Value := ""
    G.hint.Visible := true
}

OnSearchChanged() {
    global G
    if (G.editing)
        return
    G.query := Trim(G.search.Value)
    G.hint.Visible := (G.search.Value = "")
    UpdateCrumb()
    Render()
}

OnListFocus(ctrl, row) {
    global G
    if (row >= 1 && row <= G.rows.Length)
        G.sel := row
}

OnListDoubleClick(ctrl, row) {
    ActivateRow(row)
}

; ════════════════════════════════════════════════════════════════════════════
;  Small UI helpers
; ════════════════════════════════════════════════════════════════════════════
RegisterHover(ctrl, normal, hot) {
    global G
    G.hover.Push({ctrl: ctrl, hwnd: ctrl.Hwnd, normal: normal, hot: hot, lit: false})
}

OnMouseMove(wParam, lParam, msg, hwnd) {
    global G
    try {
        for item in G.hover {
            lit := (wParam = item.hwnd)
            if (lit = item.lit)
                continue
            item.lit := lit
            item.ctrl.Opt("+Background" (lit ? item.hot : item.normal))
        }
    } catch {
    }
}

; Lets the window be dragged by its title band: only plain window background
; inside the top 48 px counts, so clicking a control never moves anything.
OnLButtonDown(wParam, lParam, msg, hwnd) {
    global G
    try {
        if !G.open
            return
        MouseGetPos(&mx, &my, &mwin, &mctrl)
        if (mwin != G.gui.Hwnd || mctrl != "")
            return
        WinGetPos(&wx, &wy, , , "ahk_id " G.gui.Hwnd)
        if (my - wy > 48)
            return
        PostMessage(0xA1, 2, 0, , "ahk_id " G.gui.Hwnd)   ; WM_NCLBUTTONDOWN / HTCAPTION
    } catch {
    }
}

; Win11 rounds the window corners; harmless no-op on older Windows.
RoundCorners(hwnd) {
    pref := 2
    try {
        DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "Int", 33, "Int*", &pref, "Int", 4)
    } catch {
        ; not Windows 11 – nothing to do
    }
}

; Paints the list's scrollbar dark on Windows 10/11.
DarkScrollbar(hwnd) {
    try {
        DllCall("uxtheme\SetWindowTheme", "Ptr", hwnd, "WStr", "DarkMode_Explorer", "WStr", "")
    } catch {
        ; theming unavailable – keep the system scrollbar
    }
}

Tip(text) {
    ToolTip(text, A_ScreenWidth // 2 - 150, A_ScreenHeight - 120, 19)
    SetTimer(() => ToolTip("", , , 19), -1600)
}

; ════════════════════════════════════════════════════════════════════════════
;  Commands
;  Every string below is exactly what the v1 script sent.
; ════════════════════════════════════════════════════════════════════════════
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
    Send "{F1}"
}

Miranda() {
    SendCommand("You have the right to remain silent")
    SendCommand("Anything you say can and will be used against you in a court of law")
    SendCommand("You have the right to an Attorney to be present during legal questioning")
    SendCommand("If you request one, one will be appointed for you free of charge")
    SendCommand("Do you understand these rights?")
}
