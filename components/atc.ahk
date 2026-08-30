; ============================================================
; ATC CONFIG
; ============================================================

global Aircraft := "AIRSD-7"

; ============================================================
; ASCENDING - SANDY
; ============================================================

ATCAscendingFromSandyPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority A")
}

ATCAscendingFromSandyPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority B")
}

ATCAscendingFromSandyPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority C")
}

ATCAscendingFromSandyPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Sandy Helipad, 1000 feet, Priority O")
}

; ============================================================
; ASCENDING - FORT ZANCUDO
; ============================================================

ATCAscendingFromFortZancudoPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority A")
}

ATCAscendingFromFortZancudoPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority B")
}

ATCAscendingFromFortZancudoPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority C")
}

ATCAscendingFromFortZancudoPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Fort Zancudo, 1000 feet, Priority O")
}

; ============================================================
; ASCENDING - DAVIS STATION
; ============================================================

ATCAscendingFromDavisStationPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority A")
}

ATCAscendingFromDavisStationPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority B")
}

ATCAscendingFromDavisStationPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority C")
}

ATCAscendingFromDavisStationPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Davis Station, 1000 feet, Priority O")
}

; ============================================================
; ASCENDING - PALETO PAD
; ============================================================

ATCAscendingFromPaletoPadPrioA() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, 1000 feet, Priority A")
}

ATCAscendingFromPaletoPadPrioB() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, 1000 feet, Priority B")
}

ATCAscendingFromPaletoPadPrioC() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, 1000 feet, Priority C")
}

ATCAscendingFromPaletoPadPrioO() {
global Aircraft
SendCommand("/ATC " Aircraft " to ATC, ascending from Paleto MD Pad, 1000 feet, Priority O")
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
