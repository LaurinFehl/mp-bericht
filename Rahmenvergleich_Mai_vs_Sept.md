# DAEDALUS: alter Rahmen (Mai) gegen neuen Rahmen (September), Auswertung der Flight-Logs

**Erstellt:** 2026-09-21
**Logs:** `log_521` (27.05., alter Rahmen) gegen `log_751`, `log_752`, `log_753` (05.09., neuer Rahmen)
**Skripte:** `tools/frame_compare.py`, `tools/gyro_fft_peaks.py`

Legende: ✅ im Log gemessen · 🔍 Interpretation oder Abschätzung · ❓ offen

---

## Kurzfassung

| Thema | alter Rahmen | neuer Rahmen | Bewertung |
|---|---|---|---|
| Vibrationen (Beschleunigung, Varianz) | 60–125 (m/s²)² | 4–11 (m/s²)² | ✅ **rund 15-mal ruhiger** |
| Vibrationen (Gyro, Varianz) | 0,012–0,019 | 0,002–0,007 | ✅ 3- bis 5-mal ruhiger |
| Lagefehler im ruhigen Schweben (RMS) | 1,2° / 1,7° | 0,6–0,9° / 0,6–1,2° | ✅ besser (🔍 Bedingungen nicht gleich) |
| Schwebeschub (Hover Thrust) | 0,55 | 0,52–0,53 | ✅ etwas mehr Reserve (🔍 ohne Akkuspannung nicht normierbar) |
| Motor-Sättigung | keine | keine | ✅ gleich gut |
| **Gier-Versatz** der Motorpaare | 0,92 | **1,12–1,21** | ⚠️ **schlechter, Vorzeichen gedreht** |
| **Links/rechts-Versatz** | 0,99 | **1,05–1,08** | ⚠️ neu, in allen 3 Flügen |
| Vorne/hinten-Versatz | 0,93 | 0,96–1,00, schwankt | 🔍 Akku-Position pro Flug? |
| Resonanz mit fester Frequenz | keine | 37 Hz, Roll, nur Flug 1 | ❓ etwas Lockeres? |

**Zusammengefasst:** Der neue Rahmen ist **mechanisch deutlich ruhiger** und fliegt präziser.
Die Regelung hat überall noch viel Reserve. Er ist aber **schlechter ausgerichtet**:
Die Motoren müssen dauerhaft gegen ein Drehmoment um die Hochachse arbeiten, und die rechte
Seite muss mehr tragen als die linke. Beides lässt sich mechanisch beheben, am Rahmen oder an
der Beladung. Umbauen muss man den Rahmen deswegen nicht.

---

## 0. Was sich laut Parametern geändert hat

- ✅ **Armlänge:** `CA_ROTORn_PX/PY` von ±0,16 m auf ±0,14 m. Diagonale Motor-zu-Motor also
  laut Konfiguration ca. **453 mm → 396 mm**. ❓ Bitte am echten Rahmen nachmessen, ob 0,14 m
  stimmt.
- ✅ **Neu autogetunt:** Rate-P-Gains 7–17 % niedriger (z. B. `MC_PITCHRATE_P` 0,153 → 0,127),
  `MC_YAW_P` 4,46 → 5,18. 🔍 Passt zu einem kleineren, leichteren Rahmen mit weniger Trägheit.
- ✅ **ESC-Zuordnung umgesteckt:** `PWM_AUX_FUNC1–4` von M3/M4/M1/M2 auf M2/M1/M4/M3. Das ändert
  nichts an der Auswertung, weil `actuator_motors` nach Geometrie nummeriert ist, nicht nach
  Ausgang.
- ✅ **Unwucht-Erkennung abgeschaltet:** `FD_IMB_PROP_THR` 30 → 0, `FD_ACT_EN` 1 → 0. Im alten
  Log lag die Unwucht-Metrik bei 1,5 (max. 2,6), im neuen wird sie nicht mehr berechnet.
- ✅ DShot-Telemetrie aktiviert (`DSHOT_TEL_CFG=103`), aber `esc_status` wird nicht geloggt.
  Echte Drehzahlen gibt es deshalb nicht.

**Motor-Nummerierung** (aus `CA_ROTORn_*`):

```
          vorne
   M3 (FL, CCW)   M1 (FR, CW)
            \       /
              [FC]
            /       \
   M2 (RL, CW)    M4 (RR, CCW)
          hinten
```

---

## 1. Methode und Grenzen

- **Ruhiges Schweben** heißt: horizontal < 0,3 m/s, vertikal < 0,2 m/s, Gierraten-Sollwert
  < 5 °/s. Neuer Rahmen: nur die LOITER-Abschnitte vor der Mission (Flug 3 vor dem Netzkontakt
  bei ~23 s). Alter Rahmen: POSCTL, nur Stellen, an denen die Sticks mittig stehen.
- ⚠️ **Nur ein Flug mit dem alten Rahmen,** und den hat der Pilot geflogen (POSCTL, 51 s,
  3D-GPS-Fix mit 7 Satelliten). Die neuen Flüge liefen im Autopilot-Modus. Wind und Umgebung
  können sich unterschieden haben.
- ⚠️ **Keine Akkuspannung in keinem Log** (Power-Modul liefert ≈ 0,1 V, bekannter Befund).
  Motor-Sollwerte und Schwebeschub lassen sich deshalb nicht auf die Spannung normieren.
- ⚠️ **Logging mit niedriger Rate:** `actuator_motors` mit 10 Hz, Gyro mit 50 Hz. Hochfrequente
  Vibrationen sieht man nur über die Onboard-Metriken (`vehicle_imu_status`, `sensor_gyro_fft`),
  nicht direkt.
- 🔍 Motor-Sollwerte sind keine Schubwerte. PX4 rechnet mit `THR_MDL_FAC=0` linear, echter
  Schub wächst eher quadratisch mit dem Sollwert. Die Schub-Unterschiede sind real also eher
  **größer** als die Verhältnisse unten.

---

## 2. Motorverhältnisse im ruhigen Schweben

✅ Mittlere Motor-Sollwerte (0 = aus, 1 = voll):

| Flug | M1 FR | M2 RL | M3 FL | M4 RR | Gier (M1+M2)/(M3+M4) | rechts/links (M1+M4)/(M2+M3) | vorne/hinten (M1+M3)/(M2+M4) |
|---|---|---|---|---|---|---|---|
| Mai (alt)* | 0,51 | 0,56 | 0,56 | 0,60 | 0,92 | 0,99 | 0,93 |
| Flug 1 | 0,59 | 0,56 | 0,47 | 0,50 | **1,19** | **1,05** | 1,00 |
| Flug 2 | 0,56 | 0,54 | 0,46 | 0,52 | **1,12** | **1,08** | 0,96 |
| Flug 3 | 0,58 | 0,57 | 0,46 | 0,49 | **1,21** | **1,05** | 0,99 |

\* Im Mai nur 1,8 s mit mittigen Sticks. Über alle ruhigen Phasen des Flugs (23 s):
0,51 / 0,55 / 0,54 / 0,58, also dasselbe Bild.

Die Spreizung zwischen dem stärksten und dem schwächsten Motor wächst von ~0,09 auf ~0,10–0,12.
Im neuen Rahmen ist **M1 (vorne rechts) immer am stärksten und M3 (vorne links) immer am
schwächsten.** Das ist die Summe aus den beiden Effekten unten.

### 2a. Gier-Versatz, die größte Auffälligkeit

✅ M1+M2 (CW) arbeiten 12–21 % mehr als M3+M4 (CCW). Der Gier-Drehmoment-Sollwert steht im
Mittel bei −0,03 bis −0,05, der Gier-Integrator bei −0,025 bis −0,06. Der Regler hält also
**dauerhaft gegen**. Beim alten Rahmen gab es das auch, aber schwächer und mit umgekehrtem
Vorzeichen (0,92; Sollwert +0,024; Integrator +0,023).

🔍 **Warum das auf den Rahmen zeigt:** Ein Quadrocopter giert nur über das Luftwiderstands-
Moment der Propeller, also die schwächste Achse. Schon ein minimal verkippter Motor erzeugt über
seinen Schubvektor ein Giermoment, das der Regler dann über die Drehzahlen der Motorpaare
ausgleichen muss. Mit dem PX4-Standardwert `CA_ROTOR_KM=0,05` (nicht vermessen) entspricht der
gemessene Versatz einer **Summe von ca. 1–3° Verkippung** aller Motoren in Umfangsrichtung, zum
Beispiel 1° an jedem Motor oder 3–5° an einem einzigen. Beim alten Rahmen wären es etwa 0,7° in
die andere Richtung.

Mögliche Ursachen, wahrscheinlichste zuerst:
1. **Motorhalter nicht rechtwinklig** zur Rahmenebene, oder Arme, die in sich **verdreht** sind
   (Torsion, eventuell erst unter Last).
2. Ungleiche Propeller (Typ, Beschädigung, Steigung) zwischen den beiden Drehrichtungen.
3. Unterschiedliche Motoren oder ESCs zwischen den Paaren.

Kritisch ist das nicht, weil noch viel Reserve da ist. Aber genau diese Achse brauchte beim
Netzkontakt in Flug 3 den vollen Stellbereich (Motoren auf 0).

### 2b. Rechts schwerer als links

✅ In allen drei neuen Flügen tragen die rechten Motoren (M1+M4) 5–8 % mehr. Roll-Moment-Sollwert
−0,018 bis −0,029, Roll-Integrator negativ. Beim alten Rahmen war das ausgeglichen (0,99).

🔍 Als Schwerpunktverschiebung gerechnet: mit 0,14 m Armhebel und linearem Modell ca.
**4–6 mm nach rechts (Steuerbord)**, mit realistischem quadratischem Schub eher **0,7–1,1 cm**.
Alternativ ziehen die rechten Motoren schwächer. Unterscheiden lässt sich das mit einem Test:
den Akku ~1 cm nach links schieben. Geht das Verhältnis gegen 1,00, war es der Schwerpunkt.

### 2c. Vorne/hinten schwankt

✅ 1,00 → 0,96 → 0,99 zwischen Flügen am selben Tag ohne Parameteränderung. 🔍 Das spricht für
eine Beladung, die sich von Flug zu Flug ändert, am ehesten die **Akku-Position**. Ein
Anschlag oder eine Markierung für den Akku würde das festlegen.

---

## 3. Vibrationen, die große Verbesserung

✅ `vehicle_imu_status` im ruhigen Schweben:

| | Mai (alt) | Flug 1 | Flug 2 | Flug 3 |
|---|---|---|---|---|
| Beschl.-Vibrationsmetrik | 2,6–3,0 | 1,6 | 2,0 | 1,5 |
| Beschl.-Varianz x/y/z [(m/s²)²] | 126 / 59 / 83 | 5 / 7 / 5 | 5 / 9 / 7 | 4 / 11 / 7 |
| Gyro-Varianz x/y/z [(rad/s)²] | 0,012 / 0,019 / 0,017 | 0,002 / 0,005 / 0,002 | 0,003 / 0,007 / 0,003 | 0,003 / 0,007 / 0,003 |
| Clipping | 0 | 0 | 0 | 0 |

Beide IMUs zeigen das gleiche Bild. Auch die Motor-Sollwerte zappeln im neuen Rahmen weniger
(Standardabweichung 0,015–0,03 statt 0,03–0,05). Der Regler muss also weniger Rauschen
ausgleichen.

🔍 Der neue Rahmen ist steifer und/oder der FC ist besser entkoppelt. **Dieser Teil sollte bei
einem Umbau unbedingt erhalten bleiben:** FC-Montage und Armsteifigkeit nicht verschlechtern.

### Frequenzen (Onboard-Gyro-FFT, 30–150 Hz)

- ✅ In allen Flügen gibt es eine Spitze bei **~100–120 Hz**. 🔍 Das ist die Motordrehfrequenz
  im Schweben (≈ 6000–7000 U/min) und damit normal.
- ✅ **Flug 1: eine feste Spitze bei 37 Hz auf der Roll-Achse**, 69 % aller Roll-Peaks und über
  den ganzen Flug konstant, unabhängig vom Gas. In Flug 2 und 3 fehlt sie ganz (Flug 3 zeigt kurz
  46–58 Hz bei 8–11 s). 🔍 Eine feste Frequenz ohne Bezug zur Drehzahl spricht für eine
  **mechanische Eigenschwingung**: etwas Loses oder weich Befestigtes, das zwischen Flug 1 und 2
  angezogen oder anders gelegt wurde. Kandidaten sind Landebein, Antenne, Kamera-/Pi-Halter,
  Akku-Gurt oder Kabel. ❓ Weiß jemand, ob zwischen den Flügen etwas nachgezogen wurde?
- Notch-Filter sind aus (`IMU_GYRO_DNF_EN=0`, `IMU_GYRO_NF*_FRQ=0`). Bei den jetzigen
  Vibrationswerten ist das in Ordnung.

---

## 4. Flugverhalten und Reserve

- ✅ **Lagefehler** (Ist gegen Soll, RMS, ruhiges Schweben): alt 1,2° Roll / 1,7° Nick;
  neu 0,6–0,9° / 0,6–1,2°. Die Drehraten-Unruhe liegt bei 2–5 °/s statt 7–12 °/s. 🔍 Ein Teil
  davon kommt vom Modus (Pilot in POSCTL gegen LOITER), der Unterschied ist aber deutlich.
- ✅ **Stellreserve:** Der stärkste Motor liegt beim 99. Perzentil in beiden Rahmen bei ~0,69.
  Im ruhigen Schweben war kein Motor über 0,9 oder unter 0,1. In den Missionsabschnitten von
  Flug 1 und 3 lag kurz ein Motor über 0,9 (0,7 % der Zeit, Drehung und seitlicher Anflug).
  Der Allocator hat jedes Drehmoment umgesetzt (`torque_setpoint_achieved` = 100 %).
- ✅ **Schwebeschub** 0,55 → 0,52–0,53. 🔍 Ohne Akkuspannung und ohne bekannte Masse lässt sich
  nicht trennen, ob der neue Rahmen leichter ist oder der Akku voller war. Schub-zu-Gewicht
  liegt in beiden Fällen grob bei 2:1 oder besser.

---

## 5. Was sich am Rahmen konkret lohnt

| # | Maßnahme | Behebt | Aufwand |
|---|---|---|---|
| 1 | Alle 4 Motoren auf Rechtwinkligkeit zur Rahmenebene prüfen (Winkelmesser/Wasserwaage, Prop-Spitzen gleich hoch?), Arme auf Verdrehung prüfen, Klemmungen nachziehen | Gier-Versatz (2a) | gering |
| 2 | Propeller prüfen: gleicher Typ, keine Kerben; testweise die Props von M1 und M3 tauschen | Gier-Versatz (2a) | gering |
| 3 | Akku oder Bauteile ~1 cm nach links verschieben, danach rechts/links-Verhältnis erneut prüfen | Links/rechts (2b) | gering |
| 4 | Feste Akku-Position (Anschlag, Markierung, Klett) | Vorne/hinten-Schwankung (2c) | gering |
| 5 | Alles, was schwingen kann, fest montieren (Beine, Antennen, Kabel, Pi/Kamera) | 37-Hz-Resonanz (3) | gering |
| 6 | FC-Entkopplung und Armsteifigkeit **nicht** verschlechtern | Vibrationsvorteil erhalten | – |

**Für die nächste Auswertung** (Konfiguration, nicht Rahmen):
- Power-Modul reparieren, damit die Akkuspannung geloggt wird. Erst dann ist Schwebeschub
  vergleichbar.
- `esc_status` loggen (DShot-Telemetrie ist schon an): echte Drehzahlen pro Motor, damit lassen
  sich Motor- und Rahmenprobleme direkt trennen.
- Für einen Vibrations-Check mit höherer Log-Rate fliegen (High-Rate-Profil in `SDLOG_PROFILE`).
- `FD_IMB_PROP_THR` wieder auf 30 setzen, damit die Unwucht-Metrik geloggt wird. Wurde bewusst
  abgeschaltet? ❓
- `CA_ROTORn_PX/PY` gegen die echte Geometrie abgleichen (Abschnitt 0).

Nach Maßnahme 1–4 reicht ein kurzer LOITER-Schwebeflug. `tools/frame_compare.py` zeigt dann
direkt, ob die drei Verhältnisse näher an 1,00 liegen. Dafür das neue Log mit seinem
Zeitfenster in `WIN` eintragen.
