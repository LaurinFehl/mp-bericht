# DAEDALUS: Flugvergleich Mai (alter Rahmen) gegen ERC-Flug 3 (neuer Rahmen)

**Erstellt:** 2026-11-13
**Logs:** `log_521` (27.05.2026, alter Rahmen) gegen `log_753` (05.09.2026, ERC, neuer Rahmen)
**Skript:** `tools/flight_compare.py` (pyulog 1.2.4 aus `tools/pylib`)

Legende: ✅ im Log gemessen · 🔍 Interpretation oder Abschätzung · ❓ offen

**Zeitangaben:** t = 0 s ist immer die Log-Meldung „Armed by …“ (wie in allen anderen Auswertungen).

**Abgrenzung zu den anderen Dokumenten:**
- `Rahmenvergleich_Mai_vs_Sept.md` vergleicht **nur ruhige Schwebephasen** aller drei
  Septemberflüge mit dem Mai (Motorbalance, Vibrationsvarianzen, FFT). Das wird hier nicht
  wiederholt.
- `Contest-Fluege_2026-09-05_Auswertung.md` erklärt **was** in den ERC-Flügen passiert ist
  (State Machine, Pi-Ausfall, Netz).
- **Dieses Dokument** stellt die beiden Flüge **als Ganzes** gegenüber: Steckbrief, Ablauf,
  Flugbereich, Regelgüte, Sensorik/Schätzung, Strom, Funk und Parameter.

---

## 0. Welcher Septemberflug? → `log_753`

Gewählt wurde der Septemberflug mit den meisten Daten:

| Log | Länge | Samples (alle Topics) | Dateigröße |
|---|---|---|---|
| `log_751` (Flug 1) | 25,4 s | 17 771 | 1,17 MB |
| `log_752` (Flug 2) | 30,4 s | 21 385 | 1,40 MB |
| **`log_753` (Flug 3)** | **31,3 s** | **21 875** | **1,46 MB** |
| *zum Vergleich `log_521` (Mai)* | *58,2 s* | *40 505* | *2,58 MB* |

⚠️ **Einschränkung:** Flug 3 endet im Netz. Ab ~23 s hängt die Drohne mit Propeller oder Rahmen
am Netz, ab 25,3 s ist der Kill-Switch aktiv, und sie hängt mit 88° Schräglage. Diese Phase
würde jede Statistik (Schräglage, Drehraten, Motoren) dominieren. **Alle „in der Luft“-Werte für
Flug 3 enden deshalb bei t = 23,0 s** (`CUT` in `flight_compare.py`). Ausgewertet werden damit
**16,8 s freier Flug** gegen **51,4 s** im Mai.

---

## Kurzfassung

| Thema | Mai (`log_521`) | ERC Flug 3 (`log_753`) | Bewertung |
|---|---|---|---|
| Wer fliegt | Pilot, POSCTL, die ganze Zeit | Pi (Takeoff, Loiter, Offboard), ab 22,0 s Pilot | ⚠️ nicht direkt vergleichbar |
| Ende | normale Landung | Kill-Switch, Drohne hängt im Netz | – |
| Freie Flugzeit | 51,4 s | 16,8 s (bis Netzkontakt) | – |
| Echte Flughöhe (Entfernungsmesser) | bis 2,99 m | bis 1,64 m | 🔍 „2 m Takeoff“ ergab nur ~1,6 m (Abschnitt 4) |
| Max. Horizontalgeschwindigkeit | 0,72 m/s | **1,87 m/s** | Offboard-Anflug Richtung Netz |
| Positionshaltung im Schweben (Median / p95) | 0,14 / 0,49 m | **0,10 / 0,15 m** | ✅ deutlich besser (🔍 auch Modus-Effekt) |
| Beschl.-Vibrationsmetrik (Mittel) | 2,95 | **1,63** | ✅ ca. halbiert |
| Schwebeschub | 0,554 | 0,513 | ✅ etwas mehr Reserve |
| Momentenreserve (Allocator) | 99 % | 100 % | ✅ beide ok |
| Optical-Flow-Qualität (Median) | 176 | **128** | ⚠️ schlechter (Boden/Licht/Höhe?) |
| Entfernungsmesser für Höhe genutzt | 96 % | **57 %** | ⚠️ seltener |
| Telemetrie-Funk RSSI / Empfangsfehler | 175 / 0 | **126 / 232** | ⚠️ deutlich schlechter |
| Akku gemessen | nein (0,1 V) | nein (0,1 V) | 🔴 Akku-Failsafe wirkungslos (Abschnitt 6) |

**Fazit:** Wo der Vergleich fair ist, ist der ERC-Flug besser: weniger Vibration, präzisere
Positionshaltung, mehr Schubreserve. Das deckt sich mit `Rahmenvergleich_Mai_vs_Sept.md`.
Schlechter waren die **Umgebung und das Drumherum**: Funkstrecke, Optical-Flow-Qualität, und die
Höhe hat nicht gestimmt. Dazu kommen die bekannten Probleme mit State Machine und Pi. Am Rahmen
oder an der Regelung lag der Absturz nicht.

---

## 1. Steckbrief

| | Mai | ERC Flug 3 |
|---|---|---|
| Log | `log_521_2026-5-27-20-53-30.ulg` | `log_753_2026-9-5-14-10-00.ulg` |
| Datum / Uhrzeit (Dateiname) | 27.05.2026, 20:53 | 05.09.2026, 14:10 |
| Rahmen | alt, Armlänge 0,16 m | neu, Armlänge 0,14 m |
| Flight Controller | Pixhawk 6C (`PX4_FMU_V6C`) | gleich |
| PX4-Firmware | `99c40407ff` | **identisch** ✅ |
| Log-Profil | `SDLOG_PROFILE=1` (Standard, niedrige Raten) | gleich |
| Geschärft durch | RC-Schalter (Pilot) | „external command“ = Pi über MAVROS |
| Start erkannt | t = 3,9 s | t = 6,2 s |
| Ende | 55,3 s Landung erkannt, 57,3 s „Disarmed by landing“ | 25,3 s Kill-Switch, 30,3 s „Disarmed by kill-switch“ |
| In der Luft | 51,4 s | 24,4 s, davon 16,8 s frei |
| `vehicle_command` | 4 (3× Bodenstation `255/190`, 1× intern) | 19 (18× Pi `1/191`, 1× intern) |
| Setpoints vom Pi | keine, kein Companion Computer im Einsatz | 228 Nachrichten, letzte bei 22,70 s |
| Warnungen im Log | 2× „Avionics Power low: 4,79 V“ | Kill, Failsafe, „Attitude failure (roll)“, „Connection to mission computer lost“ (alle nach 25 s) |

---

## 2. Ablauf

**Mai, `log_521`: ein manueller Testflug**

| t | Was |
|---|---|
| 0,0 s | Pilot schärft per RC-Schalter, POSCTL |
| 3,9 s | abgehoben |
| 8–20 s | Steigflug auf ~2,8 m (Entfernungsmesser) |
| 20–50 s | Schweben und langsames Herumfliegen, max. 3,4 m vom Startpunkt, Gier über 129° |
| 50–55 s | Sinkflug, Landung bei 55,3 s |
| 57,3 s | automatisch entschärft |

Die Sticks waren in ~49 % der Flugzeit ausgelenkt. Es ist also ein gemischter Flug aus Halten und
Manövrieren, kein reiner Schwebetest.

**ERC Flug 3, `log_753`: autonomer Wettbewerbsflug** (Details:
`Contest-Fluege_2026-09-05_Auswertung.md`, Abschnitt 4)

| t | Modus | Was |
|---|---|---|
| 0,0 s | AUTO_LOITER | Pi schärft |
| 4,7 s | AUTO_TAKEOFF | Takeoff-Befehl vom Pi, abgehoben bei 6,2 s |
| 12,5 s | AUTO_LOITER | Schweben, ruhig bis 19,6 s |
| 19,6 s | OFFBOARD | Mission startet: Drehung um ~50° und Anflug auf (0, 0) mit bis 1,87 m/s |
| 22,0 s | POSCTL | Pilot übernimmt, bremst ab, steuert mit Roll-Ausschlag +0,49 |
| 22,7 s | POSCTL | letzter Setpoint vom Pi; ein Clipping-Ereignis auf IMU 1 |
| ~23 s | POSCTL | Netzkontakt (**Ende der Auswertung**) |
| 25,3 s | – | Kill-Switch |

Zeit pro Modus im ausgewerteten Fenster: LOITER 7,2 s · TAKEOFF 6,2 s · OFFBOARD 2,3 s ·
POSCTL 1,0 s.

---

## 3. Flugbereich, Lage und Regelgüte

Mai über 3,9–55,3 s, Flug 3 über 6,2–23,0 s. ✅ alles gemessen.

| Größe | Mai | Flug 3 |
|---|---|---|
| Max. Höhe über Grund (Entfernungsmesser) | 2,99 m | 1,64 m |
| Max. horizontaler Abstand zum Startpunkt | 3,42 m | 2,60 m |
| Zurückgelegte Strecke (horizontal) | 14,6 m | 3,9 m |
| Horizontalgeschwindigkeit max / Mittel | 0,72 / 0,24 m/s | 1,87 / 0,29 m/s |
| Steigen / Sinken max | 0,48 / 0,91 m/s | 0,32 / 0,70 m/s |
| Gier-Bereich | 129° | 77° |
| Schräglage max / p95 | 14,4° / 7,9° | 19,3° / 12,0° |
| Drehrate RMS Roll / Nick / Gier | 12,0 / 10,4 / 16,9 °/s | 21,2 / 7,5 / 18,3 °/s |
| Drehrate max Roll / Nick / Gier | 83 / 71 / 85 °/s | 208 / 71 / 135 °/s |
| Lagefehler RMS Roll / Nick / Gier | 2,17 / 1,72 / 0,64° | 3,15 / 1,96 / 5,30° |
| Positionsfehler beim Halten, Median / p95 | 0,14 / 0,49 m (POSCTL, Sticks mittig) | 0,10 / 0,15 m (LOITER) |
| Positionsfehler beim Takeoff | – | 0,08 / 0,26 m |
| Höhenfehler Median / p95 | 0,02 / 0,07 m | 0,01 / 0,11 m |

**Einordnung:**
- 🔍 Die **Spitzen** bei Flug 3 stammen fast alle aus den letzten Sekunden vor dem Netz: Gier
  135 °/s bei 19,9 s (Drehung beim Offboard-Start), Roll 208 °/s bei 22,79 s (Pilot mit vollem
  Roll-Ausschlag, vermutlich erster Netzkontakt). Der Gier-Lagefehler von 5,3° RMS kommt aus
  derselben Offboard-Drehung. Im ruhigen Teil sind die Werte besser als im Mai, siehe
  `Rahmenvergleich_Mai_vs_Sept.md`, Abschnitt 4.
- 🔍 **Positionshaltung:** Im LOITER hält die neue Drohne ihren Punkt auf ±0,15 m (p95), im Mai
  waren es ±0,49 m. Ein Teil davon ist der Modus: In POSCTL baut sich der Haltepunkt erst nach
  dem Loslassen der Sticks auf. Die Größenordnung ist trotzdem eindeutig.
- Im Offboard-Abschnitt beträgt der „Fehler“ 1,75 m im Median. Das ist kein Regelfehler, der
  Setpoint war einfach das weit entfernte Missionsziel (0, 0).

---

## 4. Höhe: was „2 m“ wirklich bedeutete

✅ Gemessen, EKF-Höhe (`vehicle_local_position.z`) gegen Entfernungsmesser (`distance_sensor`):

| t | Mai: z / Entfernungsmesser | Flug 3: z / Entfernungsmesser |
|---|---|---|
| am Boden | −0,57 / 0,21 m | −0,59 / 0,12 m |
| 20 s | −2,97 / 2,82 m | −2,01 / 1,59 m |
| 40 s | −3,79 / 2,73 m | – |
| kurz vor Landung (54 s) | −2,20 / 0,24 m | – |

- ✅ **Flug 3:** Der Nullpunkt der EKF-Höhe liegt nicht am Boden. Am Boden steht z schon auf
  −0,6 m. Der Takeoff ging auf z = −2,0 m, der Entfernungsmesser zeigt aber nur **~1,55–1,6 m**.
  Der Versatz bleibt über den Flug konstant (~0,45 m).
- 🔍 Die Höhenreferenz ist das Barometer (`EKF2_HGT_REF=0`). Der Entfernungsmesser wird nur
  bedingt genutzt (`EKF2_RNG_CTRL=1`): im Mai in 96 % der Flugzeit, in Flug 3 nur in 57 %. Der
  Nullpunkt kommt also aus dem Barometer und kann vor dem Start schon wandern.
  ❓ Ob der Pi „2 m relativ zum EKF-Ursprung“ meint oder „2 m über Grund“, gehört zur offenen
  Takeoff-Höhen-Frage der State Machine (`request_takeoff`, siehe CLAUDE.md).
- ✅ **Mai:** EKF-Höhe und Entfernungsmesser laufen über den Flug um bis zu ~1,6 m auseinander.
  Bei der Landung stand z noch auf −2,2 m, obwohl die Drohne 0,24 m über dem Boden war.
  🔍 Das passt zu Barometer-Drift (Abendflug, Temperatur). Im Mai wurde das unkritisch, weil der
  Pilot nach Sicht geflogen ist.
- ✅ **Entfernungsmesser am Boden:** im Mai 0,21 m, im September 0,12 m, bei einer
  Mindestreichweite von 0,20 m (`min_distance`). 🔍 Am neuen Rahmen sitzt der Sensor näher am
  Boden und misst im Stand unterhalb seines gültigen Bereichs. Ab ~0,3 m Flughöhe ist das egal.
  ❓ Kurz nachmessen, ob das zu den neuen Landebeinen passt.

---

## 5. Motoren, Schub und Vibration

| Größe | Mai | Flug 3 |
|---|---|---|
| Motor-Mittel M1 FR / M2 RL / M3 FL / M4 RR | 0,50 / 0,54 / 0,54 / 0,57 | 0,53 / 0,51 / 0,42 / 0,46 |
| Zeit mit einem Motor > 0,9 oder < 0,05 | 1,2 % (nur bei der Landung) | 1,8 % (19,8 s Drehung, 22,8–22,9 s Pilot/Netz) |
| Drehmoment vom Allocator umgesetzt | 99 % | 100 % |
| Schwebeschub (Median) | 0,554 | 0,513 |
| Beschl.-Vibrationsmetrik IMU 0 / IMU 1 (Mittel) | 2,95 / 2,94 | 1,63 / 1,66 |
| Beschl.-Vibrationsmetrik max | 3,89 | 3,71 (Ende, Netz) |
| Gyro-Vibrationsmetrik IMU 0 / IMU 1 | 0,078 / 0,067 | 0,069 / 0,062 |
| Beschleunigungs-Clipping | 0 | 3 (IMU 1, bei 22,7 s) |

- ✅ Das Motorbild über den ganzen Flug bestätigt `Rahmenvergleich_Mai_vs_Sept.md`: Im neuen
  Rahmen ist **M3 (vorne links) am schwächsten** und die CW-Motoren M1+M2 arbeiten mehr
  (Gier-Versatz). Die genauen Verhältnisse stehen dort, gemessen nur im ruhigen Schweben.
- ✅ **Vibration ca. halbiert** über den gesamten Flug, nicht nur im Schweben. Die Gyro-Metrik
  ändert sich kaum. 🔍 Die Verbesserung betrifft also hauptsächlich die Beschleunigungssensoren,
  was zu steiferen Armen bzw. einer besseren FC-Entkopplung passt.
- 🔍 Die 3 Clipping-Ereignisse fallen genau auf den ersten Netzkontakt bzw. das harte
  Pilotenmanöver. Im normalen Flug gab es keins.

---

## 6. Sensorik, Schätzung, Strom und Funk

| Größe | Mai | Flug 3 |
|---|---|---|
| GPS fusioniert? | **nein** (`EKF2_GPS_CTRL=0`) | **nein**, gleich |
| GPS (nur geloggt): Fix / Satelliten / HDOP | 3D / 6–7 / 1,64 | DGPS / 22–27 / 0,81 |
| Position kommt aus | Optical Flow (100 %) | Optical Flow (100 %) |
| Optical-Flow-Qualität Median / min (0–255) | 176 / 135 | **128 / 82** |
| Entfernungsmesser in der Höhenschätzung | 96 % | **57 %** |
| EKF-Positionsgenauigkeit `eph` (Median) | 0,71 m | 1,09 m |
| EKF-Testverhältnisse max (vel / hgt / mag / hagl) | 0,68 / 0,12 / 0,23 / 0,05 | 0,44 / 0,09 / 0,22 / 0,06 |
| EKF-Instanzwechsel | 1 | 0 |
| Akku (`battery_status`) | `connected=0`, 0,0–0,16 V | `connected=0`, 0,0–0,17 V |
| 5-V-Schiene FC min / Median | **4,80** / 4,84 V | 4,88 / 4,92 V |
| CPU-Last FC Mittel / max, RAM | 37 / 40 %, 38 % | 41 / 42 %, 39 % |
| RC-Empfänger RSSI, Verlust | 41, nie verloren | 41, nie verloren |
| Telemetrie-Funk RSSI lokal / remote | 175 / 180 | **126 / 133** |
| Telemetrie-Funk Empfangsfehler | 0 | **232** |

- ✅ **GPS spielt in beiden Flügen keine Rolle** für die Position: Die Drohne navigiert rein über
  Optical Flow plus Entfernungsmesser, das GPS wird nur mitgeloggt. In Flug 3 hätte es mit 22–27
  Satelliten und DGPS sogar besseren Empfang gehabt als im Mai, wird aber bewusst nicht genutzt
  (Käfig, Netz).
- ✅ **Optical Flow schlechter:** Die Qualität fiel im Median von 176 auf 128, das Minimum von 135
  auf 82. Alle EKF-Testverhältnisse bleiben trotzdem klar unter 1, die Schätzung war also stabil.
  🔍 Mögliche Gründe sind der Boden der Arena (Textur), das Licht oder die geringere Flughöhe.
  ❓ Lohnt einen Blick, bevor die Präzisionslandung davon abhängt.
- 🔴 **Akku nicht gemessen, in beiden Flügen:** `battery_status.connected = 0`, Spannung ≈ 0,1 V.
  Neu ist der Parameter **`COM_LOW_BAT_ACT` 0 → 2** (bei niedrigem Akku landen). 🔍 Ohne
  gültige Messung kann dieser Failsafe nie auslösen. Er steht in der Konfiguration, schützt aber
  nicht. Rulebook 7.3.2.2.2 verlangt Fail-Safes für den Akku. Behebung: das Power-Modul
  reparieren bzw. `BAT1_V_DIV`/`BAT1_SOURCE` prüfen.
- ✅ **„Avionics Power low 4,79 V“ nur im Mai.** Die 5-V-Versorgung des FC lag im Mai bei
  4,80–4,84 V, im September bei 4,88–4,92 V. 🔍 Die Stromversorgung des FC wurde offenbar
  verbessert, oder der Verbraucher hat sich geändert.
- ✅ **Telemetrie-Funk deutlich schlechter:** 232 Empfangsfehler statt 0, RSSI ~50 Punkte
  niedriger. 🔍 Typisch für eine Wettbewerbsumgebung mit vielen anderen Funkstrecken und
  größerem Abstand zur Bodenstation. Der RC-Link war in beiden Flügen einwandfrei.

---

## 7. Parameteränderungen Mai → September (64)

✅ Vollständige Liste: `PYTHONPATH=pylib python3 flight_compare.py …` (Ende der Ausgabe).

| Gruppe | Anzahl | Was | Bedeutung |
|---|---|---|---|
| Sensor-Kalibrierung (`CAL_ACC*`, `CAL_GYRO*`, `CAL_MAG*`) | 30 | neu kalibriert | 🔍 normal nach Umbau. Gyro 1 hat einen auffällig größeren Offset (Y: −0,015 → −0,047 rad/s) ❓ |
| FC-Einbaulage (`SENS_BOARD_X/Y_OFF`) | 2 | Roll −1,43° → −0,03°, Nick +0,81° → −1,27° | neu nivelliert, FC sitzt im neuen Rahmen anders |
| Rahmengeometrie (`CA_ROTORn_PX/PY`) | 8 | ±0,16 → ±0,14 m | neuer Rahmen |
| Regler (`MC_*RATE_P/I/D`, `MC_PITCH_P`, `MC_YAW_P`) | 11 | Rate-Gains 2–19 % niedriger (P/I am stärksten, Nick-I −19 %), `MC_YAW_P` 4,46 → 5,18 | neu getunt |
| ESC-Zuordnung (`PWM_AUX_FUNC1–4`) | 4 | umgesteckt | ohne Einfluss auf die Auswertung |
| Fehlererkennung (`FD_ACT_EN`, `FD_IMB_PROP_THR`) | 2 | ausgeschaltet | ❓ bewusst? (siehe Rahmenvergleich) |
| `DSHOT_TEL_CFG` | 1 | 0 → 103 | DShot-Telemetrie an, wird aber nicht geloggt |
| `COM_LOW_BAT_ACT` | 1 | 0 → 2 (Landen) | 🔴 wirkungslos ohne Akku-Messung (Abschnitt 6) |
| `EKF2_MAG_DECL` | 1 | 3,5° → 6,2° | 🔍 passt zu einem Ortswechsel (Frankfurt → Wettbewerbsort) |
| `EKF2_OF_POS_X` | 1 | 0,125 → 0,095 m | Optical-Flow-Sensor sitzt 3 cm weiter hinten |
| Buchhaltung (`COM_FLIGHT_UUID`, `LND_FLIGHT_T_LO`, `MPC_TKO_SPEED`) | 3 | Zähler bzw. Float-Rundung | ohne Bedeutung |

**Unverändert und relevant:** `GF_MAX_HOR_DIST`/`GF_MAX_VER_DIST` (Geofence aus, siehe
Contest-Auswertung), `EKF2_GPS_CTRL=0`, `EKF2_HGT_REF=0` (Barometer), `MPC_XY_VEL_MAX=2,5 m/s`,
`SDLOG_PROFILE=1`.

---

## 8. Grenzen des Vergleichs

- ⚠️ **Unterschiedliche Flüge:** Im Mai flog ein Pilot in POSCTL zum Testen, im September flog
  der Pi autonom einen Wettbewerbsflug, der im Netz endete. Fair vergleichbar sind nur
  Vibration, Schwebeschub und Positionshalten. Alles mit Spitzenwerten (Geschwindigkeit, Raten,
  Schräglage) zeigt den Flugauftrag, nicht die Drohne.
- ⚠️ **Kurzer Septemberflug:** nur 16,8 s freier Flug, davon 7 s ruhiges LOITER.
- ⚠️ **Niedrige Log-Raten** (`SDLOG_PROFILE=1`): Lage mit ~20 Hz, Motoren mit 10 Hz, viele
  Status-Topics mit 1 Hz. Einzelne Spitzen können zwischen zwei Samples liegen.
- ⚠️ **Keine Akkuspannung:** Schwebeschub und Motorwerte lassen sich nicht auf die Spannung
  normieren. 0,554 gegen 0,513 kann auch ein vollerer Akku sein.
- ⚠️ Wetter, Wind und Untergrund sind unbekannt (Mai: abends, draußen? September: Arena mit Netz).

---

## 9. Neue Befunde aus diesem Vergleich

| # | Befund | Belegt | Gehört |
|---|---|---|---|
| 1 | Akku-Failsafe `COM_LOW_BAT_ACT=2` kann nie auslösen, weil `battery_status.connected=0` | ✅ Log + Parameter | FC-Konfiguration / Hardware |
| 2 | Takeoff „2 m“ ergab ~1,6 m echte Höhe; EKF-Nullpunkt liegt 0,45–0,6 m unter dem Boden | ✅ Log | State Machine (Takeoff-Höhe) + EKF-Setup |
| 3 | Optical-Flow-Qualität und Entfernungsmesser-Nutzung im Wettbewerb deutlich schlechter | ✅ Log, Ursache ❓ | Sensorik |
| 4 | Entfernungsmesser misst am Boden unter seiner Mindestreichweite (0,12 < 0,20 m) | ✅ Log | Rahmen/Montage (harmlos) |
| 5 | Telemetrie-Funk mit 232 Empfangsfehlern | ✅ Log | Funk/Antenne |

🔍 Befund 1 und 2 sollten nach `BEFUNDE.md` übernommen werden, wenn sie bestätigt sind.

---

## Reproduzieren

Im Container `ros-frost` (der Host hat kein numpy):

```bash
cd ~/frost/drone/flight-logs/tools
PYTHONPATH=pylib python3 flight_compare.py ../log_521*.ulg ../log_753*.ulg
```

Für einen anderen Septemberflug den Dateinamen tauschen und das `CUT`-Fenster im Skript anpassen
(oder den Eintrag entfernen, wenn der Flug normal gelandet ist).
