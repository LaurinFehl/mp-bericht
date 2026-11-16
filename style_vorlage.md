# Style-Vorlage für den Bericht (LaTeX)

> **Zweck dieser Datei:** Sie beschreibt Format, Layout, Schreibstil und Konventionen einer Referenz-Bachelorarbeit (Frankfurt UAS, FB 2, FRoST-Team, 72 Seiten, LaTeX/pdfTeX). Es geht **nicht** um den Inhalt. Claude Code soll den Bericht so setzen und formulieren, dass er wie diese Referenz aussieht und sich genauso liest.
>
> Die Werte stammen aus der Analyse des PDFs: Schriften, Seitenmaße, Zeilenabstände und Seitenbilder. Paketnamen sind die naheliegende Umsetzung und nicht aus dem Quelltext übernommen.

---

## 1. Technische Grundlagen

| Eigenschaft | Wert |
|---|---|
| Compiler | pdfLaTeX (`hyperref` aktiv) |
| Papier | A4, einseitig (gleiche Ränder links und rechts) |
| Grundschrift | Latin Modern Roman, **12 pt** (`\usepackage{lmodern}`, `[12pt]`) |
| Zeilenabstand | einfach (Grundlinienabstand ≈ 14,5 pt bei 12 pt). **Kein** 1,5-facher Abstand |
| Absätze | **kein Einzug**, stattdessen etwa eine halbe Leerzeile Abstand zwischen Absätzen (`parskip`, ≈ 7 pt) |
| Satz | Blocksatz mit Silbentrennung (deutsch, `babel` `ngerman`) |
| Monospace | Latin Modern Mono (für Code, Dateinamen, Topics) |
| Serifenlose Schrift | Latin Modern Sans Bold, **nur** für Run-in-Zwischenüberschriften (`\paragraph`) |

### Satzspiegel (gemessen)
- Linker und rechter Rand: je **≈ 31 mm**, Textbreite **≈ 148 mm**
- Kopfzeile: Grundlinie ≈ 27 mm vom oberen Blattrand, darunter eine Linie
- Fußzeile mit Seitenzahl: ≈ 34 mm über dem unteren Blattrand (inklusive Logos)
- Vorschlag: `\usepackage[a4paper, left=31mm, right=31mm, top=35mm, bottom=40mm, headsep=8mm, footskip=15mm]{geometry}` und danach optisch abgleichen

### Dokumentklasse
`report` (oder `scrreprt`). Kapitel beginnen immer auf einer neuen Seite. Die Kapitelüberschrift ist **einzeilig im Stil „1 Einleitung“**, ohne „Kapitel 1“-Zeile darüber und ohne großen Vorabstand (z. B. über `titlesec` oder KOMA `chapterprefix=false`).

---

## 2. Überschriften

| Ebene | Aussehen | Beispiel |
|---|---|---|
| `\chapter` | Serifenschrift, fett, groß (≈ 20 pt), linksbündig, Nummer + Titel, oben auf der Seite | **1 Einleitung** |
| `\section` | Serifenschrift, fett, ≈ 14 pt | **2.3 Auswahl der Sensorik** |
| `\subsection` | Serifenschrift, fett, ≈ 12 pt | **4.4.1 Identifikationsalgorithmen** |
| `\paragraph` | **Serifenlos, fett**, Run-in (der Text läuft in derselben Zeile weiter), davor ein Absatzabstand | **Schritt 1: Prädiktion** Ausgehend vom Zustand … |

- Gliederungstiefe in Nummerierung und Verzeichnis: **3 Ebenen** (x.y.z). Tiefer wird nur mit unnummerierten `\paragraph`s gegliedert.
- `\paragraph` wird oft genutzt: für Ausblickspunkte, Einschränkungen, Rauschannahmen, Teilschritte. Titel kurz halten (1–4 Wörter).
- Überschriften sind sachlich und beschreibend, z. B. „Auswertung des PI-Reglers“ oder „Begründung der gewählten Systemplattform“. Keine Fragen, keine Doppelpunkte.

---

## 3. Kopf- und Fußzeile (`fancyhdr`)

- **Kopfzeile:** mittig der aktuelle Kapitelname **kursiv** mit Nummer („*4 Methodische Grundlagen und Modellierungsstrategie*“), darunter eine dünne Linie über die Textbreite. In den Verzeichnissen steht dort „*Inhaltsverzeichnis*“, „*Abbildungsverzeichnis*“ und so weiter.
- **Fußzeile:** darüber eine dünne Linie. Links das Hochschullogo (klein, ≈ 12 mm hoch), **mittig die Seitenzahl**, rechts das Team-Logo (FRoST).
- Auch Kapitelanfangsseiten haben Kopf und Fuß. Der `plain`-Stil wird dafür auf denselben Stil umdefiniert.
- **Titelseite** ohne Kopf, Fuß und Seitenzahl.

```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter\ #1}{}}
\fancyhead[C]{\itshape\leftmark}
\fancyfoot[L]{\includegraphics[height=12mm]{logos/fra-uas.png}}
\fancyfoot[C]{\thepage}
\fancyfoot[R]{\includegraphics[height=8mm]{logos/frost.png}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}
\fancypagestyle{plain}{} % Kapitelseiten gleich gestalten
```

### Seitennummerierung
Durchgehend **arabisch ab der Titelseite**. Die Titelseite zählt als 1, wird aber nicht gezeigt. Die Eidesstattliche Erklärung ist Seite 2, das Inhaltsverzeichnis beginnt auf Seite 3. Römische Zahlen werden nicht verwendet.

---

## 4. Aufbau / Reihenfolge der Teile

1. **Titelseite**
2. **Eidesstattliche Erklärung** (inklusive Abschnitt zur KI-Nutzung)
3. **Inhaltsverzeichnis**
4. **Abbildungsverzeichnis**
5. **Tabellenverzeichnis**
6. **Abkürzungsverzeichnis**
7. Hauptteil (nummerierte Kapitel)
8. **Literaturverzeichnis** (unnummeriert, steht aber im Inhaltsverzeichnis)

Es gibt kein Abstract/Kurzfassung, kein Vorwort und keinen Anhang. Die Verzeichnisse sind unnummerierte Kapitel (`\chapter*` + `\addcontentsline`). Die Eidesstattliche Erklärung erscheint im Inhaltsverzeichnis.

### Kapitelgliederung des Hauptteils (Muster für einen technischen Projektbericht)
1. **Einleitung** – nur ca. 1 Seite: Motivation, Kontext (Team/Projekt), Lücke, Ansatz, kurzer Ausblick auf das Ergebnis. Keine Unterkapitel.
2. **Aufgabenstellung und Systementscheidungen** – Ziel, Anforderungen, Abgrenzung („Nicht Bestandteil dieser Arbeit ist …“), Systemübersicht, Auswahl der Komponenten mit Bewertungstabellen, Inbetriebnahme
3. **Vorstellung der Lösungsansätze und Auswahl der besten Option** – Ansätze, Bewertungsmaßstäbe, begründete Auswahl, Schlussfolgerung
4. **Methodische Grundlagen und Modellierungsstrategie** – Theorie und Formeln
5. **Umsetzung** – Implementierung, Zwischenergebnisse, Abbildungen
6. **Testing und Validierung** – Versuchsaufbau, Auswertungen
7. **Diskussion** – kurze Abschnitte: Bewertung, Interpretation, Grenzen (als Aufzählung), Übertragbarkeit
8. **Fazit und Ausblick** – 8.1 Fazit (ein zusammenhängender Text, nennt die zentralen Kennzahlen erneut), 8.2 Ausblick (jeder Punkt als `\paragraph`)

Kapitel sind meist 2–6 Seiten lang, einzelne Abschnitte häufig nur ½–1 Seite.

---

## 5. Titelseite

Alles zentriert, `titlepage`-Umgebung, ohne Seitenzahl:

1. Oben: **zwei Logos nebeneinander**, Hochschule links, Team rechts (≈ 25 mm hoch)
2. Abstand, dann drei Zeilen in normaler und kleiner Schrift:
   Hochschulname (normalgroß) / Fachbereich (klein) / Studiengang (klein)
3. **Horizontale Linie** über die volle Textbreite
4. **Titel**: fett, ≈ 17–20 pt, mehrzeilig zentriert, großzügiger Zeilenabstand
5. Darunter in normaler Schrift die Art der Arbeit („Bachelorarbeit“ bzw. „Projektbericht“)
6. **Horizontale Linie**
7. „vorgelegt von“ (normal) / **Name** (fett, groß) / „Matrikelnummer: …“ (klein)
8. Betreuerblock **linksbündig in einer Tabelle, als Block zentriert**: „**Erstbetreuer:** Prof. Dr. …“ / „**Zweitbetreuer:** …, M. Sc.“ (Label fett)
9. Ganz unten: „Ort, TT.MM.JJJJ“

---

## 6. Eidesstattliche Erklärung

- Überschrift im Kapitelstil (unnummeriert)
- Standardtext. Der Titel der Arbeit steht **eingerückt, zentriert und kursiv** als eigener Absatz.
- Fett gesetzte Zwischenzeile **„Nutzung KI-gestützter Schreibwerkzeuge:“** mit Erklärungstext
- **„Eingesetzte KI-Werkzeuge:“** als `booktabs`-Tabelle mit den Spalten *Funktion | KI-Anwendung | Abschnitt | Bezugsquelle*. Die URL der Bezugsquelle steht als Fußnote („https://…, abgerufen am TT.MM.JJJJ.“) in Typewriter-Schrift.
- **„Hinweis:“** (fett) mit einer Klarstellung, dass alle fachlichen Inhalte vom Verfasser stammen
- Unterschriftszeile: „Ort,“ links und zwei Linien mit „Datum“ und „Name (Unterschrift)“ darunter

---

## 7. Verzeichnisse

- **Inhaltsverzeichnis:** Kapitel **fett und ohne Punktlinie**, Seitenzahl fett. Abschnitte und Unterabschnitte eingerückt, normal, mit Punktlinie. Zwischen den Kapiteln ein kleiner Abstand.
- **Abbildungs- und Tabellenverzeichnis:** Nummer (z. B. 5.3), Caption-Text, Punktlinie, Seite. Einträge verschiedener Kapitel sind durch eine Leerzeile getrennt (Standardverhalten von `report`). Es wird die **volle Caption** übernommen. Lange Captions werden deshalb auch im Verzeichnis lang (in der Referenz bis zu 4 Zeilen).
- **Abkürzungsverzeichnis:** alphabetisch, zweispaltig (Kürzel fett oder normal links, Langform rechts), **ohne Seitenzahlen**. Umsetzung mit `acro` oder `glossaries`.
- **Abkürzungen im Text:** Beim ersten Vorkommen erscheint die Langform mit Kürzel in Klammern („Extended Kalman Filter (EKF)“), danach nur das Kürzel. Das geschieht automatisch über `\ac{}`. Fachbegriffe bleiben auf Englisch, wenn sie im Fach üblich sind (Root Mean Square Error, Inertial Measurement Unit, Dead-Reckoning).

---

## 8. Abbildungen

- Zentriert, meist 70–100 % der Textbreite, Platzierung `[htbp]`
- **Caption unterhalb**, zentriert, Präfix **„Abbildung X.Y:“**. Nummerierung pro Kapitel.
- Caption-Schrift normalgroß bis klein, nicht fett. Lange Captions sind ausdrücklich erwünscht. Sie beschreiben, was oben/unten bzw. links/rechts zu sehen ist, die Farbcodierung („Messung (blau) und Modellsimulation (rot gestrichelt)“) und die wichtigsten Kennzahlen.
- Eigene Abbildungen werden in der Caption mit „(eigene Darstellung)“ gekennzeichnet.
- **Im Text immer vorher referenzieren:** „… ist in Abbildung 2.1 dargestellt.“, „Abbildung 6.1 zeigt …“. Keine Abkürzung „Abb.“, immer das ausgeschriebene „Abbildung“.
- Plots: MATLAB-Plots mit Gitter, Achsbeschriftung mit Einheit in eckigen Klammern (`Time [s]`, `v [m/s]`), Legende im Plot. Mehrere Subplots in einer Abbildung (oben/unten, links/rechts) sind üblich.
- Einfache Blockdiagramme (Signalkette) in TikZ: Kästchen mit Kürzeln, beschriftete Pfeile (Protokoll über dem Pfeil)
- Fotos vom realen Aufbau dürfen mit roten Bemaßungen oder Markierungen versehen sein.

---

## 9. Tabellen

- **`booktabs`-Stil**: `\toprule`, `\midrule`, `\bottomrule`, **keine senkrechten Linien**
- **Caption oberhalb**, zentriert, „Tabelle X.Y:“
- Kopfzeile **fett**
- Tabellenarten, die vorkommen sollen:
  - **Morphologischer Kasten** (Teilproblem × Optionen). Gewählte Optionen werden **hellgrün hinterlegt**, vorhandene aber nicht genutzte **grau** (`\cellcolor`). Darunter steht eine kleine Legende in Fließtextgröße mit kursivem Farbnamen: „*grün* = in dieser Arbeit gewählt; *grau* = vorhanden, nicht in dieser Arbeit genutzt“.
  - **Bewertungstabelle** mit der letzten Spalte bzw. Zeile „Entscheidung“ (Verwendet / Verworfen / Gewählt / Vorhanden)
  - **Ergebnistabellen** mit Kennzahlen
- Im Text: „(Tabelle 2.1)“ oder „Die Ergebnisse sind in Tabelle 2.2 zusammengefasst.“

---

## 10. Formeln

- Abgesetzte Formeln mit `equation`/`align`, **Nummer rechts im Format (Kapitel.Nr)**, z. B. (4.14)
- Formeln sind **Teil des Satzes**: Satzzeichen am Formelende (Komma oder Punkt). Danach folgt „wobei … die … beschreibt“ bzw. „Dabei ist …“ mit Erklärung jedes neuen Symbols.
- Vektoren **fett** (`\mathbf{x}`), Schätzwerte mit Dach (`\hat{\mathbf{x}}`), a-priori mit hochgestelltem Minus, Transponierte mit `^\top`, Mengen wie `\mathbb{R}^{3\times3}`
- Erklärende Unterklammern (`\underbrace{…}_{\text{…}}`) sind erlaubt.
- Querverweis im Text: „vgl. (5.20)“ oder „gemäß Gleichung (4.11)“. Abschnittsverweise ausgeschrieben: „in Abschnitt 5.7.5“, „in Kapitel 6“.
- **Zahlen:** deutsches Dezimalkomma (0,0249), Einheiten mit schmalem Leerzeichen (959 mm, 0,05 s, 1/16 °/s). Nutze `siunitx` mit `locale=DE`.
- Indizes, die Wörter sind, aufrecht setzen (v_{L,\mathrm{set}}, n_\mathrm{L})

---

## 11. Code, Dateinamen, Software

- Dateinamen, Funktionen, Topics, Nachrichtentypen, Variablen aus dem Code und Setup-Namen in **Typewriter**: `Plot_Vel.m`, `iddata`, `/imu/data`, `sensor_msgs/msg/Imu`, `update()`, `final_2`
- Es gibt **keine längeren Code-Listings** im Fließtext. Software wird beschrieben, nicht abgedruckt.
- Produkt- und Firmennamen normal geschrieben (Raspberry Pi 5, Nvidia Jetson TX2, Tinkerforge IMU Brick 2.0)

---

## 12. Aufzählungen

- `itemize` mit Standard-Bullets, kompakt, kein zusätzlicher Abstand zwischen den Punkten
- Einsatz: Anforderungen, Bewertungskriterien, Grenzen des Modells, Begründungen
- Ein Punkt ist ein ganzer Satz oder eine Nominalphrase. Bei Begründungslisten beginnt er mit einem Stichwort und einem Gedankenstrich: „Zuverlässige Konvergenz – der strukturierte Startpunkt verhindert, dass …“
- Eingeleitet werden Listen mit einem Satz mit Doppelpunkt („Zu den wichtigsten Bewertungskriterien zählen:“).
- **Alternative zu Listen:** Absätze, die mit einem **fett gesetzten Begriff** beginnen und in denen der Text direkt weiterläuft („**Encoder** sind bereits in den Antriebsmotoren integriert …“, „**n4sid:** n4sid ist ein …“). So werden Optionen, Sensoren oder Verfahren nacheinander bewertet.

---

## 13. Zitieren und Literaturverzeichnis

- **Numerischer IEEE-Stil** mit eckigen Klammern [1], [2]. Nummeriert in der Reihenfolge des ersten Zitats (`biblatex`, `style=ieee`, Sprache deutsch).
- Das Zitat steht **vor dem Satzpunkt**, mit Leerzeichen (geschütztes Leerzeichen `~\cite{}`): „… realisiert [7].“ In der Referenz fehlt das Leerzeichen manchmal („Overfitting[2]“). Diesen Fehler **nicht** übernehmen.
- Autor im Satz: „nach Hobbani et al. [2]“, „im Referenzpaper [2]“
- Auch Datenblätter, Hersteller-Dokus, GitHub-Repos und Software-Dokumentation werden zitiert. Hardware wird beim ersten Erwähnen mit einer Quelle belegt.
- Literaturverzeichnis (deutsche biblatex-ieee-Lokalisierung):
  - Hängender Einzug mit Nummer [n] links
  - Titel von Artikeln in „englischen Anführungszeichen“, Zeitschrift bzw. Buch *kursiv*
  - Deutsche Bezeichner: „Jg.“, „Nr.“, „S.“, „Aufl.“, „Techn. Ber.“, „Adresse:“ vor der URL, „(besucht am TT. MM. JJJJ)“
  - DOI als „doi: 10.…“ in Typewriter
  - URLs in Typewriter, mit Umbruch erlaubt (`\usepackage{url}` bzw. `xurl`)

```latex
\usepackage[backend=biber, style=ieee, language=ngerman]{biblatex}
```

---

## 14. Querverweise und Links

- `hyperref` mit **unsichtbaren Links** (keine farbigen Kästen, keine farbige Schrift)
- Verweise immer mit `\ref`/`\eqref` und ausgeschriebenem Typ: „Abbildung~\ref{}“, „Tabelle~\ref{}“, „Abschnitt~\ref{}“, „Kapitel~\ref{}“. Alternativ `cleveref` mit deutscher Langform.

---

## 15. Schreibstil (Sprache)

### Ton und Perspektive
- **Sachlich-wissenschaftlich, unpersönlich.** Es gibt **kein „ich“ und kein „wir“** im Hauptteil, nur in der Eidesstattlichen Erklärung.
- Viel **Passiv und „es wird“-Konstruktionen**: „Hierzu wird eine reproduzierbare Entwicklungsumgebung aufgebaut.“, „Die Bewertung erfolgt getrennt für …“
- Feststehende Wendungen: „die vorliegende Arbeit“, „im Rahmen dieser Arbeit“, „in dieser Arbeit“, „im weiteren Verlauf der Arbeit“
- **Tempus:** Methodik und Systembeschreibung im **Präsens** („Der EKF arbeitet rekursiv …“), durchgeführte Arbeitsschritte im **Präteritum oder Perfekt-Passiv** („wurde … integriert“, „wurde validiert“)

### Satzbau
- Mittellange, gut verständliche Sätze, meist 15–30 Wörter, oft mit Nominalstil („zur Verbesserung der Zustandsrekonstruktion“)
- Der **Gedankenstrich (–, Halbgeviert)** wird häufig für Einschübe und Zuspitzungen genutzt: „… die Yaw-Rate – eine zentrale Zustandsgröße der Differentialkinematik.“ In LaTeX: ` -- `.
- Gelegentlich eine **rhetorische Einleitung** in der Einleitung (Fragen wie „Wo befinde ich mich?“), danach rein sachlich
- Doppelpunkt-Konstruktionen, um ein Ergebnis anzukündigen: „Die Kombination … stellt die geeignete Lösung dar: Die Encoder bilden …, während …“
- Begründungen werden ausdrücklich formuliert: „daher“, „da …“, „Dadurch …“, „Daher verworfen.“ (kurzer elliptischer Satz am Ende einer Optionsbewertung ist erlaubt)
- Erklärungen für Laien werden eingeschoben: „Ein großes K_k bedeutet: der Filter vertraut der Messung stärker; ein kleines …“

### Absatz- und Abschnittslogik
- Jeder Abschnitt **beginnt mit einem einleitenden Satz**, der Zweck oder Kontext nennt („Neben der Auswahl geeigneter Sensorik spielt auch … eine zentrale Rolle.“).
- Abschnitte **enden oft mit einem überleitenden oder zusammenfassenden Satz** („Die dargestellte Systemarchitektur bildet die Grundlage für die weiteren Schritte der Arbeit.“).
- **Entscheidungen werden immer begründet**, und verworfene Alternativen werden genannt (mit Begründung, warum sie nicht gewählt wurden).
- **Abgrenzung ausdrücklich formulieren**: „Nicht Bestandteil dieser Arbeit ist …“, „… werden im Rahmen dieser Arbeit nicht genutzt und sind für zukünftige Erweiterungen vorgesehen.“
- **Einschränkungen ehrlich benennen**: eigener `\paragraph`-Absatz „Einschränkungen“ oder eine Aufzählung „Grenzen des Modells“. Dabei wird gesagt, was nicht gemacht wurde und warum das ausreicht.
- Ergebnisse werden **mit konkreten Zahlen** genannt (R² = 0,9915, d_end = 0,216 m) und im Fazit noch einmal aufgegriffen.
- Absätze sind eher kurz bis mittel (3–8 Zeilen). Kein Absatz besteht aus nur einem Satz, außer bei Überleitungen.

### Wortwahl
- Deutsche Fachsprache, englische Fachbegriffe werden beibehalten und nicht kursiv gesetzt (Dead-Reckoning, Overfitting, Setup, Node, Topic). Komposita werden mit Bindestrich gebildet: „ROS 2-Node“, „EKF-Schätzung“, „Soll-Ist-Vergleich“.
- Kursiv nur zur Hervorhebung beim **Einführen eines Begriffs** (*Prozessrauschkovarianz*)
- Keine Umgangssprache, keine Ausrufezeichen, keine Füllwörter wie „eigentlich“ oder „halt“

---

## 16. Kurze Checkliste für Claude Code

- [ ] 12 pt Latin Modern, einfacher Zeilenabstand, `parskip` (kein Einzug)
- [ ] A4, Ränder ca. 31 mm links und rechts
- [ ] Kopfzeile: Kapitelname kursiv, mittig, mit Linie. Fußzeile: Logo links, Seitenzahl mittig, Logo rechts, mit Linie
- [ ] Kapitel ohne „Kapitel“-Präfix, neue Seite, Kopf und Fuß auch auf Kapitelseiten
- [ ] `\paragraph` als serifenlose, fette Run-in-Überschrift
- [ ] Reihenfolge: Titel → Erklärung (+ KI-Tabelle) → Inhalt → Abbildungen → Tabellen → Abkürzungen → Hauptteil → Literatur
- [ ] Arabische Seitenzahlen ab Titelseite (Titel ohne Nummer)
- [ ] Abbildungs-Caption unten, Tabellen-Caption oben, `booktabs`, Nummern pro Kapitel
- [ ] Gleichungsnummern (K.N), Satzzeichen an Formeln, „wobei …“-Erklärungen
- [ ] `acro`/`glossaries` mit automatischer Erstnennung, Abkürzungsverzeichnis ohne Seitenzahlen
- [ ] `biblatex` IEEE deutsch, `~\cite{}` vor dem Punkt
- [ ] `siunitx` mit Dezimalkomma
- [ ] Unpersönlicher Stil, Passiv, Gedankenstriche, jede Entscheidung begründet, Abgrenzung und Grenzen ausdrücklich
