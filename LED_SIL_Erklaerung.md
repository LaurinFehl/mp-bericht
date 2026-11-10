# LED-Statusanzeige mit Software-in-the-Loop: Erklärung für den Bericht

> **Was diese Datei ist:** Eine code-verifizierte Erklärung der LED-Statusanzeige von
> \gls{daedalus} und ihrer Software-in-the-Loop-Testumgebung (SIL). Sie dient als Vorlage für den
> Abschnitt `\section{LED-Statusanzeige}` (`sec:LED`) in `TeXFiles/400_EntwickelteMethoden.tex`
> und liefert Material für `sec:Eval_LED` (Evaluation) und `sec:Erg_LED` (Ergebnisse).
>
> **Für wen:**
> 1. **Für Claude**, das den Text in den Bericht einarbeitet. Die Gliederung, die Labels, der
>    LaTeX-Code und die Fakten sind vorgegeben, das Ausformulieren ist deine Aufgabe.
> 2. **Für Laurin**, um den Aufbau mündlich erklären zu können. Deshalb steht zu jeder
>    Designentscheidung das *Warum*.
>
> **Quelle und Stand:** Repo `icarus_led_controller`, Branch `dev/led-sil`, Stand nach dem
> **Rework der Anzeigemuster vom 2026-11-10** (Commit nach `1781c9f`). Basis-Verifikation am
> 2026-11-09: Quelltext gelesen, eine Nachricht mit dem echten Encoder der Zustandsmaschine
> erzeugt und wieder dekodiert, Testsuite ausgeführt. Am 2026-11-10 nach dem Rework erneut:
> Testsuite ausgeführt und alle neuen Muster per SIL an den echten LEDs der Drohne geprüft.
> Ergänzend wurden die Anforderungs-IDs direkt im Original-Excel
> `[Appendix 3] Requirements Rev.2.xlsx` nachgeschlagen.
>
> **Was sich am 2026-11-10 geändert hat** (falls schon Text aus einer älteren Fassung im Bericht
> steht, diesen ersetzen): Gelb als dritte Statusfarbe, grünes Lauflicht für `READY`,
> grün/gelber Wechsel für `TAKEOFF`, eigenes Signal „keine Daten" (ganzer Streifen blitzt),
> `FC_ERROR` zählt als „keine Verbindung", Bedienung des SIL per Kommandozeile über SSH statt
> über das Laptop-Panel. Betroffen sind die Abschnitte 2, 4.1, 4.3, 5.2, 6, 7, 8.2 und 10.

---

## 0. Regeln für das Einarbeiten (an Claude)

- Es gelten alle Konventionen aus `projectcontext.md`: `\input` statt `\include`, Labels `sec:`
  `fig:` `tab:`, Verweise mit `~\ref{}`, Abkürzungen über `\gls{}`, technisch präzises Deutsch,
  LaTeX-Kommentare auf Englisch, bei Formulierungsvorschlägen drei Alternativen.
- **Alles in dieser Datei ist am Code belegt**, außer was als **[PRÜFEN]** oder **TODO** markiert
  ist. Keine Zahlen ergänzen, die hier nicht stehen. Messergebnisse wie Sichtbarkeit oder
  Flugtest existieren noch nicht und bleiben `TODO`.
- Code-Bezeichner (Dateinamen, Topics, Klassen) im Fließtext mit `\texttt{}` setzen, Unterstriche
  escapen: `\texttt{led\_node}`.
- Der Bericht beschreibt *Konzepte und Entscheidungen*, keine Zeile-für-Zeile-Codebeschreibung.
  Die Datei-für-Datei-Tabelle in Abschnitt 4.1 ist Hintergrundwissen. Sie passt höchstens
  verkürzt in den Anhang (`900_Anhang`).

### 0.1 Korrekturen zu `projectcontext.md`

Die folgenden Angaben in `projectcontext.md` widersprechen dem Code bzw. dem Regelwerk. Im
Bericht gilt die rechte Spalte.

| `projectcontext.md` sagt | Richtig ist | Beleg |
|---|---|---|
| LED-Knoten abonniert „Topic `SM_States`" | Das Topic heißt **`statemachine/state`** (Typ `std_msgs/msg/String`). `SM_States` ist das Enum der Flugphasen, kein Topic. | `SM_node.py`, `led_node.py` |
| Autonomie-Anzeige = REQ-FUN-220 | Autonomie-Anzeige = **REQ-FUN-070** („Autonomy indicator"). REQ-FUN-220 ist *Localization*, REQ-FUN-240 ist *Collision avoidance* (nicht Geofence). | Requirements Rev.2.xlsx |
| Jury-Kriterium „10 m bei Sonnenlicht, blinkend" | Das ist **REQ-DES-060** und bezieht sich auf die Indikatorlampe aus REQ-DES-050, die **nur für den Rover** gilt. Für die Drohne nicht formal bindend, aber als Designziel sinnvoll. | Requirements Rev.2.xlsx |
| „mindestens 5 s vor jeder Bewegung" (REQ-OPS-080) | REQ-OPS-080 nennt nur den Rover. Für die Drohne gelten **REQ-OPS-090** (5 s keine Aktivität, nachdem der Indikator angeht) und **REQ-OPS-100** (autonome Operation frühestens 5 s nach dem Befehl). Die Wartezeit einzuhalten ist Aufgabe der Zustandsmaschine, nicht der LED-Anzeige. | Requirements Rev.2.xlsx |
| T002, T004 … | **[PRÜFEN]** Die T-Nummern stammen aus dem Testplan des Teams. Das Regelwerk und die Requirements-Liste kennen keine T-Nummern. Im Bericht nur mit Verweis auf den Team-Testplan verwenden. | — |
| „Adrian besitzt die ROS-2-Zustandsmaschine" | **[PRÜFEN]** Seit 2026-09-14 ist Laurin für `icarus_statemachine` verantwortlich. Mit Laurin klären, was im Bericht stehen soll. Entwickelt hat die SM das Team. | Projekt-Notizen |

Wörtlich zitierbarer Text von REQ-FUN-070 (aus dem Excel):
> „The rover and the drone shall emit visible signals when performing autonomy operations that
> are different from the signals emitted when being controlled by the team." (Notiz: „E.g.
> different colour may be used.")

---

## 1. Gliederungsvorschlag (LaTeX-Gerüst)

Der Abschnittsname `LED-Statusanzeige` und die vier vorhandenen Subsections bleiben erhalten.
Neu sind eine fünfte Subsection für die SIL-Testumgebung und die Subsubsections.

```latex
\section{LED-Statusanzeige}
\label{sec:LED}
% Intro: goal of the display, link to REQ-FUN-070, overview figure (fig:LED_Datenfluss)

    \subsection{Konzept und Zustandsdefinition}
    \label{sec:LED_Konzept}
        \subsubsection{Anforderungen aus dem Regelwerk}
        \label{sec:LED_Anforderungen}
        \subsubsection{Zwei-Kanal-Modell}
        \label{sec:LED_ZweiKanal}
        \subsubsection{Zuordnung von Zuständen zu Anzeigemustern}
        \label{sec:LED_Zuordnung}
        \subsubsection{Verhalten bei fehlenden oder ungültigen Daten}
        \label{sec:LED_Fehlerfall}

    \subsection{Hardware}
    \label{sec:LED_Hardware}
        \subsubsection{LED-Streifen und Anordnung an den Landebeinen}
        \subsubsection{Ansteuerung über den PIO-Block des RP1}
        \subsubsection{Fehlerisolation durch getrennte Datenleitungen}

    \subsection{Software: Zustandsautomat auf dem Companion Computer}   % see note 1.1
    \label{sec:LED_Software}
        \subsubsection{Schichtenarchitektur}
        \subsubsection{Auslesen des Zustands-Topics}
        \subsubsection{Zeitsteuerung und Blinkmuster}
        \subsubsection{Robustheit im Betrieb}

    \subsection{Anbindung an den Flugcontroller}
    \label{sec:LED_FC}
        \subsubsection{Datenpfad vom Flugcontroller zum LED-Knoten}
        \subsubsection{Bestimmung des Autonomiezustands aus dem PX4-Flugmodus}

    \subsection{Software-in-the-Loop-Testumgebung}
    \label{sec:LED_SIL}
        \subsubsection{Motivation}
        \subsubsection{Aufbau}
        \subsubsection{Simulierter Zustandsgeber}
        \subsubsection{Bedienung über die Kommandozeile}
        \subsubsection{Aussagekraft und Grenzen}
```

### 1.1 Hinweis zum Titel „Software: Zustandsautomat auf dem Companion Computer"

Der Titel ist irreführend. Die LED-Software ist **kein** Zustandsautomat: Sie *liest* den Zustand
der vorhandenen Team-Zustandsmaschine und bildet ihn auf Muster ab. Drei Alternativen:

1. `Software: LED-Knoten auf dem Companion Computer`
2. `Software: Auswertung des Drohnenzustands`
3. `Software-Architektur der Statusanzeige`

Laurin entscheidet. Bis dahin bleibt der alte Titel stehen.

### 1.2 Wohin welches Material in Evaluation und Ergebnissen gehört

| Bestehende Subsection | Material aus dieser Datei |
|---|---|
| `500` → Funktionstest der Zustandsübergänge | Abschnitt 7.1 (automatisierte Tests) und 7.2 (SIL-Testmatrix) |
| `500` → Sichtbarkeitstest | Abschnitt 7.3 (nur Vorbedingungen, Messung TODO) |
| `500` → Test im Flugbetrieb | Abschnitt 7.4 (bisher nicht möglich, Begründung) |
| `600` → Ergebnisse der Statusanzeige | Ergebnisse aus 7.1 und 7.2, Grenzen aus 6.5 und 7.5 |
| `600` → Probleme und Grenzen | Abschnitte 5.2, 6.5 und 7.5 |

---

## 2. Inhalt: Konzept und Zustandsdefinition (`sec:LED_Konzept`)

### 2.1 Anforderungen aus dem Regelwerk

- **REQ-FUN-070** ist die zentrale Anforderung. Gefordert ist genau ein unterscheidbares Signal:
  *autonom* vs. *vom Team gesteuert*. Eine Farbe ist nicht vorgeschrieben (Blau ist eine eigene
  Wahl). Daraus folgt: Dieses Signal muss **immer** ablesbar sein, auch während eines Fehlers.
- **REQ-DES-150** (Redundanz für die wichtigsten Systeme): Begründung für die vier unabhängigen
  Streifen.
- **REQ-OPS-090/-100** (5 s Stillstand): betreffen die Zustandsmaschine. Die Anzeige muss nur
  *bereits leuchten*, sobald autonom kommandiert ist. Das tut sie, weil der Autonomiekanal am
  Flugmodus hängt und nicht an der Flugphase. Zusätzlich macht der Statuskanal genau dieses
  Standby-Fenster sichtbar: `ARMED` (Motoren scharf, Drohne noch am Boden) leuchtet **gelb**.
  Beispiel: `ARMED` + `OFFBOARD` = blau blinkend + gelb, also „autonomer Start steht bevor".
- **REQ-ENV-040** (Betrieb bei Kunstlicht/Nacht): Selbstleuchtende LEDs erfüllen das prinzipiell.
- **REQ-DES-060** (10 m, Sonne): formal nur Rover, wird als Designziel übernommen.

### 2.2 Zwei-Kanal-Modell

**Kernidee:** Autonomie und Zustand werden auf **getrennten LEDs** angezeigt, damit kein Kanal
den anderen überdecken kann.

*Warum:* Ein erster Entwurf bildete alles auf eine Farbe pro Zustand ab (z. B. Fehler → alles
rot). Dann verschwindet das Autonomiesignal genau in der Situation, in der es am wichtigsten ist,
nämlich bei einem autonomen Notfall. Das verletzt REQ-FUN-070.

Belegung jedes Streifens (5 LEDs, Index 0 bis 4):

| LED | Kanal | Bedeutung |
|---|---|---|
| 0 | Navigationslicht | links (Backbord) grün, rechts (Steuerbord) rot, **immer an**. Einzige Ausnahme: „keine Daten" (Abschnitt 2.4) |
| 1, 2 | Autonomie | blau blinkend (1 Hz) = autonom · aus = Team steuert · rot schnell = Modus unbekannt |
| 3, 4 | Status | Flugphase und Fehler in den Farben Grün, Gelb und Rot (Abschnitt 2.3) |

Beide Kanäle liegen auf **jedem** der vier Beine. Fällt ein Streifen aus, kostet das Helligkeit,
aber keine Information (REQ-DES-150). → Abbildung `fig:LED_Belegung` (Abschnitt 8.3).
Einzige Ausnahme ist das Lauflicht im Zustand `READY`, das bewusst über die Beine wandert
(Abschnitt 2.3).

Das Unterscheidungsbeispiel, das den Nutzen zeigt, eignet sich gut für den Fließtext:

| Situation | Autonomie [1,2] | Status [3,4] |
|---|---|---|
| Notlandung, autonom geflogen (`EMERGENCY_LANDING` + `AUTO.LAND`) | **blau blinkend** | rot blinkend |
| Systemfehler, Pilot fliegt (`A_SYS_ERROR` + `MANUAL`) | **aus** | rot blinkend |

### 2.3 Zuordnung von Zuständen zu Anzeigemustern

**Autonomiekanal**, abgeleitet aus dem **PX4-Flugmodus** (`current_mode`, Enum `FC_Modes`), *nicht*
aus der Flugphase. *Warum:* Der Flugmodus beantwortet die Frage „wer schließt den Regelkreis?".
Die Flugphase (`SM_States`, z. B. HOVER) sagt das nicht.

| PX4-Modus | Bedeutung | Muster |
|---|---|---|
| `OFFBOARD` | Companion Computer fliegt | blau blinkend |
| `AUTO.MISSION`, `AUTO.LOITER`, `AUTO.RTL`, `AUTO.LAND`, `AUTO.RTGS`, `AUTO.READY`, `AUTO.TAKEOFF` | Autopilot fliegt | blau blinkend |
| `MANUAL`, `ACRO`, `ALTCTL`, `POSCTL`, `STABILIZED`, `RATTITUDE` | Pilot in der Regelschleife | aus |
| unbekannter Modus (Daten kommen an, Modus in keiner Liste) | nicht feststellbar | rot schnell blinkend |
| keine FC-Verbindung oder keine Daten | nicht feststellbar | ganzer Streifen blitzt (Abschnitt 2.4) |

Alle 14 Modi sind explizit einer Klasse zugeordnet. Ein Test prüft, dass die Zuordnung vollständig
und überschneidungsfrei ist.

**Statuskanal**, abgeleitet aus Flugphase (`state`, Enum `SM_States`, 13 Werte) und den beiden
Fehlerfeldern.

*Leitidee für die Farben:* die Konvention industrieller Signalsäulen, die der Bericht bereits
zitiert (`item24signale`, **[PRÜFEN]**, ob der Bib-Eintrag gefüllt ist): **Grün** = normaler
Betrieb, **Gelb** = Achtung, gleich passiert etwas oder jemand muss handeln, **Rot** = Gefahr bzw.
Fehler. Die Bewegung (statisch, 1 Hz, schnell, Lauflicht, Farbwechsel) unterscheidet innerhalb
einer Farbe.

Prüfreihenfolge (erste zutreffende Zeile gewinnt):

1. keine FC-Verbindung (`connected = False`) **oder** `sys_error = FC_ERROR` → ganzer Streifen
   blitzt (Abschnitt 2.4)
2. anderer Systemfehler (`SERVICE_ERROR`, `TOPIC_ERROR`) → rot schnell
3. Missionsfehler `EMERGENCY` → rot schnell
4. Missionsfehler `ABORT` oder `NAVIGATION_ERROR` → gelb, 1 Hz
5. sonst nach Flugphase:

| Flugphase (`SM_States`) | Bedeutung | Muster |
|---|---|---|
| `REST`, `EXIT` | noch nicht bereit (`EXIT` ist in der aktuellen SM unerreichbar) | aus |
| `READY` | entschärft, am Boden, sicher, wartet | **grünes Lauflicht** um die Beine |
| `ARMED` | Motoren scharf, noch am Boden, „gleich geht's los" | **gelb**, statisch |
| `TAKEOFF` | hebt ab | **grün und gelb im Wechsel** |
| `LANDING` | sinkt | grün, 1 Hz |
| `HOVER`, `APPROACHING` | stabiler, gesunder Flug | grün, statisch |
| `STOP`, `LOST` | Mission unterbrochen, hält Position, Bediener muss handeln (`LOST` ist unerreichbar) | gelb, 1 Hz |
| `EMERGENCY_LANDING`, `A_SYS_ERROR`, `G_SYS_ERROR` | Notfall oder Systemfehler | rot schnell blinkend |

Begründung der Gruppierung (13 Zustände auf 8 Muster): Zwei Zustände teilen sich ein Muster, wenn
der Beobachter **gleich reagieren** soll oder der Kontext sie ohnehin unterscheidet. Beispiele:

- `HOVER` und `APPROACHING` sind beide normaler Flug. Ob die Drohne steht oder ein Ziel anfliegt,
  sieht man an der Drohne selbst.
- `STOP` und `LOST` heißen beide „unterbrochen, noch nicht gefährlich, jemand muss handeln".
- `EMERGENCY_LANDING` und die beiden Systemfehler verlangen dieselbe Reaktion: Abstand halten.
- Die Übergänge zum Boden haben eigene Muster: `TAKEOFF` mischt das Gelb von `ARMED` mit dem Grün
  des Flugs, `LANDING` ist grün blinkend.

*Warum das Lauflicht für `READY`:* Ein dunkler Statuskanal sah vorher genauso aus wie `REST`.
Das Lauflicht zeigt „System lebt, ist bereit, aber entschärft", ohne mit einem Flugzustand
verwechselbar zu sein. Es läuft im Uhrzeigersinn von oben gesehen: vorne links → vorne rechts →
hinten rechts → hinten links, 0,25 s pro Bein (eine Runde pro Sekunde). Am 2026-11-10 an der
Drohne bestätigt.

*Warum `ABORT` direkt auf das Fehlerfeld reagiert:* Die SM setzt `mission_error` einen Tick
(ca. 100 ms) **bevor** sie nach `STOP` wechselt. So bleibt die Farbe über diesen Zwischenschritt
stabil gelb.

Alle 13 Zustände sind explizit gelistet. Ein unbekannter Zustand fällt bewusst auf Rot und nicht
auf „aus", weil eine dunkle Anzeige nicht von einer gesunden, unbewaffneten Drohne zu
unterscheiden wäre.

**Alle Muster mit Zeiten** (`patterns.py`):

| Muster | Farbe(n) | Zeitverhalten | verwendet für |
|---|---|---|---|
| aus | – | – | `REST`, `EXIT`, Autonomie: Team steuert |
| statisch | grün / gelb | dauernd an | `HOVER`/`APPROACHING` / `ARMED` |
| blinkend 1 Hz | grün / gelb / blau | 0,5 s an, 0,5 s aus | `LANDING` / `STOP`, `ABORT` / Autonomie |
| Wechsel | grün ↔ gelb | je 0,5 s, nie dunkel | `TAKEOFF` |
| Lauflicht | grün | 0,25 s pro Bein, 1 Runde/s | `READY` |
| rot schnell | rot | ca. 3,3 Hz (0,15 s an, 0,15 s aus) | Notfall, Fehler, unbekannter Modus/Zustand |
| Streifen blitzt | rot, alle 5 LEDs | 5 Hz (0,1 s an, 0,1 s aus) | keine Daten, keine FC-Verbindung |

Gelb ist bewusst **kein** reines `(255, 255, 0)`, sondern `(255, 150, 0)`. Bei WS2812B ist der
grüne Chip deutlich heller als der rote, gleiche Anteile wirken deshalb gelbgrün und wären von den
grünen Mustern schwer zu unterscheiden. **[PRÜFEN]** Laurin: Ist der Farbton an der Drohne
eindeutig gelb? (Beim Test am 2026-11-10 funktionierten alle Muster; der Farbton selbst wurde
nicht gesondert bewertet.)

LaTeX-Vorlage für die Zuordnungstabelle (`tabularx`, `booktabs`, `xcolor` sind geladen):

```latex
\begin{table}[htbp]
    \centering
    \caption{Zuordnung von Drohnenzustand zu Anzeigemuster je Kanal}
    \label{tab:LED_Zuordnung}
    \begin{tabularx}{\textwidth}{l X l}
        \toprule
        \textbf{Kanal} & \textbf{Bedingung} & \textbf{Muster} \\
        \midrule
        Autonomie (LED 1--2) & PX4-Modus \texttt{OFFBOARD} oder \texttt{AUTO.*} & blau, \SI{1}{\hertz} \\
                             & PX4-Modus mit Pilot (\texttt{MANUAL}, \texttt{POSCTL}, \dots) & aus \\
                             & Modus unbekannt & rot, ca.\ \SI{3,3}{\hertz} \\
        \midrule
        Status (LED 3--4)    & \texttt{REST}, \texttt{EXIT} & aus \\
                             & \texttt{READY} & grünes Lauflicht \\
                             & \texttt{ARMED} & gelb, statisch \\
                             & \texttt{TAKEOFF} & grün/gelb im Wechsel \\
                             & \texttt{LANDING} & grün, \SI{1}{\hertz} \\
                             & \texttt{HOVER}, \texttt{APPROACHING} & grün, statisch \\
                             & \texttt{STOP}, \texttt{LOST}, Missionsfehler \texttt{ABORT} & gelb, \SI{1}{\hertz} \\
                             & \texttt{EMERGENCY\_LANDING}, Systemfehler, Missionsfehler \texttt{EMERGENCY} & rot, ca.\ \SI{3,3}{\hertz} \\
        \midrule
        Navigation (LED 0)   & immer & links grün, rechts rot \\
        \midrule
        ganzer Streifen      & keine Daten, keine Verbindung zum Flugcontroller & rot, alle LEDs, \SI{5}{\hertz} \\
        \bottomrule
    \end{tabularx}
\end{table}
```

### 2.4 Verhalten bei fehlenden oder ungültigen Daten

Grundsatz: **Die Anzeige darf nie etwas behaupten, das sie nicht weiß.**

- **Modus unbekannt** (die Daten kommen an, aber der Modus ist nicht klassifiziert): Der
  Autonomiekanal zeigt rot schnell. Das ist bewusst weder blau (würde unbestätigte Autonomie
  behaupten) noch dunkel (würde „ein Mensch fliegt" behaupten, die gefährlichere Fehlaussage).
- **Keine Daten:** Der **ganze Streifen blitzt rot mit 5 Hz**, das Navigationslicht eingeschlossen.

*Warum ein eigenes Signal für „keine Daten":* Vorher waren „Fehler" und „keine Daten" beide rot
schnell blinkend auf den Status-LEDs und damit nicht zu unterscheiden. Inhaltlich sind es aber
verschiedene Aussagen:

- **Fehler:** Die Drohne weiß, dass etwas nicht stimmt, und meldet es. Die Navigationslichter
  leuchten ruhig, nur LED 3–4 blinken rot.
- **Keine Daten:** Man weiß gar nichts. Der Streifen blitzt komplett und schneller. Dieses Bild
  kann kein Zustand erzeugen, den die Drohne tatsächlich meldet.

| Situation | Reaktion |
|---|---|
| Nach dem Start, noch keine gültige Nachricht | ganzer Streifen blitzt |
| Einzelne kaputte Nachricht | ignorieren, letztes Muster halten |
| 1,0 s lang keine gültige Nachricht (= 10 verpasste bei 10 Hz) | ganzer Streifen blitzt |
| `connected = False` (kein Link zum FC) | ganzer Streifen blitzt |
| `sys_error = FC_ERROR` (FC-Daten veraltet, z. B. MAVROS abgestürzt) | ganzer Streifen blitzt |
| Node wird beendet | alle LEDs aus (die Streifen halten sonst ihr letztes Bild) |

„Publisher tot" und „Nachricht kaputt" sind vom LED-Knoten aus nicht unterscheidbar. Deshalb deckt
derselbe 1-s-Timeout beides ab.

*Warum `FC_ERROR` wie „keine Verbindung" zählt:* Die SM setzt `FC_ERROR`, wenn `/mavros/state`
älter als 1,2 s ist, `connected` falsch ist oder PX4 `UNINIT` meldet (`SM_errors.py`). In allen
drei Fällen ist der gemeldete Modus kein Fakt mehr. Ohne diese Regel blieb nach einem
MAVROS-Absturz der letzte Modus stehen (Abschnitt 5.2). Andere Systemfehler (`SERVICE_ERROR`,
`TOPIC_ERROR`) lassen den Autonomiekanal dagegen unverändert, weil die FC-Verbindung dann noch
steht und der Modus weiterhin stimmt.

---

## 3. Inhalt: Hardware (`sec:LED_Hardware`)

### 3.1 LED-Streifen und Anordnung an den Landebeinen

- 20 adressierbare **WS2812B-LEDs** (RGB), 4 Streifen à 5 LEDs, ein Streifen pro Landebein.
  (Korrigiert am 2026-11-10: Eine frühere Fassung dieser Datei nannte fälschlich SK6812.)
- Datenformat: 3 Byte pro LED, Reihenfolge **GRB**. Am 2026-11-03 an der Drohne mit dem
  Bring-up-Werkzeug `led_selftest` bestätigt.
- GPIO-Belegung (BCM-Nummern), am 2026-11-03 an der Drohne bestätigt:

| Bein | Seite | GPIO |
|---|---|---|
| vorne links | Backbord | 22 |
| hinten links | Backbord | 27 |
| vorne rechts | Steuerbord | 23 |
| hinten rechts | Steuerbord | 24 |

- **[PRÜFEN] / TODO:** Position und Befestigung im Landebein (TPU-Fuß), Kabelführung,
  Stromversorgung (5 V-Quelle), Foto. Steht nicht im Repo.
- Der Pegelwandler **74AHCT125** (3,3 V → 5 V, ein Gatter pro Bein) ist geplant, aber **noch nicht
  verbaut**. Der Pi gibt 3,3 V aus. Das liegt unter der Datenblatt-Schwelle der LEDs bei 5 V
  Versorgung (ca. 3,5 V). Beim Test hat es trotzdem funktioniert, ist aber außerhalb der
  Spezifikation. Gehört in „Probleme und Grenzen".

### 3.2 Ansteuerung über den PIO-Block des RP1

Das ist die interessanteste Hardware-Entscheidung, weil der naheliegende Weg nicht funktioniert:

- **Raspberry Pi 5** hat einen neuen I/O-Chip, den **RP1**. Die verbreitete Bibliothek
  `rpi_ws281x` nutzt das alte DMA/PWM-Timing und **funktioniert auf dem Pi 5 nicht**.
- **SPI-basierte Treiber** gibt es, sie treiben aber nur *einen* Streifen am MOSI-Pin. Vier
  unabhängige Streifen wären nur über Daisy-Chaining möglich, und das widerspricht der
  Fehlerisolation.
- **Gewählt: PIO** (Programmable I/O) im RP1 über die Bibliothek
  `Adafruit-Blinka-Raspberry-Pi5-Neopixel` (Funktion `neopixel_write(pin, buffer)`). PIO kann
  **jeden** GPIO bedienen und erzeugt das zeitkritische Bitmuster in Hardware.
- Die Bibliothek belegt nur **eine** PIO-State-Machine und schaltet sie bei jedem Aufruf auf den
  übergebenen Pin um. Die vier Beine werden also **nacheinander** geschrieben (ca. 1 ms Pause
  zwischen Writes, ca. 3–4 ms für alle vier). Bei 50 ms Renderperiode ist das unkritisch, und der
  Versatz zwischen den Beinen ist mit bloßem Auge nicht sichtbar.
- **Voraussetzung:** Der Kernel muss den Treiber `rp1-pio` mitbringen, der das Gerät `/dev/pio0`
  anlegt. Das ist der Grund für das separate Betriebssystem (Abschnitte 6.1 und 7.4).
- Lizenzhinweis für „Grenzen": Die Bibliothek steht unter GPL-2.0, das LED-Paket unter
  Apache-2.0. Für ein nicht verteiltes Wettbewerbssystem unkritisch, vor einer Veröffentlichung
  zu klären.

### 3.3 Fehlerisolation durch getrennte Datenleitungen

- Jeder Streifen hat einen **eigenen GPIO**, es gibt kein Daisy-Chaining. Eine kalte Lötstelle
  oder ein abgerissenes Kabel an einem Bein darf die anderen drei nicht mitreißen.
- Die Software setzt dasselbe Prinzip fort: Jedes Bein hat ein eigenes Treiberobjekt, und
  Schreibfehler werden **pro Bein** abgefangen. Fällt ein Bein aus, loggt der Knoten das einmal und
  rendert die anderen drei weiter (Abschnitt 4.4).

---

## 4. Inhalt: Software (`sec:LED_Software`)

### 4.1 Schichtenarchitektur

Die Software ist ein ROS-2-Paket (`icarus_led_controller`, Python, ROS 2 Jazzy). Sie ist in drei
Schichten getrennt. *Warum:* Die Logik soll ohne Drohne, ohne Pi und ohne ROS testbar sein, und
der Hardwaretreiber soll austauschbar sein (PIO, SPI oder Mikrocontroller), ohne dass sich die
Logik ändert.

```
ROS-Schicht        led_node.py                Subscription, Timer, Fehler-Policy (dünn)
                        │
Logik-Schicht      decoder.py → mapping.py → drone_led_controller.py → leg_indicator.py
(reines Python)                                                          patterns.py
                        │
Hardware-Schicht   driver.py (Schnittstelle LedStripDriver)
                   ├─ ws2812_driver.py   echter Treiber (PIO)
                   └─ DummyLedStripDriver  nur Logausgabe (Entwicklungsrechner)
```

Das Interface `LedStripDriver` hat genau eine Methode: `set_pixels(colors)`. Beim Start prüft der
Knoten, ob die PIO-Bibliothek importierbar ist. Ist sie das, verwendet er den echten Treiber,
sonst den Dummy mit einer deutlichen Warnung. So läuft dasselbe Paket unverändert auf dem
Laptop und auf dem Pi.

**Alle Dateien im Überblick** (Hintergrund, für den Bericht höchstens im Anhang):

| Datei | Schicht | Aufgabe |
|---|---|---|
| `config.py` | Hardware | nur die vier GPIO-Pins |
| `driver.py` | Hardware | Schnittstelle `LedStripDriver` + `DummyLedStripDriver` |
| `ws2812_driver.py` | Hardware | `Ws2812StripDriver`: baut den GRB-Bytepuffer und ruft `neopixel_write()` auf. Bei Fehlern ergänzt er die wahrscheinliche Ursache (Bibliothek fehlt, `/dev/pio0` fehlt, Zugriffsrechte fehlen). |
| `patterns.py` | Logik | Enum `Pattern` (10 Muster), Farben, Farbfolge und Taktung je Muster, `color_at(pattern, t, leg_slot)` |
| `leg_indicator.py` | Logik | ein Bein: LED-Belegung, Nav-Farben, baut die 5 Farben pro Frame, Sonderfall „ganzer Streifen blitzt" |
| `drone_led_controller.py` | Logik | hält die 4 Beine, `set_all()`, `render(t)`, Reihenfolge des Lauflichts, Fehlerisolation pro Bein, Treiberauswahl |
| `mapping.py` | Logik | Zustand → zwei Muster (Abschnitt 2.3) |
| `decoder.py` | Logik | Nachricht → `StateSnapshot` (Abschnitt 4.2) |
| `led_node.py` | ROS | der LED-Knoten (Abschnitt 4.3/4.4) |
| `selftest.py` | Werkzeug | `led_selftest`: Inbetriebnahme ohne ROS (Pins, Farbreihenfolge, RGB/RGBW) |
| `sil_state.py`, `sil_publisher.py`, `sil_panel.py`, `sil_publisher_topics.py` | SIL | Abschnitt 6 dieser Datei bzw. `sec:LED_SIL` |
| `launch/led_launch.py` | ROS | startet nur den LED-Knoten (Normalbetrieb) |
| `launch/led_sil_launch.py` | ROS | startet LED-Knoten + simulierten Zustandsgeber |
| `test/test_led_logic.py`, `test/test_sil.py` | Test | pytest, ohne Pi und ohne laufendes ROS |

### 4.2 Auslesen des Zustands-Topics

Der wichtigste und am wenigsten offensichtliche Teil.

**Was die Team-Zustandsmaschine sendet** (`SM_node.py`, `SM_cbor.py`): Alle 100 ms (10 Hz)
serialisiert sie ihr **komplettes** Zustandsobjekt `Drone_Data`, einen Python-Dataclass mit
**61 Feldern** (Flugphase, Fehler, PX4-Modus, Position, Batterie, Missions- und Agentendaten …):

```python
data = cbor2.dumps(asdict(drone), default=default_encoder)   # binary CBOR
msg.data = data.hex()                                        # as text, topic type is String
```

- **CBOR** (Concise Binary Object Representation, RFC 8949) ist ein binäres JSON-ähnliches Format.
- Weil das Topic den Typ `std_msgs/String` hat, werden die Bytes als **Hex-Text** übertragen.
- Python-Enums kennt CBOR nicht. Der Encoder schreibt jedes Enum als
  **`CBORTag(4000, [Name, Klassenname])`**, also z. B. `CBORTag(4000, ['HOVER', 'SM_States'])`.
- Eine Nachricht ist ca. **2,2 kB** groß (gemessen: 2256 Byte bzw. 4512 Hex-Zeichen).

**Was der LED-Knoten daraus macht** (`decoder.py`), in drei Schritten:

1. `bytes.fromhex()` macht aus dem Hex-Text wieder Bytes.
2. `cbor2.loads(…, tag_hook=…)` dekodiert. Der *Tag-Hook* erkennt Tag 4000 und baut das echte
   Enum-Mitglied wieder auf. Die passende Klasse findet er über ihren Namen in einer Tabelle, die
   beim Import automatisch aus allen Enums des gemeinsamen Pakets `icarus_deps` erzeugt wird.
   Ein unbekanntes Enum wird zu einem einfachen Text, statt den Decode abzubrechen. So stört ein
   neues Enum in einem Feld, das die LEDs nicht brauchen, nicht.
3. Es werden **nur 5 der 61 Felder** übernommen und streng typgeprüft, das Ergebnis ist der
   unveränderliche `StateSnapshot`:

| Feld | Typ | wofür |
|---|---|---|
| `state` | `SM_States` | Statuskanal (Flugphase) |
| `mission_error` | `SM_Mission_Errors` | Statuskanal |
| `sys_error` | `SM_System_Errors` | Statuskanal |
| `current_mode` | `FC_Modes` | Autonomiekanal |
| `connected` | `bool` | sagt, ob `current_mode` überhaupt echt ist |

*Warum `connected`?* `Drone_Data` hat für `current_mode` den Standardwert `AUTO.LOITER`. Ohne
Verbindung zum Flugcontroller stünde dort also „autonom", obwohl nie ein Modus gemeldet wurde.
Ohne das Feld würde eine Drohne mit abgestecktem FC blau blinken.

*Warum strenge Typprüfung?* Ein unbekanntes Enum, das zu Text degradiert ist, darf nicht als
gültiger Wert durchrutschen. Und `connected = 1` gilt nicht als `True`: In Python ist `bool` eine
Unterklasse von `int`, deshalb prüft der Code den exakten Typ.

Jeder Fehler wird zu einer einzigen Ausnahme (`StateDecodeError`). **Was die Anzeige dann zeigt,
entscheidet der Knoten, nicht der Decoder.** Das trennt Parsen von Anzeigepolitik.

*Warum Decode und Format nicht geändert wurden:* Das Bodenstations-GUI des Teams liest denselben
CBOR-Strom. Eine Formatänderung hätte es potenziell gebrochen. Es gibt zwar eine ungenutzte
ROS-Message `SmState.msg`, sie ist aber nicht der aktive Kontrakt. Der Overhead ist gemessen
vernachlässigbar: ca. 0,05 ms Decode pro Nachricht auf x86, bei 10 Hz ca. 0,05 % eines Kerns.

Belegendes Beispiel (am 2026-11-09 mit dem echten Encoder erzeugt, Zustand HOVER + AUTO.LOITER):

```
hex len 4512 -> 2256 bytes; start: b83d646e616d65674c45445f53494c...
raw state field: CBORTag(4000, ['HOVER', 'SM_States'])
mode:            CBORTag(4000, ['MODE_PX4_LOITER', 'FC_Modes'])   #fields: 61
StateSnapshot(state=HOVER, mission_error=NO_ERROR, sys_error=NO_ERROR,
              current_mode=AUTO.LOITER, connected=True)
autonomy: BLINK_BLUE   status: SOLID_GREEN
```

(`4c45445f53494c` im Hex ist ASCII für „LED_SIL", den Namen, den der simulierte Zustandsgeber
setzt.)

### 4.3 Zeitsteuerung und Blinkmuster

Der LED-Knoten (`led_node.py`) hat zwei unabhängige Callbacks:

- **Empfang** (bei jeder Nachricht, also 10 Hz): dekodieren, auf zwei Muster abbilden, Muster und
  Empfangszeit speichern. Hier wird **nichts** an die LEDs geschrieben.
- **Rendern** (eigener Timer, **20 Hz**): Veralterung prüfen (Abschnitt 2.4), dann alle vier Beine
  mit **einem gemeinsamen Zeitstempel** zeichnen.

*Warum getrennt?* Die Blinkmuster müssen auch dann weiterlaufen, wenn keine Nachricht kommt, und
gerade dann soll die Anzeige auf „keine Daten" wechseln.

*Warum 20 Hz?* Die schnellste Phase (Streifen blitzt, 5 Hz) dauert 0,1 s. Bei 20 Hz fallen
2 Render-Ticks in jede Phase, beim roten Fehlerblinken (0,15 s) sind es 3. Reicht das sichtbar
nicht, kann die Rate ohne Risiko erhöht werden: Ein Frame für alle vier Beine dauert ca. 4 ms.

**Muster als Farbfolge:** Jedes Muster ist eine kurze Liste von Farben, die mit festem Takt
durchlaufen wird (`Sequence` in `patterns.py`). Damit decken *eine* Datenstruktur und *eine*
Funktion alle Muster ab:

| Muster | Farbfolge | Takt |
|---|---|---|
| statisch grün | (grün) | – |
| blau 1 Hz | (blau, aus) | 0,5 s |
| grün/gelb im Wechsel | (grün, gelb) | 0,5 s |
| Lauflicht | (grün, aus, aus, aus), pro Bein versetzt | 0,25 s |

**Blinken ohne Zustand:** Welche Farbe eine LED gerade zeigt, ist eine *reine Funktion* von Muster,
Zeit und Bein:

```python
step = int(t / step_s)            # patterns.color_at()
if per_leg:                       # only the running light
    step -= leg_slot              # 0 = front left, 1 = front right, 2 = back right, 3 = back left
color = frames[step % len(frames)]
```

Es gibt keinen internen Takt und keine Threads. Weil alle vier Beine denselben Zeitstempel `t`
bekommen, blinken sie **garantiert synchron**. Außerdem lässt sich das mit erfundenen
Zeitstempeln testen.

*Wie das Lauflicht entsteht:* Die Farbfolge hat vier Schritte mit genau einem grünen. Jedes Bein
wird um seine Position (`leg_slot`) verschoben. Zu jedem Zeitpunkt ist deshalb genau ein Bein
grün, und das grüne Bein wandert weiter. Die Positionen vergibt `DroneLedController` beim Start,
weil nur er weiß, welches Bein wo sitzt.

Akzeptierter Kompromiss: Die Phase läuft frei gegen die absolute Zeit, nicht ab dem
Musterwechsel. Ein Wechsel auf ein blinkendes Muster kann daher bis zu 0,5 s in der Dunkelphase
beginnen.

### 4.4 Robustheit im Betrieb

- **Fehlerisolation pro Bein:** Wirft der Treiber eines Beins eine Ausnahme, wird sie abgefangen,
  **einmal** beim Übergang gesund→defekt geloggt (nicht 20-mal pro Sekunde) und die anderen drei
  Beine laufen weiter. Erholt sich das Bein, wird auch das geloggt.
  *Warum:* Ohne das hätte ein einziger Schreibfehler den Knoten beendet, und alle vier Beine wären
  dunkel geblieben.
- **Ausschalten beim Beenden:** WS2812B halten ihr letztes Bild unbegrenzt. Ein gestoppter Knoten
  würde sonst z. B. „autonom, gesund" stehen lassen. Deshalb schaltet `main()` im `finally`-Block
  alle LEDs aus. Ein zweites Ctrl-C wird dabei ignoriert, weil `ros2 launch` das Signal doppelt
  zustellt und das Ausschalten sonst mittendrin abbrechen würde.
  Grenze: Das hilft nur bei sauberem Beenden. Gegen einen Absturz hilft nur ein Watchdog (offen).
- **Log-Drosselung:** Wiederkehrende Warnungen (kaputte Nachricht, veraltete Daten) erscheinen
  höchstens einmal pro Sekunde.

---

## 5. Inhalt: Anbindung an den Flugcontroller (`sec:LED_FC`)

### 5.1 Datenpfad vom Flugcontroller zum LED-Knoten

**Der LED-Knoten spricht nicht direkt mit dem Flugcontroller.** Er hängt ausschließlich an der
Zustandsmaschine des Teams. *Warum:* Es gibt nur eine Stelle, die den Drohnenzustand bewertet,
und die Anzeige zeigt genau das, was auch die Zustandsmaschine und die Bodenstation „glauben".

```
PX4 (Pixhawk 6C)
   │ MAVLink über UART (/dev/ttyAMA0, 921600 Baud)
   ▼
MAVROS ── /mavros/state (connected, mode, armed, …)
   ▼
Zustandsmaschine (icarus_statemachine, Paket drone_state_controller)
   │  state_callback(): drone.connected = msg.connected
   │                    drone.current_mode = FC_Modes(msg.mode)
   │  + eigene Flugphase (state) und Fehlerauswertung (sys_error, mission_error)
   │ statemachine/state, 10 Hz, CBOR als Hex-String
   ├──► Bodenstations-GUI (Laptop)
   └──► LED-Knoten (icarus_led_controller) ──► 4 LED-Streifen
```

### 5.2 Bestimmung des Autonomiezustands aus dem PX4-Flugmodus

- MAVROS meldet den PX4-Modus als Text (z. B. `"POSCTL"`, `"AUTO.LOITER"`). Die Zustandsmaschine
  wandelt ihn in das Enum `FC_Modes` um (14 Werte), der LED-Knoten klassifiziert ihn
  (Abschnitt 2.3).
- `connected` stammt ebenfalls aus `/mavros/state`.

**Bekannte Lücke (für „Probleme und Grenzen", code-belegt):**

1. Die Zustandsmaschine meldet einen **unbekannten PX4-Modus-Text als `AUTO.LOITER`**
   (`SM_node.py:221-222`, `state_callback`). Ein unbekannter Modus erscheint an den LEDs deshalb
   als „autonom" statt als „unbekannt". Der Rot-Zweig des LED-Knotens greift nur bei einem
   unbekannten Enum-Wert, den die aktuelle SM nie sendet. Die Guards der SM glauben das falsche
   LOITER ebenfalls und können nach `HOVER` wechseln. Lösungsweg (noch offen, weil das gemeinsame
   Paket `icarus_dependencies` nur mit dem GUI-Verantwortlichen geändert werden darf): neuer
   Enum-Wert `MODE_UNKNOWN`, den die SM statt LOITER setzt. Am LED-Code ist dafür nichts nötig.
   Details: `BEFUNDE.md` Nr. 12 im Projektordner.

**Behoben am 2026-11-10 (für den Text als gelöstes Problem verwendbar):**

2. **MAVROS-Absturz:** `connected` und `current_mode` werden nur geschrieben, wenn eine
   `/mavros/state`-Nachricht ankommt. Stirbt MAVROS, publiziert die SM trotzdem weiter mit 10 Hz,
   `connected` bleibt eingefroren auf `True` und der Modus auf dem letzten Wert. Der 1-s-Timeout
   des LED-Knotens greift deshalb nicht. Vorher zeigte der Autonomiekanal dann weiter den alten
   Modus, nach `MANUAL` also dunkel, obwohl niemand mehr wusste, wer fliegt. **Lösung:** Der
   LED-Knoten wertet `sys_error = FC_ERROR` wie `connected = False` (Funktion
   `mapping.has_fc_link()`). Die SM setzt `FC_ERROR` nach ca. 1,2 bis 1,7 s, danach blitzt der
   ganze Streifen (Abschnitt 2.4). Die Lösung kommt ohne Änderung an der SM oder am Datenformat
   aus.

---

## 6. Inhalt: Software-in-the-Loop-Testumgebung (`sec:LED_SIL`)

### 6.1 Motivation

- Der Flug-Stack (Ubuntu 24.04 + ROS 2 Jazzy + MAVROS) läuft auf einem Ubuntu-Kernel
  (`6.8.0-1062-raspi`), der den Treiber **`rp1-pio` nicht enthält** → kein `/dev/pio0`, die
  LEDs lassen sich dort nicht ansteuern (Fehlermeldung `Failed to open PIO device (error -22)`).
- Auf einer **zweiten SD-Karte mit Raspberry Pi OS Lite** existiert `/dev/pio0`, dort fehlt aber
  der Flug-Stack.
- Die Anzeige sollte trotzdem **mit echter Hardware und echtem Nachrichtenformat** getestet
  werden, und zwar für *alle* Zustandskombinationen, auch für gefährliche wie eine Notlandung, die
  man im Flug nicht absichtlich herbeiführt.
- Lösung: **Software-in-the-Loop**. LED-Knoten, Decoder, Zuordnung, Treiber und LEDs sind echt,
  nur die Zustandsmaschine wird durch einen **simulierten Zustandsgeber** ersetzt. Gesteuert wird
  er per Kommandozeile direkt auf dem Pi (über SSH), ohne zusätzliche Software auf dem Laptop.

Begriffsnotiz für den Text: Im Team wird „SIL" auch für die Gazebo/PX4-SITL-Simulation verwendet.
Hier ist eine SIL-Umgebung *für die Anzeige* gemeint: Echte Anzeigesoftware und echte LEDs, die
Zustandsquelle ist simuliert. Im Bericht einmal sauber abgrenzen.

### 6.2 Aufbau

**Abbildung `fig:LED_SIL_Architektur`** (ASCII-Fassung, TikZ-Code in Abschnitt 8.2):

```
 LAPTOP / beliebiger Rechner        RASPBERRY PI 5 (Raspberry Pi OS)
 ┌──────────────────┐   SSH    ┌───────────────────────────────────────────────────────────┐
 │ Terminal         │ ───────► │ Shell-Funktion  sil state=HOVER mode=AUTO.LOITER          │
 │                  │          │      │ docker exec … ros2 topic pub led_sil/set           │
 └──────────────────┘          │ ┌────┼──── Docker-Container (ros:jazzy, ROS 2 Jazzy) ───┐ │
                               │ │    ▼                                                  │ │
                               │ │ ┌──────────────────────┐                              │ │
                               │ │ │ led_sil_publisher    │  (simulierte SM, 10 Hz)      │ │
                               │ │ │ SilState → Drone_Data│                              │ │
                               │ │ │ → echter SM-Encoder  │                              │ │
                               │ │ └──────────┬───────────┘                              │ │
                               │ │            │ statemachine/state (CBOR als Hex-String) │ │
                               │ │            ▼                                          │ │
                               │ │ ┌──────────────────────┐                              │ │
                               │ │ │ led_node             │                              │ │
                               │ │ │ decode → map → render│ 20 Hz                        │ │
                               │ │ └──────────┬───────────┘                              │ │
                               │ └────────────┼──────────────────────────────────────────┘ │
                               │              ▼ neopixel_write()                           │
                               │ /dev/pio0 → RP1-PIO → GPIO 22/27/23/24 → 4×5 WS2812B      │
                               └───────────────────────────────────────────────────────────┘
```

Laufzeitumgebung (für den Text):

- **Pi:** Raspberry Pi OS Lite, ROS 2 Jazzy im **Docker**-Container (Image `led-sil` auf Basis
  `ros:jazzy`). *Warum Docker:* ROS 2 Jazzy wird offiziell für Ubuntu 24.04 gepflegt, nicht für
  Raspberry Pi OS (Debian). Der Container liefert die Ubuntu-Umgebung, der Host-Kernel liefert
  `/dev/pio0`.
- **Workspace:** liegt auf dem Pi unter `~/icarus_ws` und ist in den Container nach `/ws`
  eingebunden (Bind-Mount, am 2026-11-10 per `docker inspect` geprüft). Enthält das LED-Paket,
  `icarus_dependencies` (gemeinsame Enums) und `icarus_statemachine` (nur wegen des Encoders).
  *Vorteil:* Neuer Code kommt per `git pull` auf dem Pi und `colcon build` im Container an, ohne
  das Image neu zu bauen.
- **[PRÜFEN]** Das Dockerfile liegt nur auf dem Pi (`~/led-docker`), nicht im Repo. Wie
  `/dev/pio0` und die PIO-Bibliothek in den Container kommen, ist hier nicht belegt. Bei Laurin
  erfragen, bevor es im Text steht.
- **Start:** Die SIL-Launch (`led_sil_launch.py`: LED-Knoten + simulierter Zustandsgeber) ist der
  **Hauptprozess des Containers**. Sie startet mit dem Container, ein Neustart geht per
  `docker restart`. Sie startet **weder MAVROS noch die echte SM**, kann den Flugcontroller also
  prinzipiell nicht ansteuern.
- **Bedienung:** per SSH auf dem Pi mit der Shell-Funktion `sil` (Abschnitt 6.4). Es läuft keine
  ROS-Kommunikation über das WLAN, deshalb sind `ROS_DOMAIN_ID` und die Laptop-Firewall für den
  Test egal. Nur SSH muss gehen.

### 6.3 Simulierter Zustandsgeber (`sil_state.py`, `sil_publisher.py`)

- **`SilState`**: der vorgetäuschte Zustand, also genau die 5 Felder, die die LEDs auswerten, plus
  der Schalter `publishing`. Startwert: `REST` + `POSCTL` + verbunden + kein Fehler, d. h. nur die
  Navigationslichter leuchten. *Warum dieser Startwert:* Rot oder Blitzen im SIL bedeutet damit
  immer „das hat jemand ausgewählt" oder „es kommen keine Daten", nie „Standardwert".
- **Befehlsformat:** eine Textzeile mit `key=value`-Paaren, z. B.
  `state=HOVER mode=AUTO.LOITER sys_error=NO_ERROR connected=true`. Weggelassene Schlüssel
  behalten ihren Wert. Ein Befehl mit *irgendeinem* ungültigen Teil wird **komplett verworfen**,
  weil ein halb angewendeter Befehl eine Kombination zeigen würde, die niemand ausgewählt hat. Das
  Textformat ist bewusst von Hand tippbar. Darauf baut die Kommandozeilen-Bedienung in
  Abschnitt 6.4 auf.
- **`led_sil_publisher`** (ROS-Knoten): empfängt Befehle auf `led_sil/set`, baut daraus ein
  **echtes `Drone_Data`-Objekt** (mit `name = "LED_SIL"`, damit Aufzeichnungen und GUI
  Simulationsdaten erkennen) und publiziert es mit **10 Hz wie die echte SM** auf
  `statemachine/state`.
- **Entscheidende Designentscheidung:** Der Zustandsgeber **importiert den echten Encoder**
  (`drone_state_controller.SM_cbor.encode_drone_data`) aus dem Paket der Zustandsmaschine, statt
  ihn zu kopieren. *Warum:* Eine Kopie könnte unbemerkt vom echten Format abweichen. Der Test würde
  dann weiter bestehen, aber nichts mehr beweisen. So durchläuft der LED-Knoten im SIL exakt
  denselben Codepfad wie im Flug.
- **Schutzmechanismen:**
  - Taucht ein **zweiter Publisher** auf `statemachine/state` auf (wahrscheinlich die echte SM),
    verstummt der Zustandsgeber und meldet einen Fehler. Sonst würden sich echte und falsche Daten
    mischen, und LEDs und GUI würden einen Zustand behaupten, in dem die Drohne nicht ist.
    Funktioniert unabhängig von der Startreihenfolge.
  - `publishing=false` lässt ihn verstummen, um eine **abgestürzte Zustandsmaschine** zu simulieren.
    Der LED-Knoten muss das selbst bemerken (Timeout → ganzer Streifen blitzt nach 1 s).

### 6.4 Bedienung über die Kommandozeile (`sil`)

**Idee:** Ein Test soll ohne zusätzliche Software auf dem Laptop möglich sein. Man meldet sich per
SSH am Pi an und tippt z. B. `sil state=ARMED mode=OFFBOARD`. Die LEDs reagieren sofort, und man
kann direkt daneben stehen.

*Warum keine grafische Oberfläche mehr:* Das Tkinter-Panel (`sil_panel.py`, siehe unten) braucht
auf dem Laptop ROS 2, die gleiche `ROS_DOMAIN_ID` und eine Firewall-Ausnahme, und es überschreibt
jede Sekunde den Zustand. Die Kommandozeile braucht nur SSH, jeder Befehl ist reproduzierbar und
kann in ein Testprotokoll kopiert werden.

**Funktionsweise:** `sil` ist eine Shell-Funktion in `~/.bashrc` des Benutzers `frost` **auf dem
Pi selbst** (nicht im Container). Sie übersteht deshalb auch ein Neuerstellen des Containers.

```
sil state=ARMED
  │ 1. Container finden:      docker ps -q --filter ancestor=led-sil
  │ 2. Befehl hineinreichen:  docker exec <id> bash -c "source /opt/ros/jazzy/setup.bash &&
  │                             ros2 topic pub -w 1 --once /led_sil/set std_msgs/msg/String
  │                             \"{data: 'state=ARMED'}\""
  │ 3. Rückmeldung zeigen:    docker logs --since 3s <id> | grep "Now simulating|Rejected"
  ▼
led_sil_publisher übernimmt den Zustand → nächste Nachricht (≤ 100 ms) → LEDs
```

- Die Funktion findet den Container über das Image `led-sil`, nicht über einen Namen. Das
  funktioniert auch nach einem Neuerstellen mit neuer ID.
- `-w 1` wartet, bis der Zustandsgeber zuhört, `timeout 10` bricht ab, wenn er nicht läuft.
- Die Rückmeldung kommt aus dem Log des Zustandsgebers. Ein Tippfehler wird dort mit der Liste der
  erlaubten Werte abgelehnt (`Rejected …`), der alte Zustand bleibt erhalten.

**Alle Befehle.** Syntax: `sil <schlüssel>=<wert> [<schlüssel>=<wert> …]` oder `sil reset`.
Weggelassene Schlüssel behalten ihren Wert. Groß-/Kleinschreibung der Werte genau wie angegeben.

`state=` – Flugphase der Zustandsmaschine (`SM_States`, 13 Werte) → Statuskanal LED 3–4:

| Befehl | LED 3–4 | Anmerkung |
|---|---|---|
| `sil state=REST` | aus | |
| `sil state=READY` | grünes Lauflicht | |
| `sil state=ARMED` | gelb, statisch | |
| `sil state=TAKEOFF` | grün/gelb im Wechsel | |
| `sil state=HOVER` | grün, statisch | |
| `sil state=APPROACHING` | grün, statisch | |
| `sil state=LANDING` | grün, 1 Hz | |
| `sil state=STOP` | gelb, 1 Hz | |
| `sil state=LOST` | gelb, 1 Hz | in der echten SM unerreichbar |
| `sil state=EMERGENCY_LANDING` | rot schnell | |
| `sil state=A_SYS_ERROR` | rot schnell | |
| `sil state=G_SYS_ERROR` | rot schnell | |
| `sil state=EXIT` | aus | in der echten SM unerreichbar |

`mode=` – PX4-Flugmodus (`FC_Modes`, 14 Werte, so geschrieben wie PX4 ihn anzeigt) → Autonomiekanal
LED 1–2:

| Befehl | LED 1–2 |
|---|---|
| `sil mode=OFFBOARD` | blau, 1 Hz |
| `sil mode=AUTO.MISSION` · `AUTO.LOITER` · `AUTO.RTL` · `AUTO.LAND` · `AUTO.RTGS` · `AUTO.READY` · `AUTO.TAKEOFF` | blau, 1 Hz |
| `sil mode=MANUAL` · `ACRO` · `ALTCTL` · `POSCTL` · `STABILIZED` · `RATTITUDE` | aus |

`sys_error=` – Systemfehler (`SM_System_Errors`) → überschreibt die Flugphase:

| Befehl | Wirkung |
|---|---|
| `sil sys_error=NO_ERROR` | Flugphase entscheidet |
| `sil sys_error=FC_ERROR` | **ganzer Streifen blitzt** (FC-Daten ungültig, z. B. MAVROS abgestürzt) |
| `sil sys_error=SERVICE_ERROR` | LED 3–4 rot schnell, LED 1–2 zeigen weiter den Modus |
| `sil sys_error=TOPIC_ERROR` | LED 3–4 rot schnell, LED 1–2 zeigen weiter den Modus |

`mission_error=` – Missionsfehler (`SM_Mission_Errors`) → überschreibt die Flugphase, aber nicht
`sys_error`:

| Befehl | Wirkung auf LED 3–4 |
|---|---|
| `sil mission_error=NO_ERROR` | Flugphase entscheidet |
| `sil mission_error=ABORT` | gelb, 1 Hz |
| `sil mission_error=NAVIGATION_ERROR` | gelb, 1 Hz |
| `sil mission_error=EMERGENCY` | rot schnell |

Verbindung und Zustandsgeber:

| Befehl | Wirkung |
|---|---|
| `sil connected=false` | FC getrennt → ganzer Streifen blitzt |
| `sil connected=true` | FC verbunden |
| `sil publishing=false` | Zustandsgeber verstummt (simuliert eine abgestürzte SM) → nach 1 s blitzt der ganze Streifen |
| `sil publishing=true` | Zustandsgeber sendet wieder |
| `sil reset` | Startzustand: `state=REST mode=POSCTL sys_error=NO_ERROR mission_error=NO_ERROR connected=true publishing=true` |

Priorität auf LED 3–4: keine Verbindung / `FC_ERROR` > anderer `sys_error` > `EMERGENCY` >
`ABORT` / `NAVIGATION_ERROR` > `state`.

**Typische Kombinationen** (entsprechen realen Situationen):

| Situation | Befehl |
|---|---|
| bereit, Team steuert | `sil state=READY mode=POSCTL` |
| scharf, autonomer Start steht bevor | `sil state=ARMED mode=OFFBOARD` |
| autonomer Start | `sil state=TAKEOFF mode=AUTO.TAKEOFF` |
| autonomer Flug | `sil state=HOVER mode=AUTO.LOITER` |
| Ziel anfliegen | `sil state=APPROACHING mode=OFFBOARD` |
| autonome Landung | `sil state=LANDING mode=AUTO.LAND` |
| Mission abgebrochen | `sil state=STOP mode=AUTO.LOITER mission_error=ABORT` |
| autonome Notlandung | `sil state=EMERGENCY_LANDING mode=AUTO.LAND mission_error=EMERGENCY` |
| Pilot fliegt, Systemfehler | `sil state=A_SYS_ERROR mode=MANUAL sys_error=TOPIC_ERROR` |
| MAVROS abgestürzt | `sil sys_error=FC_ERROR` |

**Code der Funktion** (für den Anhang oder als Referenz, steht nicht im Repo):

```bash
# LED SIL from the Pi shell: sends key=value commands into the led-sil container.
sil() {
    if [ $# -eq 0 ]; then
        echo "usage: sil key=value ...   or   sil reset" >&2
        echo "keys: state mode sys_error mission_error connected publishing" >&2
        return 1
    fi
    local ctr
    ctr=$(docker ps -q --filter ancestor=led-sil | head -n 1)
    if [ -z "$ctr" ]; then
        echo "sil: no running led-sil container" >&2
        return 1
    fi
    local cmd="$*"
    if [ "$1" = "reset" ]; then
        cmd="state=REST mode=POSCTL sys_error=NO_ERROR mission_error=NO_ERROR connected=true publishing=true"
    fi
    docker exec "$ctr" bash -c "source /opt/ros/jazzy/setup.bash && timeout 10 ros2 topic pub -w 1 --once /led_sil/set std_msgs/msg/String \"{data: '$cmd'}\" >/dev/null"
    case $? in
        0)   echo "sent: $cmd" ;;
        124) echo "sil: led_sil_publisher not found within 10 s (is the SIL launch running?)" >&2; return 1 ;;
        *)   echo "sil: sending failed" >&2; return 1 ;;
    esac
    sleep 0.5
    docker logs --since 3s "$ctr" 2>&1 | grep -E "Now simulating|Rejected" | tail -n 1
}
```

**Alternative: grafisches Panel (`sil_panel.py`).** Es existiert weiterhin im Repo, wird aber
nicht mehr verwendet. Für den Bericht reicht ein Satz: Tkinter-Fenster auf dem Laptop mit
Auswahllisten, das zusätzlich anzeigt, was die LEDs zeigen *sollten*. Nachteile: Es braucht ROS 2
auf dem Laptop, die gleiche `ROS_DOMAIN_ID` und eine Firewall-Ausnahme, und es sendet jede Sekunde
seinen Zustand neu. Läuft es parallel, überschreibt es deshalb jeden `sil`-Befehl.

### 6.5 Aussagekraft und Grenzen

**Was der SIL-Test belegt:**
- Das echte Nachrichtenformat der Zustandsmaschine wird korrekt gelesen (echter Encoder).
- Die Zuordnung Zustand → Muster und die Blinkfrequenzen stimmen auf echter Hardware.
- Der Timeout-/Fehlerfall funktioniert (Zustandsgeber verstummt → ganzer Streifen blitzt nach 1 s).
- Pins, Farbreihenfolge und PIO-Treiber funktionieren an den echten Streifen, und die
  Lauflicht-Reihenfolge passt zur echten Lage der Beine.
- Die Reaktion der Anzeige auf `FC_ERROR` (Abschnitt 5.2, Lücke 2).

**Was er nicht belegt:**
- Ob die *echte* Zustandsmaschine die getesteten Kombinationen im Flug so erzeugt. Der Zustandsgeber
  erlaubt auch physikalisch unsinnige Kombinationen (z. B. HOVER + MANUAL).
- Das Zeitverhalten der echten SM unter Last.
- Beim MAVROS-Absturz nur die Reaktion der *Anzeige*: `FC_ERROR` wird im SIL direkt gesetzt. Ob
  die echte SM es rechtzeitig setzt, ist nur aus dem Code abgeleitet (`SM_errors.py`).
- Die Bodenstation: Bedient wird per SSH, das GUI des Teams ist im SIL nicht beteiligt.
- Den Betrieb im Flug, weil derzeit **kein Betriebssystem beides kann**: Pi OS hat PIO, aber keinen
  Flug-Stack, Ubuntu hat den Flug-Stack, aber kein PIO.

---

## 7. Material für Evaluation (`sec:Eval_LED`) und Ergebnisse (`sec:Erg_LED`)

### 7.1 Funktionstest der Zustandsübergänge: automatisierte Tests

- Framework: **pytest**, läuft ohne Pi, ohne LEDs und ohne laufendes ROS.
- `test/test_led_logic.py` (60 Testfunktionen): Muster, Blink-Timing, Zuordnung (Vollständigkeit
  und Disjunktheit aller 14 Modi und 13 Zustände, jede Zeile der Statustabelle einzeln),
  Fehlerpriorität, Decoder inkl. Fehlerfälle, Fehlerisolation pro Bein, Ausschalten, Wire-Format
  des Treibers (GRB-Packing, Pufferlänge) über eine Fake-Schreibfunktion.
- Neu seit dem Rework vom 2026-11-10:
  - die Lauflicht-Reihenfolge (vorne links → vorne rechts → hinten rechts → hinten links);
  - grün/gelb wechselt ohne Dunkelphase;
  - „keine Daten" blitzt schneller als das Fehlerblinken (≥ 4 Hz) und erfasst den ganzen
    Streifen;
  - bei einem Fehler bleibt das Navigationslicht ruhig;
  - `FC_ERROR` gilt als „keine Verbindung", auch wenn `connected` eingefroren auf `True` steht.
- `test/test_sil.py` (10 Testfunktionen): Befehlsparser, Round-Trip durch den **echten** SM-Encoder.
- Viele Tests sind parametrisiert (z. B. einmal pro Zustand). Ergebnis am **2026-11-10** (nach dem
  Rework): **292 bestanden, 1 übersprungen, 0 fehlgeschlagen.** (Vor dem Rework, 2026-11-09: 262
  bestanden.) Übersprungen wurde der Kompatibilitätstest mit dem GUI-Parser des Teams
  (`drone_GUI.ROS_cbor_parser`), weil das GUI-Paket auf dem Testrechner nicht installiert war.
- Wichtigste Regressionstests:
  - für REQ-FUN-070: `test_error_cannot_hide_the_autonomy_indicator`;
  - für den MAVROS-Fall: `test_fc_error_means_no_link_even_with_connected_frozen_true`.

### 7.2 Funktionstest der Zustandsübergänge: SIL an echter Hardware

- 2026-11-03: Pin-Zuordnung, GRB und RGB (3 Byte) mit `led_selftest` bestätigt. Erste SIL-Läufe
  noch mit dem Panel vom Laptop aus.
- 2026-11-10: Rework auf den Pi gebracht (`git pull`, `colcon build` im Container, `docker
  restart`) und per `sil` über SSH geprüft. Laut Laurin funktionieren alle getesteten Muster, und
  das Lauflicht läuft in der richtigen Richtung. Laut Log zeigte der Knoten direkt nach dem Start
  einmal „keine Daten" (noch keine Nachricht angekommen). Danach stand die Anzeige ruhig auf
  `REST` (nur Navigationslichter). Auch das ist das erwartete Verhalten.
- **TODO (Laurin):** Die noch offenen Zeilen der Matrix durchgehen und eintragen. In der Spalte
  „Beobachtet" steht nur, was am 2026-11-10 tatsächlich getestet wurde.

Ausgangszustand jeder Zeile: `sil reset` (Zeile 1).

| # | Befehl | Erwartet Autonomie [1,2] | Erwartet Status [3,4] | Beobachtet |
|---|---|---|---|---|
| 1 | `sil reset` (REST, POSCTL, verbunden) | aus | aus (nur Nav-Licht) | wie erwartet (2026-11-10) |
| 2 | `sil state=READY` | aus | grünes Lauflicht VL → VR → HR → HL | wie erwartet (2026-11-10) |
| 3 | `sil state=ARMED` | aus | gelb | wie erwartet (2026-11-10) |
| 4 | `sil state=ARMED mode=OFFBOARD` | blau 1 Hz | gelb | TODO |
| 5 | `sil state=TAKEOFF` | aus | grün/gelb im Wechsel | wie erwartet (2026-11-10) |
| 6 | `sil state=HOVER mode=AUTO.LOITER` | blau 1 Hz | grün | TODO |
| 7 | `sil state=APPROACHING mode=OFFBOARD` | blau 1 Hz | grün | TODO |
| 8 | `sil state=LANDING` | aus | grün 1 Hz | wie erwartet (2026-11-10) |
| 9 | `sil state=STOP mission_error=ABORT` | aus | gelb 1 Hz | wie erwartet (2026-11-10) |
| 10 | `sil state=EMERGENCY_LANDING mode=AUTO.LAND mission_error=EMERGENCY` | blau 1 Hz | rot schnell | TODO |
| 11 | `sil state=A_SYS_ERROR mode=MANUAL sys_error=TOPIC_ERROR` | aus | rot schnell, Nav-Licht ruhig | TODO |
| 12 | `sil sys_error=FC_ERROR` | ganzer Streifen blitzt | ganzer Streifen blitzt | wie erwartet (2026-11-10) |
| 13 | `sil connected=false` | ganzer Streifen blitzt | ganzer Streifen blitzt | TODO |
| 14 | `sil publishing=false` | ganzer Streifen blitzt nach ≤ 1 s | ganzer Streifen blitzt nach ≤ 1 s | TODO |
| 15 | SIL beenden (`docker stop`) | alle LEDs aus (auch Nav) | alle LEDs aus | TODO |

Die Zeilen 10 und 11 belegen REQ-FUN-070 direkt: Beide sind Notfälle, aber die Autonomie bleibt
unterscheidbar. Zeile 11 gegen 12 belegt die Unterscheidung „Fehler" gegen „keine Daten".
Zeile 4 zeigt das Standby-Fenster aus REQ-OPS-090/-100.

**[PRÜFEN] Zeile 15:** Ob `docker stop` die LEDs ausschaltet, hängt davon ab, ob das Signal bis
zum LED-Knoten durchgereicht wird. Sauber belegt ist nur Ctrl-C bei `ros2 launch`.

### 7.3 Sichtbarkeitstest

- **TODO:** nicht durchgeführt. Vorbedingungen und Einflüsse für den Text: 2 LEDs pro Kanal und
  Bein (also 8 pro Kanal an der Drohne), Pegelwandler nicht verbaut, Helligkeit **[PRÜFEN]** (im
  Betrieb volle Helligkeit 255). Designziel 10 m bei Tageslicht nach REQ-DES-060 (Rover-Anforderung
  als Maßstab übernommen).

### 7.4 Test im Flugbetrieb

- **Nicht durchgeführt / nicht möglich**: Auf der Flug-SD-Karte (Ubuntu) fehlt `/dev/pio0`
  (Abschnitt 6.1). Ehrlich als Ergebnis und Grenze darstellen. Lösungswege für den Ausblick
  (`700_Zusammenfassung`):
  1. SPI statt PIO (Datenleitungen auf SPI-MOSI-Pins umlöten, neue Treiberklasse),
  2. Mikrocontroller (z. B. RP2040) per USB zwischen Pi und LEDs,
  3. Flug-Stack auf Raspberry Pi OS (z. B. ebenfalls per Docker).

  In allen drei Fällen ändert sich **nur die Treiberklasse** hinter `LedStripDriver`. Zuordnung,
  Decoder und Knoten bleiben gleich. Das ist der Nutzen der Schichtenarchitektur und ein gutes
  Argument im Diskussionsteil.

### 7.5 Sonstige Grenzen für „Probleme und Grenzen"

- Pegelwandler fehlt (3,3 V statt ≥ 3,5 V Datenpegel).
- Die SM meldet einen unbekannten Modus als `AUTO.LOITER` (Abschnitt 5.2, Lücke 1).
- Farbsehschwäche: Grün und Gelb bzw. Rot sind für Menschen mit Rot-Grün-Schwäche schwer zu
  unterscheiden. Abgemildert wird das, weil sich die Muster meist auch in der Bewegung
  unterscheiden (statisch, 1 Hz, Lauflicht, schnell). Grün 1 Hz (`LANDING`) und Gelb 1 Hz (`STOP`)
  unterscheiden sich aber *nur* in der Farbe. Dort hilft nur der Kontext: Die Drohne sinkt bzw.
  hält die Position.
- Gelb ist ein Mischton aus Rot und Grün, sein Eindruck hängt von den LEDs und der Helligkeit ab.
  **[PRÜFEN]**, ob er bei Tageslicht von Grün unterscheidbar bleibt (gehört zum Sichtbarkeitstest).
- Der LED-Knoten ist in keiner Startkonfiguration des Teams (`autonomy_master`) eingetragen, im
  Flug würde er also nicht automatisch starten.
- Kein Watchdog: Stürzt der Knoten ab, bleibt das letzte Bild stehen.
- GPL-2-Lizenz der PIO-Bibliothek vs. Apache-2.0 des Pakets.

---

## 8. Abbildungen in LaTeX

### 8.1 Präambel und Einbindung

In `thesis.tex` ist TikZ geladen (Zeile ca. 153: `\usepackage{tikz}` + `\usetikzlibrary{math}`).
Die Bibliotheksliste muss erweitert werden:

```latex
\usetikzlibrary{math, positioning, arrows.meta, fit, backgrounds, calc, decorations.pathreplacing}
```

Konvention im Projekt: Abbildungspfade als `\newcommand` in `TeXFiles/004_Figures.tex`. Für
TikZ-Abbildungen: den Code in eine eigene Datei unter `Figures/400-em/` legen und per `\input`
einbinden:

```latex
% TeXFiles/004_Figures.tex, section "04 Entwickelte Methoden"
\newcommand{\ledSilArchitektur}{Figures/400-em/led_sil_architektur}
\newcommand{\ledBelegung}{Figures/400-em/led_belegung}
```

```latex
% usage in 400_EntwickelteMethoden.tex
\begin{figure}[htbp]
    \centering
    \input{\ledSilArchitektur}
    \caption{Aufbau der Software-in-the-Loop-Testumgebung der LED-Statusanzeige}
    \label{fig:LED_SIL_Architektur}
\end{figure}
```

> ✅ Der folgende TikZ-Code wurde am 2026-11-09 mit pdflatex (TeX Live 2026) in einem
> Minimaldokument (`scrreprt`, `siunitx` mit `locale=DE`) fehlerfrei kompiliert und visuell
> geprüft. Im echten Bericht können Abstände wegen anderer Schrift (carlito) leicht abweichen.

### 8.2 `Figures/400-em/led_sil_architektur.tex`

> ✅ Neue Fassung vom 2026-11-10 (Bedienung per SSH statt Laptop-Panel), mit pdflatex in einem
> Minimaldokument fehlerfrei kompiliert und visuell geprüft. Die Datei
> `Figures/400-em/led_sil_architektur.tex` im Bericht wurde am 2026-11-10 durch diesen Code
> ersetzt. **Noch anzupassen:** der Text in `400_EntwickelteMethoden.tex` beschreibt weiterhin das
> Panel (Absatz nach der Abbildung, ca. Zeile 383, und `\subsubsection{Bedienoberfläche auf der
> Bodenstation}`, ca. Zeile 397). Ersetzen nach Abschnitt 6.2 und 6.4 dieser Datei.

```latex
% SIL test setup of the LED status display: SSH shell -> fake state machine -> LED node -> LEDs
\begin{tikzpicture}[
    font=\small,
    node distance=8mm and 14mm,
    box/.style={draw, rounded corners=2pt, fill=white, align=center,
                minimum width=40mm, minimum height=11mm, inner sep=3pt},
    hw/.style={box, fill=black!6},
    group/.style={draw, rounded corners=4pt, inner sep=5mm},
    msg/.style={-{Stealth[length=2.2mm]}, thick},
    lbl/.style={font=\scriptsize, align=center, fill=white, inner sep=1pt},
    grouplbl/.style={font=\footnotesize\bfseries, anchor=south west, inner sep=2pt},
]
    % --- Raspberry Pi: shell, ROS nodes and hardware path, top to bottom ---
    \node[box] (sil) {Shell-Funktion \texttt{sil}\\z.\,B. \texttt{sil state=ARMED}};
    \node[box, below=18mm of sil] (pub) {\texttt{led\_sil\_publisher}\\simulierte Zustandsmaschine, \SI{10}{\hertz}};
    \node[box, below=16mm of pub] (led) {\texttt{led\_node}\\dekodieren, zuordnen, \SI{20}{\hertz} rendern};
    \node[hw, below=14mm of led] (pio) {RP1-PIO\\\texttt{/dev/pio0}};
    \node[hw, below=14mm of pio] (strips) {4 WS2812B-Streifen à 5 LEDs\\GPIO 22, 27, 23, 24};

    % --- operator terminal, left of the shell ---
    \node[box, left=30mm of sil] (term) {Terminal\\Laptop o.\,ä.};

    % --- data flow ---
    \draw[msg] (term.east) -- node[lbl, above, pos=0.35] {SSH} (sil.west);
    \draw[msg] (sil.south) -- node[lbl, right, pos=0.45] {\texttt{docker exec}: \texttt{led\_sil/set}\\Befehl \texttt{key=value}} (pub.north);
    \draw[msg] (pub.south) -- node[lbl, right, pos=0.5] {\texttt{statemachine/state}\\CBOR als Hex-Text} (led.north);
    \draw[msg] (led) -- node[lbl, right, pos=0.7] {\texttt{neopixel\_write()}} (pio);
    \draw[msg] (pio) -- node[lbl, right, pos=0.7] {4 getrennte Datenleitungen} (strips);

    % --- grouping boxes, drawn behind the nodes ---
    \begin{scope}[on background layer]
        \node[group, dashed, fit=(pub)(led), inner sep=4mm] (docker) {};
        \node[font=\scriptsize, anchor=north east, inner sep=2pt] at (docker.north east)
            {Docker \texttt{ros:jazzy}};
        \node[group, fit=(sil)(docker)(pio), inner sep=4mm] (pi) {};
        \node[grouplbl] at (pi.north west) {Raspberry Pi 5 (Raspberry Pi OS)};
    \end{scope}
\end{tikzpicture}
```

Hinweise zum Diagramm:
- Durchgezogene Pfeile sind SSH, ROS-2-Topics bzw. Hardwarezugriffe. Alles außer dem Terminal
  läuft auf dem Pi, es gibt keine ROS-Kommunikation über das WLAN.
- Die Shell-Funktion liegt bewusst *außerhalb* des Docker-Rahmens: Sie steht in `~/.bashrc` des
  Pi und reicht den Befehl per `docker exec` in den Container (Abschnitt 6.4).
- Optionale zweite Abbildung für `sec:LED_FC` (Normalbetrieb): gleicher Stil, aber
  `led_sil_publisher` ersetzt durch die echte Zustandsmaschine, darüber MAVROS und PX4
  (Datenpfad aus Abschnitt 5.1), ohne Terminal und Shell-Funktion. So sieht man direkt, dass im
  SIL **genau ein Kasten** ausgetauscht wird.

### 8.3 `Figures/400-em/led_belegung.tex`: Belegung eines Streifens

```latex
% LED layout of one strip (example: left leg, autonomous flight, no error)
\begin{tikzpicture}[
    font=\small,
    led/.style={circle, draw, thick, minimum size=8mm, inner sep=0pt},
    brace/.style={decorate, decoration={brace, amplitude=4pt, mirror, raise=3pt}, thick},
]
    % wider gaps between the channel groups, so the labels below do not collide
    \draw[line width=4mm, black!12, line cap=round] (-0.3,0) -- (6.5,0); % the strip itself
    \node[led, fill=green!55] (l0) at (0.0,0) {0};
    \node[led, fill=blue!45]  (l1) at (2.0,0) {1};
    \node[led, fill=blue!45]  (l2) at (3.0,0) {2};
    \node[led, fill=green!55] (l3) at (5.2,0) {3};
    \node[led, fill=green!55] (l4) at (6.2,0) {4};

    \draw[brace] (l0.south west) -- (l0.south east)
        node[midway, below=8pt, align=center] {Navigation\\immer an};
    \draw[brace] (l1.south west) -- (l2.south east)
        node[midway, below=8pt, align=center] {Autonomie\\blau = autonom};
    \draw[brace] (l3.south west) -- (l4.south east)
        node[midway, below=8pt, align=center] {Status\\grün = ok};
\end{tikzpicture}
```

Vorschlag für die Bildunterschrift: „Belegung eines LED-Streifens am Beispiel eines linken Beins
im autonomen Flug ohne Fehler. LED 0 zeigt die Seite an (links grün, rechts rot), LED 1–2 den
Autonomiekanal, LED 3–4 den Statuskanal."

---

## 9. Neue Abkürzungen für `005_Acronyms.tex`

Vorschlag. Vorher prüfen, ob sie schon definiert sind (`\newacronym{label}{KURZ}{Langform}`):

```latex
\newacronym{ros}{ROS}{Robot Operating System}
\newacronym{sil}{SIL}{Software-in-the-Loop}
\newacronym{led}{LED}{Light-Emitting Diode}
\newacronym{gpio}{GPIO}{General Purpose Input/Output}
\newacronym{pio}{PIO}{Programmable Input/Output}
\newacronym{cbor}{CBOR}{Concise Binary Object Representation}
\newacronym{dds}{DDS}{Data Distribution Service}
\newacronym{fc}{FC}{Flight Controller}
\newacronym{gui}{GUI}{Graphical User Interface}
\newacronym{uart}{UART}{Universal Asynchronous Receiver Transmitter}
\newacronym{mavlink}{MAVLink}{Micro Air Vehicle Link}
```

PX4, MAVROS und Raspberry Pi sind Eigennamen und brauchen keine Abkürzung. Bei der ersten
Erwähnung kurz erklären: MAVROS = ROS-Brücke zu MAVLink.

Mögliche Literaturquellen für `bibliography.bib` (**[PRÜFEN]**, Einträge noch anlegen): CBOR
(RFC 8949), ROS 2 Dokumentation (Jazzy), PX4-Flugmodi-Dokumentation, WS2812B-Datenblatt (bereits als `ws2812btds` in der Bibliographie),
RP1-Peripherals-Dokumentation (Raspberry Pi Ltd.), ERC 2026 Rules Rev.3 und Requirements Rev.2.

---

## 10. Spickzettel: in 60 Sekunden mündlich erklären

1. **Aufgabe:** Die Drohne muss sichtbar zeigen, ob sie autonom fliegt oder vom Team gesteuert
   wird (REQ-FUN-070), und zwar auch während eines Fehlers.
2. **Lösung:** 4 Landebeine mit je 5 LEDs auf eigenen GPIO-Pins. Jedes Bein zeigt Navigation
   (LED 0), Autonomie (1–2, blau blinkend) und Status (3–4, grün/gelb/rot wie eine Signalsäule:
   grün = normal, gelb = gleich passiert etwas oder jemand muss handeln, rot = Fehler). Zwei
   getrennte Kanäle, also kann ein Fehler-Rot das Autonomie-Blau nie überdecken.
3. **Datenquelle:** Die Zustandsmaschine des Teams sendet 10-mal pro Sekunde ihr komplettes
   Zustandsobjekt (61 Felder, CBOR, als Hex-Text). Der LED-Knoten dekodiert es, nimmt 5 Felder
   heraus, leitet daraus Autonomie (aus dem PX4-Modus) und Status (aus Phase und Fehlern) ab und
   zeichnet 20-mal pro Sekunde.
4. **Sicherheit:** Im Zweifel nie dunkel. „Fehler" und „keine Daten" sehen verschieden aus: Bei
   einem Fehler blinken nur die Status-LEDs rot, bei fehlenden Daten (1 s nichts, kein FC,
   `FC_ERROR`) blitzt der ganze Streifen. Ein kaputtes Bein stoppt die anderen nicht. Beim Beenden
   gehen alle LEDs aus.
5. **Hardware-Knackpunkt:** Der Pi 5 kann WS2812-artige LEDs nur über den PIO-Block treiben.
   Dafür braucht der Kernel `rp1-pio`, und den hat das Ubuntu des Flug-Stacks nicht.
6. **SIL:** Deshalb läuft der Test auf Raspberry Pi OS mit ROS im Docker. Die echte
   Zustandsmaschine ist durch einen simulierten Zustandsgeber ersetzt, der den *echten* Encoder
   benutzt. Per SSH tippt man auf dem Pi z. B. `sil state=ARMED mode=OFFBOARD`, und die echten
   LEDs zeigen sofort das Muster. Jeder Zustand ist so testbar, auch eine Notlandung.
