# Kontext: Bericht über DAEDALUS (Drohnenframe + LED-Statusanzeige)

Diese Datei gibt dir (Claude Code) den Hintergrund für den Bericht. Alles mit **[PRÜFEN]** ist aus dem ERC-2026-Final-Report des Teams übernommen oder unsicher und muss gegen Repo, Regelwerk oder Messdaten abgeglichen werden. Nichts davon ohne Prüfung als Fakt in den Bericht schreiben.

## 1. Auftrag

- **Titel:** "Verbesserung eines Drohnenframes für FDM-3D-Druck und Integration von LED-Zustandsindikatoren"
- **Format:** Bericht im Aufbau einer Bachelorarbeit, geschrieben in LaTeX (VS Code, LaTeX Workshop), Sprache Deutsch, Code und Kommentare im LaTeX Englisch.
- **Autor:** Laurin, Mechatronik B. Eng., Lead Hardware Engineer / UAV Systems Lead der Drohne im Team FRoST.
- **Zwei Ziele der Arbeit:**
  1. 3D-gedruckter, für FDM optimierter Drohnenframe (leichter, gut druckbar, wartbar)
  2. LED-Statusanzeige, die den Flugmodus bzw. Zustand der Drohne anzeigt

## 2. LaTeX-Projekt

Dateien liegen in `TeXFiles/`, Einbindung in `main.tex` per `\input{TeXFiles/...}` (ohne `.tex`, einheitlich). `\include` nicht verwenden.

Nummerierung dreistellig mit Lücken, erste Ziffer = Kapitel:

```
000_Settings  001_Titlepage  002_NDNotice  003_Declaration  004_Figures  005_Acronyms
010_Kurzfassung
100_Einfuehrung
(150_Zielstellung)        % optional: Forschungsfrage, Anforderungen
200_Hintergrund
300_StandDerTechnik
400_EntwickelteMethoden
500_Evaluation
600_Ergebnisse
700_Zusammenfassung
900_Anhang
```

Technische Konventionen:

- Dokumentklasse `scrreprt` (KOMA-Script). `\appendix` ohne `\begin/\end`.
- Literatur über **biblatex/biber**: `\printbibliography[heading=bibintoc]`. `\nocite{*}` nur während der Schreibphase, vor Abgabe entfernen.
- Abkürzungen über `glossaries` (`\newacronym` in `005_Acronyms.tex`, Nutzung mit `\gls`, `\acrshort`). Bereits definiert bzw. benötigt: `daedalus`, `frost`, `erc`.
- Bilder werden in `004_Figures.tex` als `\newcommand` definiert (per `\input` in der Präambel).
- Labels: `ch:`, `sec:`, `fig:`, `tab:`. Verweise mit `~\ref{}`.
- Schreibstil: technisch präzises Deutsch, knapp. Bei Formulierungsvorschlägen bitte drei Alternativen anbieten. Bestehende Strukturen möglichst beibehalten.

Bereits festgelegte Kapitelgliederung (Frame immer zuerst, LED danach):

- **Hintergrund:** ERC (Wettbewerb, Rolle der Drohne, relevante Anforderungen), FRoST (Team, Rover EROS, Mechatronik-Projekt), Drohne (Vorgänger ICARUS, aktuell DAEDALUS, bisheriger Frame).
- **Stand der Technik:** Drohnenplattformen und Frames (Bauformen, kommerzielle Frames, 3D-gedruckte Frames, Vergleich); Fertigung mit FDM (Prinzip, Materialien, Konstruktionsrichtlinien, Grenzen); Zustandsanzeigen bei Drohnen (PX4-Status, LED-Systeme, Anforderungen); Zusammenfassung mit Ableitung der Lücke.
- **Entwickelte Methoden:** Anforderungen; Konstruktion des Frames; LED-Statusanzeige (Konzept, Hardware, Software/Zustandsautomat, Anbindung an den FC).
- **Evaluation:** Methodik, Tests Frame (Masse, mechanisch, Druckqualität, Flugtests), Tests LED (Zustandsübergänge, Sichtbarkeit, Flugbetrieb).
- **Ergebnisse:** Ergebnisse Frame, Ergebnisse LED, Diskussion (Anforderungsabgleich als Tabelle, Probleme und Grenzen).
- **Zusammenfassung:** Zusammenfassung und Ausblick.

Offene Hinweise zur Kurzfassung: `\chapter*` taucht nicht im Inhaltsverzeichnis auf, ggf. `\addchapheadingtotoc` ergänzen. Ergebnisse (Masse, Druckzeit, Tests) fehlen dort noch.

## 3. Wettbewerb: European Rover Challenge (ERC) 2026

- Veranstaltung: AGH Universität Krakau, Polen, 4.–6. September 2026. Studentische Teams bauen Marsrover und treten in simulierten Missionen an (u. a. Probenentnahme, Wartung, autonome Navigation). **[PRÜFEN]**
- Relevant für die Drohne ist die Navigationsaufgabe mit Droning Sub-Task: autonome Sektorabdeckung in einem Drohnenkäfig, Bildaufnahme, ArUco-Marker, Pilot mit Sichtkontakt (Line of Sight). **[PRÜFEN]**
- Abgabedokumente des Teams: Proposal, Preliminary Report, Final Report mit Matrix of Compliance (`frost_MOC_Final_Report.xlsx`), Test Plan, RIO-Analyse, Lessons Learnt.

### Anforderungen mit Bezug zur Drohne bzw. zur Statusanzeige

Quelle ist der Testplan im Final Report des Teams (Req-IDs und Akzeptanzkriterien). Den genauen Wortlaut bitte im offiziellen ERC-2026-Regelwerk nachsehen, bevor er zitiert wird. **[PRÜFEN]**

| Thema | Req-IDs laut Testplan | Sinngemäße Anforderung |
|---|---|---|
| Aktivitätsindikator | REQ-OPS-060 bis -100 (T002) | Indikatorlampe muss bei Tageslicht sichtbar und aktiv blinkend sein (Beobachter in 10 m); aktiv mindestens 5 s vor jeder Bewegung von Rover/Drohne; Fahrzeug bleibt während dieser 5 s stehen |
| Autonomie-Anzeige | REQ-FUN-220, REQ-OPS-050 (T004, T005) | Autonomer Modus muss durch ein eigenes Anzeigemuster erkennbar sein; Operator darf nicht eingreifen können |
| Notfall Drohne | REQ-DES-060, REQ-OPS-070, REQ-DES-150 (T002, T005) | Not-Aus bzw. Verbindungsverlust löst Autoland aus (Testplan: innerhalb 3 s bzw. 5 s, uneinheitlich, nachprüfen) |
| Pilot-Override | T005 | RC-Fernsteuerung oder QGroundControl übernehmen jederzeit die Kontrolle |
| Geofence | REQ-FUN-240 (T009) | Strikter Geofence im Käfig |
| Sichtbarkeit/Licht | REQ-ENV-040 (T007d) | Betrieb bei schlechtem Licht, Bordbeleuchtung |
| Masse | Design-Schwelle 5 kg | DAEDALUS liegt weit darunter |

Die Zustände "armed", "autonom" und "Notfall" werden im Final Report als Anzeigezustände der Drohne genannt (unterschiedliche Farben/Blinkmuster). **[PRÜFEN]**

## 4. Team und Plattformen

- **FRoST** = Frankfurt Robotics Science Team, Frankfurt University of Applied Sciences. Kleines studentisches Team (unter zehn aktive Kernmitglieder), die Drohne gehört der Hochschule. Im Text wird "FRoST-Labor" gewählt; Hinweis: `\gls{frost}` liefert die Langform mit "Team", Lösung über `\acrshort{frost}-Labor`.
- **EROS** = Extreme Research and Observation System, Rover 2026. Nachfolger von ARES. 6-Achs-Arm, adaptives Fahrwerk, ca. 69 kg. Nur als Kontext erwähnen.
- **DAEDALUS** = Deployable Aerial Exploration Drone for Autonomous Low-altitude Utility Scouting. Nachfolger von **ICARUS** (Langform von ICARUS ist nicht dokumentiert).
- Die Drohne fliegt Luftaufklärung, sucht aussichtsreiche Probenorte und unterstützt die Lokalisierung. Arbeit im Team mit Aufgabenverteilung. Adrian leitet die Drohnenentwicklung und besitzt die ROS-2-Zustandsmaschine.

## 5. DAEDALUS: Stand der Technik im Team

**Hardware**

- Flugcontroller: Holybro Pixhawk 6C mit PX4
- Companion Computer: Raspberry Pi 5 mit ROS 2 Jazzy (Kamera, Autonomie, Zustandsmaschine)
- Motoren: Holybro 2216-920KV, 10-Zoll-Propeller, 4S-LiPo
- ESCs: derzeit wieder einzelne PWM-ESCs; das 4-in-1-ESC (Sequre Blueson A2, AM32, DShot) ist ohne Stromtelemetrie und vermutlich defekt, Ersatz gesucht
- Sensorik: GPS/Magnetometer, RTK-GPS, Optical-Flow-Sensor, Pi-Kamera
- LEDs: adressierbare SK6812 in den Landebeinen (Final Report: LED-Spotlighting im Landebein, Zustandsanzeige über Farben und Blinkmuster)

**Masse (Final Report, Stand geplante Konfiguration) [PRÜFEN]**

Frame 260 g, Motoren und Propeller 350 g, GPS 32 g, Flugcontroller 60 g, Raspberry Pi 46 g, Akku 420 g, Verkabelung 50 g, Kommunikation 40 g, Kamera 20 g. Summe 1278 g (rund 1,3 kg), deutlich unter der 5-kg-Schwelle und deutlich leichter als das Vorgängerdesign. Flugzeit rechnerisch ca. 6 min bei Hover (300 W nominal, davon Antriebe 295,5 W), in Tests übertroffen.

**Software und Architektur**

- PX4 für Kernfunktionen und Sicherheitslogik (Failsafes, Geofence, Autoland), eigene Autonomieebene auf dem Pi.
- ROS 2 und MAVLink (MAVROS) zur Kopplung, ArUco-/Objekterkennung, Trajektorieplanung, Harel-Zustandsmaschine (Agenten pro Missionsprofil).
- Eigene Bodenstation-Oberfläche mit Notfallschaltfläche, QGroundControl und RC-Fernsteuerung als Redundanz.
- Simulationsorientierte Entwicklung (Software-in-the-Loop in Gazebo, PX4 SITL/HITL, MATLAB/Simulink-Prototypen).

**Frame (3D-Druck)**

- Aktueller Frame: strukturelles Redesign mit Ziel Masse minimieren, Bauraum nutzen, Ansprechverhalten verbessern. Gedruckt in einem leichten, aber robusten Filament, laut Team-Material PA11-CF Super Light (Xenia) plus Carbonstab.
- Landefüße: TPU, 95A Shore, Empfehlung PolyFlex TPU95-HF, Gyroid-/Wabeninfill, hohle Strukturen. Drucker: Bambu Lab X1C.
- Materialien, die verglichen wurden: ASA, ASA-CF, PETG, PP, PA11, PA11-CF, TPU-Varianten (jeweils Dichte, Steifigkeit, Schlagzähigkeit).
- CAD: Autodesk Inventor. Auch Anforderungen an Zugänglichkeit: Akku und Stromkabel direkt erreichbar, leichter Austausch einzelner gedruckter Teile.
- **[PRÜFEN]** Konkrete Massen, Druckzeiten, Wandstärken, Orientierungen und Testergebnisse des neuen Frames stehen nicht in diesem Kontext, bitte aus Repo, CAD und Messdaten übernehmen.

**LED-Statusanzeige (nur grober Rahmen, Details im Repo)**

- Der Zustand wird über eine Zustandsmaschine (ROS 2) auf dem Raspberry Pi, dem Companion Computer des Flugcontrollers, ermittelt. Ein LED-Knoten abonniert die Zustände (Topic `SM_States`) und steuert die LEDs an.
- Hardware: SK6812-Strips als Daisy-Chain (Sterntopologie ist nicht möglich), 74AHCT125 als Pegelwandler (3,3 V auf 5 V), Test mit Arduino Nano.
- Pi 5: `rpi_ws281x` funktioniert wegen des RP1-Chips nicht, es sind PIO- oder SPI-basierte Wege nötig. Bei Versorgung über GPIO `usb_max_current_enable=1` setzen.
- Jury-Kriterium: Sichtbarkeit in 10 m bei Sonnenlicht, Aktivierung mindestens 5 s vor jeder Bewegung.
- **[PRÜFEN]** Konkrete Zustandsdefinition (welcher Zustand = welche Farbe/Muster), Implementierungsstand und Testergebnisse bitte aus dem Repo ableiten.

## 6. Wichtige Erkenntnisse aus dem Projekt (für Diskussion und Lessons Learnt)

- Käfigflug ohne echtes GPS: `EKF2_GPS_CTRL=0`, ein künstlicher globaler Ursprung wird per `SET_GPS_GLOBAL_ORIGIN` eingespeist. Dieser liegt nur im RAM des FC und geht bei Neustart verloren. Fix: bei `home_position_invalid` oder FC-Neustart neu senden.
- Ein versehentlicher Parameter-Reset in QGC ("Airframe, Apply and Restart") löscht alle eigenen Parameter. Backups der Parameter führen.
- Strom-Failure-Detection (`FD_ACT_EN`) liefert mit AM32-ESCs ohne Stromtelemetrie Fehlalarme.
- Teamweite Lessons Learnt aus dem Final Report: Verschleißteile nicht eingießen, sondern schraubbar und austauschbar auslegen; Logik zentralisieren und Kommunikationsframeworks vereinheitlichen; bei kritischer Elektronik immer eine kommerzielle Rückfalllösung (COTS) bereithalten.

## 7. Offene Aufgaben für den Bericht

1. Einleitung ausformulieren (Trichter: ERC, FRoST, Drohne, Problemstellung, Ziel, Aufbau).
2. Hintergrund und Stand der Technik mit echten Quellen befüllen (biblatex, `\cite`).
3. Anforderungen einmal sauber definieren (Frame und LED), auf die Evaluation und Ergebnisse verweisen.
4. Methodenkapitel aus Repo und CAD füllen, besonders LED-Teil und Zustandsmaschine (Zustandsdiagramm als Abbildung).
5. Tests durchführen bzw. dokumentieren, Ergebnisse als Tabelle Anforderung / Ergebnis / Status.
6. Kurzfassung um Ergebnisse ergänzen, Template-Reste (`NDNotice`, `LaTeXHowTo`) entfernen oder verschieben.

## 8. Regeln für dich

- Keine Zahlen, Normen oder Regelwerkszitate erfinden. Fehlende Werte als `TODO` markieren.
- Quellen im Bericht immer belegen, im Zweifel nachfragen.
- Kleine Schritte, kurze Rückfragen, bestehende Struktur erhalten.
