# Korrekturliste Bericht DAEDALUS

Stand: 16.11.2026, Branch `korrektur`. Grundlage sind `report_agent.md` (Schreibregeln) und `style_vorlage.md`
(Layout und Stil der Referenzarbeit). Der Bericht wurde vollständig gelesen, gebaut und zusätzlich automatisch geprüft
(Satzlänge, Satzzeichen, Wortliste, Verweise, Abkürzungen, Literatur).

## Stand der Umsetzung (16.11.2026)

Auf „fixe mir alles“ hin wurden P1 bis P3 und die neue Gliederung umgesetzt. Die Zeilenangaben unten beziehen sich auf
den Stand **vor** der Korrektur. Festgelegte Standards, solange die Fragen in Abschnitt 7 offen sind:

- Sprache nach `report_agent.md`, Aufbau, Abbildungen und Zitierstil nach `style_vorlage.md`.
- Layout der FRA-UAS-Vorlage (Schrift, Ränder, Kopf- und Fußzeile, römische Seitenzahlen) **unverändert**, weil
  Hochschulvorgaben laut `report_agent.md` Vorrang haben. P4-Layoutpunkte sind deshalb offen.
- Kurzfassung bleibt (überarbeitet).
- Fehlende Werte und Quellen sind im Text als `[WERT?]` sichtbar oder als `% [QUELLE?]` / `% [PRÜFEN]` kommentiert.

Neue Gliederung: 1 Einleitung, 2 Wettbewerb und Anforderungen, 3 Stand der Technik, 4 Entwickelte Methoden,
5 Evaluation, 6 Ergebnisse, 7 Diskussion (neue Datei `650_Diskussion.tex`), 8 Zusammenfassung und Ausblick.

Neu hinzugefügt und **bitte prüfen**:
- Frame-Anforderungen FR-01 bis FR-07 und NAV-01 (Tabelle 2.1) mit eigenen Kennungen, abgeleitet aus deinem Text.
- Abgrenzung in Kapitel 1 („Nicht Bestandteil dieser Arbeit sind …“).
- Tabelle 5.1 (Prüfung und Abnahmekriterium je Frame-Anforderung), FR-03 wird bisher nicht gemessen.
- Status der Frame-Anforderungen in Tabelle 7.1.
- Bib-Einträge `item24signale` und `ws2812btds`: Titel und Hersteller aus der URL abgeleitet, Abrufdatum fehlt.
- Quellen für Abbildung 3.2 (`alliedcn…`) und 3.3 (`werma…`) zugeordnet, weil die Einträge dafür angelegt waren.

Noch offen: Abschnitt 7 (Fragen), P4 (Layout), alle `[WERT?]`, `[QUELLE?]` und `[PRÜFEN]` im Quelltext.

---

Prioritäten:
- **P1** Fehler, die im PDF falsch oder kaputt sind. Sollten auf jeden Fall behoben werden.
- **P2** Inhaltliche Dopplungen, falsche Platzierung, zu starke Aussagen, Widersprüche.
- **P3** Stil nach den Direktiven (Wortwahl, Satzbau, Begriffe).
- **P4** Layout nach `style_vorlage.md`. Erst nach Entscheidung in Abschnitt 1.

---

## 1. Widersprüche zwischen den Direktiven (Entscheidung nötig)

Die beiden Dateien widersprechen sich an mehreren Stellen. `report_agent.md` legt eine Rangfolge fest, in der
`style_vorlage.md` nicht vorkommt. Vorschlag zur Auflösung:

| Thema | `report_agent.md` | `style_vorlage.md` | Vorschlag |
|---|---|---|---|
| Gedankenstriche | verboten als Satzverbinder | „häufig genutzt“ für Einschübe | `report_agent.md` gilt (Sprachregeln) |
| Doppelpunkt im Fließtext | vermeiden | Doppelpunkt-Konstruktionen erwünscht | `report_agent.md` gilt |
| Nominalstil | verboten | „oft mit Nominalstil“ | `report_agent.md` gilt |
| „im Rahmen dieser Arbeit“ | gehäuft vermeiden | feststehende Wendung | sparsam, höchstens 1–2 Mal |
| Rhetorische Fragen | verboten | in der Einleitung erlaubt | `report_agent.md` gilt |
| „spielt eine zentrale Rolle“ | verboten | als Beispielsatz genannt | `report_agent.md` gilt |
| Fett am Absatzanfang | kein Fettdruck zur Betonung | fetter Begriff am Absatzanfang als Listenersatz | erlaubt als Gliederungsmittel, nicht als Betonung |
| Listen vs. Fließtext | Ergebnisse und Diskussion als Fließtext | Grenzen als Aufzählung | Ergebnisse Fließtext, Grenzen als Liste erlaubt |
| Kurzfassung | – | Referenz hat keine | **Entscheidung nötig** (siehe P4) |
| Layout (Schrift, Ränder, Kopfzeile) | Vorgaben der Hochschule haben Vorrang | eigenes Layout der Referenz | **Entscheidung nötig.** `thesis.tex` ist die offizielle FRA-UAS-Vorlage (Prof. Hollstein). Falls sie vorgeschrieben ist, steht sie über `style_vorlage.md` |

Kurz: `report_agent.md` gilt für **Sprache**, `style_vorlage.md` für **Layout, Aufbau, Abbildungen, Tabellen,
Zitierweise**. Ausnahme ist das Layout, falls die FRA-UAS-Vorlage verpflichtend ist.

Hinweis: `report_agent.md` verweist auf `vorgaben/` und `ANLEITUNG.md`. Beide existieren nicht und werden ignoriert.
Abschnitt 9 (Betreuervorgaben) und 10 (Projektregeln) sind noch leer. Vorschlag für Abschnitt 10 siehe Abschnitt 7
dieser Datei.

---

## 2. P1: Fehler im PDF

### 2.1 Build und Verweise
- [ ] `400_EntwickelteMethoden.tex:81-86` Die Armabbildung trägt Caption und Label der Quadcopter-Abbildung aus
  Kapitel 3 (`fig:Quad_Konfigurationen`, „Quadcopter-Konfigurationen H, Plus und X …“ mit Zitat). Folgen:
  - Label doppelt definiert, Warnung im Build.
  - `fig:Arme_CAD` und `fig:Arme_Zeichnung` (Zeile 70) sind undefiniert und erscheinen im PDF als „??“.
  - Das CAD-Bild `\dronearme` wird nicht mehr verwendet.
  - Lösung: eigene Caption und eigenes Label, Verweise in Zeile 70 anpassen.
- [ ] `400_EntwickelteMethoden.tex:63` Tabelleneintrag `motor_link_right` endet mitten im Satz („… an der Motorseite. Beide“).
- [ ] `200_Hintergrund.tex:16-17` Kopierfehler: Zeile 16 enthält das Satzfragment „nes Drehschalters, das“, Zeile 17
  „eines Hebel- und eiBedienen eines …“. Richtig wäre „das Betätigen eines Hebel- und eines Drehschalters, das Bedienen …“.
- [ ] `500_Evaluation.tex:50` `\hyperlink{https://…}` ist der falsche Befehl für eine URL (springt auf ein internes
  Ziel). Richtig: `\href{https://logs.px4.io/}{Flight Review}` plus Quelle.
- [ ] `400_EntwickelteMethoden.tex:308` Kommentar „photo has EXIF rotation“ ist veraltet, das Foto ist inzwischen gedreht. Kommentar löschen.

### 2.2 Literaturverzeichnis
- [ ] `thesis.tex:366` `\nocite{*}` druckt **alle** Einträge der `.bib`, auch nicht zitierte. Dadurch stehen
  Vorlagen-Quellen im Verzeichnis, die nichts mit der Arbeit zu tun haben: Homeoffice/Corona (Deutschlandfunk),
  Coworking Spaces (Gauger), Post-Corona-Stadt (Libbe), Arbeitswelt (Beermann), Soziale Praktiken (Friese), „Wohnen
  am Campus“, VDI und DaaS (oneclick). Lösung: `\nocite{*}` entfernen und Vorlageneinträge aus `bibliography.bib` löschen.
- [ ] `bibliography.bib:147-153` Die Einträge `item24signale` und `ws2812btds` sind leer, die URLs stehen außerhalb
  der Einträge. Im PDF erscheinen sie als „[1] .“ und „[2] .“. Biber meldet „junk seen at toplevel“. Felder
  (author/title/url/urldate) eintragen. Die URLs stehen schon in der Datei.
- [ ] Nicht zitierte, aber passende Quellen in der `.bib`: `alliedcnWhatIsFDM3DPrinting` (passt zu Abbildung 3.2),
  `wermaSignalsaeulen` (passt zu Abbildung 3.3), `rineyHexacopterVsQuadcopter2026`, `unmannedtechQuadcopterFrameDesign`,
  `adobestockMotorOrderDiagrams`. Zitieren oder löschen.
- [ ] Fehlende Quellen (`[QUELLE?]`):
  - ERC-Regelwerk (REQ-FUN-070 als direktes Zitat in `400:171`, alle REQ-Nummern, „EU-Richtlinien“ in `200:29`, 124 Registrierungen/29 Länder in `200:10`)
  - ERC Final Report (2290 g in `600:13`)
  - Holybro X500 V2 (`100:15`, `300:55`)
  - Xenia PA11-CF-SL Datenblatt (Dichte 0,99 g/cm³ in `400:145`)
  - ASA-Dichte 1,07 g/cm³ (`400:145`)
  - Temperatur am Rand des Druckbetts, 10 K (`600:74`)
  - Bambu Lab X1-Carbon (`300:101`)
  - pyulog, Flight Review, PX4 ULog Viewer (`500:50`)
  - `rpi_ws281x`, Adafruit-Bibliothek, RP1 (`400:333-335`)
  - RFC 8949 (`400:362`), ROS 2 Jazzy, MAVROS
  - FEM bei gedruckten Teilen „schwierig bis unmöglich“ (`500:32`)
- [ ] Abbildungen 3.2 (`fdm_printing.jpg`) und 3.3 (`maschinenampel.png`) haben keine Quellenangabe. Sie sind
  vermutlich übernommen. Eigene Abbildungen nach `style_vorlage.md` Abschnitt 8 mit „(eigene Darstellung)“ kennzeichnen.
- [ ] Zitierstil: `style=numeric, sorting=nyt` sortiert alphabetisch. `style_vorlage.md` verlangt IEEE, nummeriert in
  Reihenfolge des ersten Zitats (`style=ieee`, Standardsortierung).

### 2.3 Abkürzungen (`005_Acronyms.tex`)
- [ ] Zeile 12: Kurzform von `icarus` ist „IRCARUS“ (Tippfehler, es fehlt außerdem eine klare Aussage, was ICARUS ist, siehe 3.4).
- [ ] Zeile 15: `fmd` definiert „FDM“ ein zweites Mal. Wird in `300:59` und `300:64` statt `fdm` benutzt. Eintrag
  löschen, Stellen auf `fdm` umstellen.
- [ ] Zeile 10: Langform „European-Rover-Challenge“ mit Bindestrichen, richtig „European Rover Challenge“.
- [ ] `eros` und `dds` werden nie benutzt. Löschen.
- [ ] Viele Abkürzungen stehen als Klartext statt mit `\gls` (LED etwa 120-mal, ROS 13-mal, außerdem ERC, PIO, GPIO,
  CAD, FDM). Die Erstnennung wird dadurch nicht sicher ausgeschrieben. Mindestens die erste Nennung je Abkürzung prüfen.
- [ ] Nicht definiert, aber benutzt: FC (`400:149`), ESC wird teils frei geschrieben (`300:10`), SPI, DMA, PWM, MOSI,
  USB, SSH, WLAN, RMS, CFK, CF, PA, TPU, ASA, PET-G, PLA, ABS, FPV, FEM, UV.

### 2.4 Titelseite und Erklärung
- [ ] `001_Titlepage.tex:57` „Praxisbeauftragter: Prof. Dr. Karsten Schmidt“. Für ein Hochschulprojekt passt „Betreuer“
  bzw. „Erstbetreuer“. `\CoSupervisor` (Adrian Hopfenspirger) wird nirgends ausgegeben.
- [ ] `000_Settings.tex:5` `\ThesisDegree` = „Bachelor of Engineering B.Eng.“ wird auf der Titelseite unter
  „Mechatronikprojekt“ gedruckt. Bei einem Projektbericht prüfen, ob das stehen soll.
- [ ] `003_Declaration.tex:50` „LaTEX“ → „\LaTeX“. Abschnittsangaben „Kapitel 1–7“ und „Kapitel 2–6“ am Ende prüfen.
- [ ] `900_Anhang.tex` erzeugt ein leeres Kapitel „Anhang“. Füllen (z. B. `sil`-Befehlsreferenz, TODO in `400:474`) oder entfernen.

---

## 3. P2: Inhalt, Dopplungen, falsche Platzierung

### 3.1 Dopplungen zwischen Kapiteln

| Inhalt | Kommt vor in | Vorschlag |
|---|---|---|
| ERC: 25 Teams, sieben Aufgaben, Rover mit Drohne | `100:8` und `200:10` | nur in 2.1, in 1.1 ein Satz mit Verweis |
| FRoST-Labor, Projekte für Studierende | 1.1 (`100:8-10`) und 2.2 (`200:50-55`) | zusammenlegen, 2.2 verweist bisher nur zurück |
| Grundlagen FDM (schichtweise, additiv, Hohlräume, Slicer) | 2.3 (`200:57-67`) und 3.2.1 (`300:64-73`) | nur einmal, am besten in 3.2.1 |
| „Zudem ist es wichtig, die Belastungspunkte des Bauteils zu kennen …“ | wörtlich `300:94` und `300:99` | einmal streichen |
| X500-V2-Kit als Basis | `100:15` und `300:55` | einmal ausführlich, einmal Verweis |
| Anforderungen an die Anzeige | Tabelle 2.1 (`200:33`), 3.3.3 (`300:132`), 4.2.1.1 (`400:165`), Tabelle 5.1 (`500:57`) | ein zentraler Anforderungsabschnitt (siehe 3.3) |
| Navigationslicht links grün, rechts rot | `300:134` und `400:193` | Anforderung an einer Stelle, Umsetzung an der anderen |
| „Formal gilt diese Anforderung nur für den Rover …“ (REQ-DES-060) | wörtlich `400:180` und `500:140` | in 5 streichen |
| Flugtest der LEDs nicht möglich (Ubuntu ohne PIO, Pi OS ohne Flug-Stack) | `400:482`, `500:151`, `600:267`, `600:310`, `700:13`, `700:18` | Begründung einmal in 4.2.5, sonst Verweis |
| Grenzen der SIL-Testumgebung | `400:478-482`, `500:155`, `600:267`, `600:321` | einmal in 4.2.5.6, in 5/6 nur Verweis |
| Pegelwandler fehlt | `400:329`, `500:144`, `600:314`, `700:38` | Methoden: geplant. Diskussion: Grenze. Ausblick: ein Satz |
| Autostart in `autonomy_master` fehlt | `500:151`, `500:153`, `600:316`, `700:48` | Diskussion und Ausblick reichen |
| Watchdog fehlt | `400:403`, `600:317`, `700:49` | Diskussion und Ausblick reichen |
| Frame-Probleme (Motorausrichtung, Akku, Anbauteile, Verzug) | fast wortgleich `600:303-307` und `700:24-29` | Diskussion = Befund und Deutung, Ausblick = nur Maßnahme |
| Drei Wege zum Flugbetrieb (SPI, Mikrocontroller, Pi OS) | Ausblick-Einleitung `700:18` und erneut `700:36-37`, `700:47` | in der Einleitung nur ein Satz |
| Düsentemperatur angepasst | `400:153` und `600:74` | `600:74` verweist auf „in Kapitel 4 beschriebene Düsentemperatur“, dort steht aber kein Wert. Wert ergänzen `[WERT?]` |

### 3.2 Falsche Platzierung
- [ ] **Methode im Ergebniskapitel:** Die Auswertung der Flugdaten (Auswahl „ruhiges Schweben“, Grenzwerte 0,3 und
  0,2 m/s, freier Flug bis Netzkontakt) steht in 6.1.6 (`600:147-152`). Das ist Vorgehen und gehört nach 5.2.6
  (`500:46-50`). 5.2.6 beschreibt bisher nur Werkzeuge.
- [ ] **Evaluation passt nicht zu den Ergebnissen:**
  - 5.2.1 (`500:20`) sagt, der Slicer vergleiche die gedruckten Teile mit den Carbonteilen. 6.1.1 vergleicht im
    Slicer aber ASA mit PA11. Der Carbonarm kann im Slicer nicht berechnet werden.
  - 5.2.4 (`500:38`) bewertet den Fertigungsaufwand qualitativ über die Nachbearbeitung. 6.1.4 misst Zeiten.
  - 5.2.3 (`500:32`) nennt keine Fallhöhen, 6.1.3 nutzt 20/50/80 cm.
- [ ] **5.1 Vorgehen und Bewertungskriterien** (`500:11`) behandelt nur Maßhaltigkeit des Frames. Die Statusanzeige
  fehlt. Toleranzen werden erwähnt, aber nie beziffert (`[WERT?]`).
- [ ] **Anforderungen an den Frame fehlen komplett.** Der Abschnitt ist in `400:6-9` auskommentiert, Tabelle 6.6
  (`600:287`) hat nur LED-Anforderungen. Die Zusammenfassung behauptet trotzdem, das Ziel des Frames sei
  „komplett erreicht“ (`700:7`).
- [ ] **3.3.3 „Anforderungen und Normen“** (`300:132`) nennt keine Normen. Entweder Normen ergänzen (z. B. für
  Signalfarben) oder umbenennen.
- [ ] **3.4 Zusammenfassung und Ableitung** (`300:139`) hat keinen Inhalt. Sie leitet nichts ab. Neu schreiben (Lücke
  und Ziel der Arbeit) oder streichen.
- [ ] **Kapitel 1** hat kein Ziel und keinen Aufbau. Die Gliederung der Arbeit fehlt (`100:24` ist nur ein Kommentar).
- [ ] **Diskussion als Abschnitt von „Ergebnisse“:** `report_agent.md` 7 verlangt die Trennung von Ergebnis und
  Deutung, `style_vorlage.md` 4 sieht ein eigenes Kapitel „Diskussion“ vor. Vorschlag: 6.3 als eigenes Kapitel.
- [ ] **Verweis falsch:** `400:329` verweist für den Pegelwandler auf `sec:Erg_LED`. Dort steht nichts dazu, er steht in `sec:Diskussion_Grenzen`.

### 3.3 Widersprüche und Aussagen, die zur Evidenz nicht passen (`report_agent.md` 4)
- [ ] `700:7` „Das Ziel des neuen Frames ist komplett erreicht worden“: Masse noch offen (XX), keine
  Frame-Anforderungen, schlechtere Motorausrichtung festgestellt. Abschwächen.
- [ ] `700:9` „Reduzierung des Gesamtgewichtes identifiziert“ auf Basis der Flight-Logs: Die Logs enthalten keine
  Masse. Der Schwebeschub sank, aber laut `600:202` ist nicht trennbar, ob das am Frame oder am Akku liegt.
- [ ] `700:11` „Keiner dieser Punkte ist kritisch, und alle lassen sich mit geringem Aufwand beheben“: Die Ursache
  der Motorverkippung ist nicht bekannt. Abschwächen.
- [ ] `600:110` „Das Taumeln … ist keine Schwäche des Frames“ und „Im Flugbetrieb würde die Regelung die Lage …
  halten“: Vermutung, nicht gemessen. Mit „vermutlich“ oder „spricht dafür“ formulieren.
- [ ] `600:307` „so groß, dass sie davon nicht in Frage gestellt wird“: zu stark. Nur ein Flug mit altem Frame,
  andere Modi. Besser: „Die Verbesserung ist deutlich größer als die Streuung zwischen den drei neuen Flügen.“
- [ ] `600:181` „Die Ursache liegt sehr wahrscheinlich in steiferen Armen und einer besseren Entkopplung“: nicht
  gemessen. „lässt sich vermutlich … erklären“.
- [ ] Pegel der Datenleitung widersprüchlich: `400:329` „liegt [im] unteren Bereich der Schaltschwelle“ gegenüber
  `600:314` „obwohl … mindestens 3,5 V vorgesehen sind“. Nach Datenblatt (V_IH = 0,7 × V_DD = 3,5 V) liegen 3,3 V
  **unter** der Schwelle. Einheitlich formulieren. Außerdem fehlt in `400:329` ein Wort („Das liegt **im** unteren …“).
- [ ] Dichteunterschied: `400:145` „ASA … etwa 8 % schwerer“, `600:50` „Ersparnis von etwa 7,5 %“. Beides stimmt
  (andere Bezugsgröße), wirkt aber widersprüchlich. Einheitlich auf PA11 als Ersparnis von 7,5 % beziehen.
- [ ] Überschrift `400:343` „Software: Zustandsautomat auf dem Companion Computer“, erster Satz: „Die Software der
  Anzeige ist selbst kein Zustandsautomat.“ Überschrift widerspricht dem Text. Vorschlag „Software der Statusanzeige“.
- [ ] `400:174` „gewährleisten“, `400:397` „garantiert synchron“, `400:456` „ohne noch etwas zu beweisen“,
  `400:480` „bestätigt“, `600:314` und `700:38` „gewährleistet“: nach Abschnitt 4 abschwächen („stellt sicher“ ist
  ok bei Konstruktionsentscheidungen, nicht bei Ergebnissen).
- [ ] `300:20` „Der entscheidende Nachteil“, `400:91` „optimale Stabilität“, `400:139` „ASA ist die beste günstige
  Lösung“, `400:140` „bester, aber teurer Frame“: ohne Bezug. Mit Bezug formulieren („die höchste Belastbarkeit der
  drei Varianten“).
- [ ] `200:29` „Durch EU-Richtlinien darf die Drohne nur in diesem Käfig autonom fliegen“: Quelle oder abschwächen
  („laut Regelwerk der ERC“).
- [ ] Tabelle 2.1 `200:43` „Obergrenze für die Gesamtmasse“: Wert fehlt `[WERT?]`.

### 3.4 Unklare Begriffe und Namen
- [ ] **Drohnennamen:** DAEDALUS ist laut `100:15` die Drohne aus dem X500-Kit. ICARUS ist laut `200:55` der
  Vorgänger mit Carbonframe, laut `400:14` die Vorgängerversion als CAD-Baugruppe. Das ROS-Paket heißt
  `icarus_led_controller`. Unklar ist, ob DAEDALUS der neue Frame oder die ganze Drohne ist und ob ICARUS eine andere
  Drohne oder der alte Frame derselben Drohne ist. `[PRÜFEN]` und einmal klar definieren.
- [ ] **Bauteilnamen:**
  - `400:23` nennt `baseplate_top/bottom`, die Tabelle 4.1 hat sie nicht.
  - `400:79` „base_link top und bottom“, die Tabelle 4.1 nennt `link_top`/`link_bottom`.
  - Tabelle 6.2 (`600:42-43`) führt `link_top`/`link_bottom` kursiv mit Material „XX“.
  - Einheitlich in `\texttt{}` und mit denselben Namen.
- [ ] **Anzahl Bauteile je Arm:** `600:23` „sechs gedruckte Bauteile“. Tabelle 6.2 listet aber beide `motor_link`
  (links und rechts) plus `link_top`/`link_bottom`, die eher zur Baseplate gehören. `[PRÜFEN]`
- [ ] **Bauteile 4.1.3:** `400:96` Motorfuß „im Vorfeld schon auf ein bestimmtes Material bedacht designed“, „davon
  ab zu designen“: unklar formuliert.

---

## 4. P3: Sprache nach `report_agent.md`

### 4.1 Rechtschreibung und Tippfehler (Auswahl, keine Inhaltsänderung)

| Stelle | Fehler | Korrektur |
|---|---|---|
| `010:4` | Fokusierung, 3D-Druck optimierte | Fokussierung, 3D-druckoptimierte |
| `100:8` | ausgeschrieben um, ein internationaler Wettbewerb | Komma vor „um“, „einem internationalen Wettbewerb“; dritter Satz ohne Verb |
| `100:10` | in vergangen Jahren, Mechatronik Master Studenten, von Zeit zur Zeit | vergangenen, Mechatronik-Masterstudierende, von Zeit zu Zeit |
| `100:15` | Holybro X500 V2 kit, Drohennaufgabe, von seitens | Kit, Drohnenaufgabe, seitens |
| `200:4` | im folgenden | im Folgenden (Ankündigungssatz ohnehin kürzen) |
| `200:10` | das können | das Können |
| `200:15` | auf den Boden, drei mal | auf dem Boden, dreimal |
| `200:29` | 10x10x4 meter | \SI{10 x 10 x 4}{m}; Satz umbauen |
| `200:53` | ein erarbeiten | das Erarbeiten |
| `200:55` | zum entdecken | zum Entdecken |
| `300:4` | betrachet | betrachtet; Satz ohne Hauptverb im zweiten Teil |
| `300:25` | FÜr, ausgwählt | Für, ausgewählt |
| `300:55` | letzen, dei, augewählt, Die ist, viel Erweiterbar, Holy Bro | letzten, die, ausgewählt, Dies ist, gut erweiterbar, Holybro |
| `300:66` | das fertigen, vielzahl | das Fertigen, Vielzahl (Wort ohnehin ersetzen) |
| `300:78` | vorgefertig, sich zu verschaffen | vorgefertigt, Satzstellung |
| `300:82` | Polylactid acid, ode, leichtigkeit | Polylactid (polylactic acid), oder, Leichtigkeit |
| `300:85` | Es ist genau so fast genauso schwierig | Es ist fast genauso schwierig |
| `300:86` | pder, abkühlen, nur PA Zusätzen | oder, Abkühlen, nur PA mit Zusätzen |
| `300:99` | erarbeiten, eintscheidene, konstruieren | erarbeiteten, entscheidende (Wort ersetzen), Konstruieren |
| `300:112` | im Bild, Zuständer | in Abbildung, Zustände |
| `300:128` | eigenene, LEDS, wo durch | eigene, LEDs, wodurch (Satz umbauen) |
| `300:139` | aufarbeiten, vorhanden, Ergbenisse, altenativ | ganzer Absatz neu |
| `400:4` | Entwickelten, Design entscheidungen, Umgesetzt | entwickelten, Designentscheidungen, umgesetzt; zweiter Satz ohne Verb |
| `400:14` | dDrohne | Drohne |
| `400:23` | So konnte … beide Bauteile automatisch neu anpassen | Subjekt fehlt |
| `400:91` | Diese Entscheidung, dargstellt | Diese Entscheidungen, dargestellt |
| `400:95` | ein größere Kreis, Auschnitt, Konstruktionsbedingte | ein größerer Kreis, Ausschnitt, konstruktionsbedingte |
| `400:143` | MAterialksoten | Materialkosten |
| `400:149` | Platzsparend, über den FC | platzsparend, über dem FC |
| `400:153` | ausgestauscht, jeglich | ausgetauscht, lediglich |
| `400:155` | vorgesehen, installation, eingeschmozlenes | vorgesehenen, Installation, eingeschmolzenes |
| `500:4` | Entwickelten Methoden Evalutiert und Bewertet, Evalutation | entwickelten Methoden evaluiert und bewertet, Evaluation |
| `500:11` | Bewertet, verziehen, TOleranz, kein zu großen | bewertet, Verziehen, Toleranz, keinen zu großen |
| `500:20` | messen, Eine … Waage war für das Abmessen … | Messen; Satz unvollständig („war … vorhanden“?) |
| `500:38` | wie einfach oder einfach, ein teils Zeitintensive | wie einfach oder schwierig, eine teils zeitintensive |
| `500:50` | Evalution, der Visuelle, Log dateien, verleichen Anzeigen | Evaluation, der visuellen, Logdateien, vergleichen anzeigen |

### 4.2 Satzzeichen
- [ ] Doppelpunkte im Fließtext ohne folgende Liste oder Gleichung (13 Stellen): `300:101`, `300:130`, `400:145`,
  `400:174`, `400:218`, `400:385`, `400:389`, `400:397`, `400:482`, `500:78`, `500:151`, `700:18`. Auch
  `200:41` (Semikolon in Tabelle) und die Überschrift `400:343` („Software: …“, `style_vorlage.md` 2 erlaubt keine
  Doppelpunkte in Überschriften).
- [ ] Gerade Anführungszeichen `"…"` in `300:55`. Durchgehend `\enquote{}` (csquotes ist geladen) oder `\glqq…\grqq{}`.
- [ ] Beschreibungslisten mit Doppelpunkt im Label (`400:94-96` „Motorarme:“) gegenüber allen anderen ohne. Einheitlich ohne.

### 4.3 Wortwahl (Liste aus `report_agent.md` 5)
- [ ] „Zudem“ 12-mal, teils mehrfach pro Absatz (`300:20`, `300:86`, `300:92`, `300:94`, `300:99`, `300:134`,
  `400:140`, `400:145`, `400:397`, `500:20`, `200:63`). Höchstens einmal pro Absatz.
- [ ] „sowie“ 20-mal, „Vielzahl“ (`300:78`, `300:128`), „ausführlich“ (`200:4`), „entscheidend“ (`300:20`),
  „zentrale Anforderung“ (`400:168`), „eine große Rolle spielen“ (`100:15`), „zur heutigen Zeit“ (`100:10`).
- [ ] „man“ (`200:61`, `400:432`, `400:465`). Unpersönlich formulieren.
- [ ] „Sektion“ (`300:10`, `300:62`, `300:106`) ist ein Anglizismus. „Abschnitt“.
- [ ] Ankündigungssätze („In diesem Kapitel werden …“, „Im Folgenden werden …“): pro Kapitel ein kurzer Satz erlaubt,
  in `300:4`, `300:10`, `300:62`, `300:106` sind es mehrere pro Kapitel.
- [ ] Fettdruck im Fließtext: Platzhalter `\textbf{XXXX}` in `600:12` und `600:14`. Als `[WERT?]` markieren.

### 4.4 Satzbau
- [ ] Sätze über 35 Wörter: `400:174`, `500:81`, `500:155`. Viele weitere liegen bei 30–35 Wörtern mit zwei
  Nebensätzen, vor allem in Kapitel 3 und 5.
- [ ] Nominalstil und Funktionsverbgefüge, z. B. `500:50` „ist … durch … umgesetzt worden“, `400:4` „aufgearbeitet und
  im Detail beschrieben“, `300:4` „eine Zustandsaufnahme der Software“, `500:38` „Die Bewertung … wurde … festgelegt“.
- [ ] Ein-Satz-Absätze: `700:9`, `400:346`, `600:94`, `600:134`. Zusammenführen.

### 4.5 Einheitliche Begriffe (Vorschlag für `report_agent.md` Abschnitt 10)

| Nicht verwenden | Stattdessen |
|---|---|
| Flightcontroller, Flugcontroller, FC | Flight Controller (oder durchgehend Flugcontroller) |
| baseplate, Baseplate, Grundplatte, Platte | Baseplate (Bauteilname `\texttt{}` nur für Dateien) |
| Karbon, Carbon, CFK, Carbonfaser | Carbon (CFK nur als Abkürzung in Tabellen) |
| Statemachine, Zustandsautomat, Zustandsmaschine | Zustandsmaschine |
| Motorarme, Verbindungsarme, Motorverbindungen | Arm (Bauteil `motor_link`) |
| Motorhalter, Motorhalterung, Motorträger | Motorhalter |
| Batterie, Akku | Akku |
| LED-Controller, LED-Knoten | LED-Knoten |
| Drohnenkäfig, Arena | Drohnenkäfig |
| Statusanzeige, Flugmodusanzeige, LED-Indikatoren, Zustandsindikatoren | Statusanzeige |

Außerdem: Zahlen null bis zwölf im Fließtext ausschreiben (`report_agent.md` 8), z. B. „5 LEDs“ → „fünf LEDs“ wo
ohne Einheit. Einheiten durchgehend mit `\SI` (`400:95` „2 mm“).

---

## 5. P4: Layout und Aufbau nach `style_vorlage.md`

**Erst umsetzen, wenn geklärt ist, ob die FRA-UAS-Vorlage verpflichtend ist** (siehe Abschnitt 1).

| Punkt | Aktuell | `style_vorlage.md` |
|---|---|---|
| Schrift | Carlito (Calibri-Ersatz), serifenlos, 11 pt | Latin Modern Roman, 12 pt |
| Ränder | links/rechts 2 cm | je ca. 31 mm |
| Kopfzeile | links Kapitel, Mitte Abschnitt, rechts Hochschullogo | mittig Kapitelname kursiv mit Nummer |
| Fußzeile | Mitte „Mechatronikprojekt“, rechts Seitenzahl | links Hochschullogo, Mitte Seitenzahl, rechts FRoST-Logo |
| Seitenzahlen | römisch für Verzeichnisse, dann arabisch | durchgehend arabisch ab Titelseite |
| Überschriften | Abschnitte blau (CI-Farbe) | schwarz, Serifenschrift |
| Gliederungstiefe | 4 Ebenen nummeriert (z. B. 4.2.1.1) | 3 Ebenen, darunter unnummerierte `\paragraph` |
| Titelseite | ein Logo, „Praxisbeauftragter“, kein Ort/Datum unten | zwei Logos, Linien, Betreuerblock, Ort und Datum |
| Kurzfassung | vorhanden (3 Sätze) | keine |
| Anhang | leeres Kapitel | keiner |
| Zitierstil | numerisch, alphabetisch sortiert | IEEE, Reihenfolge des Zitats |
| Abbildungen | kurze Captions, ohne „(eigene Darstellung)“ | lange, beschreibende Captions, eigene Abbildungen gekennzeichnet |
| Morphologischer Kasten | farbige Schrift | hellgrün/grau hinterlegte Zellen mit Legende |
| Listen | `description` mit Zeilenumbruch | `itemize` oder Absätze mit fettem Anfangsbegriff, Ausblick als `\paragraph` |
| Erklärung | KI-Tabelle ohne Fußnoten-URL | URL als Fußnote mit Abrufdatum |

Technische Kleinigkeiten in `thesis.tex`:
- [ ] `\usepackage{babel}[ngerman]` ist falsche Syntax (Option gehört vor den Paketnamen). Sprache kommt bisher über die Klassenoptionen.
- [ ] `\usepackage[T1]{fontenc}` ist auskommentiert. Ohne T1 trennt LaTeX Wörter mit Umlauten schlecht.
- [ ] `paralist` und `enumitem` sind beide geladen (bekannter Konflikt, daher die `description`-Umwege).
- [ ] `graphicx` und `xcolor` werden doppelt geladen, `listings` (Lua) und `wasysym` (Likert) werden nicht genutzt.
- [ ] Quelltext-Zeilen sind teils über 1000 Zeichen lang. `report_agent.md` 8 verlangt höchstens 120 Zeichen. Das ist
  rein mechanisch und kann beim Überarbeiten der Absätze mit erledigt werden.

---

## 6. Vorschlag für die neue Gliederung (wartet auf Okay)

Die Gliederung behält die Inhalte, beseitigt aber die Dopplungen und trennt Methode, Ergebnis und Diskussion:

1. **Einleitung** (ca. 1 Seite, ohne Unterkapitel): FRoST, ERC und Drohne kurz, Problem (schwerer Carbonframe,
   fehlende Statusanzeige), Ziel, Aufbau der Arbeit
2. **Grundlagen und Anforderungen**
   - 2.1 European Rover Challenge und Drohnenaufgabe
   - 2.2 Anforderungen an Frame und Statusanzeige (eine Tabelle mit allen REQ, inklusive Frame-Anforderungen), Abgrenzung
3. **Stand der Technik** (Multicopter, Frames, FDM-Druck einschließlich der bisherigen Grundlagen aus 2.3, Materialien,
   Statusanzeigen), 3.x Fazit mit Ableitung der Lösungsrichtung
4. **Entwickelte Methoden** (wie bisher, Gliederung bis x.y.z, darunter `\paragraph`)
5. **Evaluation** (Vorgehen einschließlich Flugdaten-Auswertung aus 6.1.6, Bewertungskriterien je Anforderung)
6. **Ergebnisse** (nur Messwerte und Beobachtungen)
7. **Diskussion** (bisher 6.3: Anforderungserfüllung, Deutung, Grenzen)
8. **Zusammenfassung und Ausblick**

---

## 7. Offene Fragen an dich

1. Ist die FRA-UAS-Vorlage (Schrift, Kopfzeile, Ränder) vorgeschrieben, oder soll das Layout auf `style_vorlage.md` umgestellt werden?
2. Soll die Kurzfassung bleiben?
3. Ist die Auflösung der Widersprüche aus Abschnitt 1 so in Ordnung?
4. Wie hängen DAEDALUS, ICARUS und der alte Frame zusammen (Abschnitt 3.4)?
5. Welche Anforderungen gelten für den Frame (Masse, Fußabdruck, Wartbarkeit, …), und gibt es Zahlenwerte?
6. Ist die neue Gliederung aus Abschnitt 6 okay?
7. In welcher Reihenfolge soll korrigiert werden? Vorschlag: P1 → Gliederung → P2 → P3 kapitelweise → P4.
