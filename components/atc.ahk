; ════════════════════════════════════════════════════════════════════════════
;  components/atc.ahk · ATC calls                              AutoHotkey v2
; ────────────────────────────────────────────────────────────────────────────
;  Every call below is sent with the active callsign from the `Aircraft`
;  global (set in SD.ahk, changed in game from "Set callsign"). In v2 a
;  function can read a global without declaring it, so these stay one-liners.
; ════════════════════════════════════════════════════════════════════════════

; ─── Ascending · Sandy ─────────────────────────────────────────────────────
ATCAscendingFromSandyPrioA() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority A")
}

ATCAscendingFromSandyPrioB() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority B")
}

ATCAscendingFromSandyPrioC() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority C")
}

ATCAscendingFromSandyPrioO() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority O")
}

; ─── Ascending · Fort Zancudo ──────────────────────────────────────────────
ATCAscendingFromFortZancudoPrioA() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority A")
}

ATCAscendingFromFortZancudoPrioB() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority B")
}

ATCAscendingFromFortZancudoPrioC() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority C")
}

ATCAscendingFromFortZancudoPrioO() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority O")
}

; ─── Ascending · Davis Station ─────────────────────────────────────────────
ATCAscendingFromDavisStationPrioA() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority A")
}

ATCAscendingFromDavisStationPrioB() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority B")
}

ATCAscendingFromDavisStationPrioC() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority C")
}

ATCAscendingFromDavisStationPrioO() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority O")
}

; ─── Ascending · Paleto Pad ────────────────────────────────────────────────
ATCAscendingFromPaletoPadPrioA() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto Pad, 1000 feet, Priority A")
}

ATCAscendingFromPaletoPadPrioB() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto Pad, 1000 feet, Priority B")
}

ATCAscendingFromPaletoPadPrioC() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto Pad, 1000 feet, Priority C")
}

ATCAscendingFromPaletoPadPrioO() {
    SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto Pad, 1000 feet, Priority O")
}

; ─── Descending ────────────────────────────────────────────────────────────
ATCDescendingToSandy() {
    SendCommand("/ATC " Aircraft " to ATC, descending to Sandy Helipad")
}

ATCDescendingToFortZancudo() {
    SendCommand("/ATC " Aircraft " to ATC, descending to Fort Zancudo")
}

ATCDescendingToDavisStation() {
    SendCommand("/ATC " Aircraft " to ATC, descending to Davis Station")
}

ATCDescendingToPaletoPad() {
    SendCommand("/ATC " Aircraft " to ATC, descending to Paleto Pad")
}
