; ============================================================
; ATC CONFIG
; ============================================================

global Aircraft := "AIRSD-7"

; ============================================================
; ASCENDING - SANDY
; ============================================================

ATCAscendingFromSandyPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, Priority A")
}

ATCAscendingFromSandyPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, Priority B")
}

ATCAscendingFromSandyPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, Priority C")
}

ATCAscendingFromSandyPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, Priority O")
}

; ============================================================
; ASCENDING - FORT ZANCUDO
; ============================================================

ATCAscendingFromFortZancudoPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, Priority A")
}

ATCAscendingFromFortZancudoPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, Priority B")
}

ATCAscendingFromFortZancudoPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, Priority C")
}

ATCAscendingFromFortZancudoPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, Priority O")
}

; ============================================================
; ASCENDING - DAVIS STATION
; ============================================================

ATCAscendingFromDavisStationPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, Priority A")
}

ATCAscendingFromDavisStationPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, Priority B")
}

ATCAscendingFromDavisStationPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, Priority C")
}

ATCAscendingFromDavisStationPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, Priority O")
}

; ============================================================
; ASCENDING - PALETO PAD
; ============================================================

ATCAscendingFromPaletoPadPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, Priority A")
}

ATCAscendingFromPaletoPadPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, Priority B")
}

ATCAscendingFromPaletoPadPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, Priority C")
}

ATCAscendingFromPaletoPadPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, Priority O")
}

; ============================================================
; DESCENDING - SANDY
; ============================================================

ATCDescendingToSandy() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, descending to Sandy Helipad")
}

; ============================================================
; DESCENDING - FORT ZANCUDO
; ============================================================

ATCDescendingToFortZancudo() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, descending to Fort Zancudo")
}

; ============================================================
; DESCENDING - DAVIS STATION
; ============================================================

ATCDescendingToDavisStation() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, descending to Davis Station")
}

; ============================================================
; DESCENDING - PALETO PAD
; ============================================================

ATCDescendingToPaletoPad() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, descending to Paleto MD Pad")
}
