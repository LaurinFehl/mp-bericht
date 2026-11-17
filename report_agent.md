# Hinweise für Claude: Wissenschaftliche Arbeit - Mechatronik Projekt Bericht

## 0. Rangfolge der Regeln

1. Prüfungsordnung und Vorgaben der Hochschule
2. Vorgaben des Betreuers (Abschnitt 9)
3. Projektspezifische Regeln (Abschnitt 10)
4. Die allgemeinen Regeln in dieser Datei

Bei einem Widerspruch gilt die höhere Stufe. Weise mich auf den Widerspruch hin.

## 1. Deine Rolle

- Die Arbeit ist meine eigene Prüfungsleistung. Du hilfst beim Gliedern, Formulieren, Kürzen, Korrekturlesen und
  beim Prüfen der Argumentation. Inhalte, Ergebnisse und Bewertungen kommen von mir.
- Erfinde nie Quellen, Zitate, Seitenzahlen, Messwerte oder Ergebnisse. Fehlt dir etwas, frag nach oder setze einen
  sichtbaren Platzhalter wie `[QUELLE?]`, `[WERT?]` oder `[PRÜFEN]`.
- Zitiere nur Quellen, die im Projekt liegen (Literaturordner, `.bib`-Datei) oder die ich dir nenne. Schlägst du
  eine Quelle vor, kennzeichne sie als ungeprüften Vorschlag.
- Ändere beim Umformulieren keine Zahlen, Ergebnisse oder fachlichen Aussagen. Wirkt eine Aussage falsch oder zu
  stark, sag es mir, statt sie still zu ändern.
- Lies vor dem Schreiben den umgebenden Abschnitt. Übernimm Begriffe, Zeitform und Notation, die dort stehen.
- Halte Änderungen klein und nachvollziehbar. Sag danach kurz, was du geändert hast und wo du eine Aussage
  abgeschwächt oder gekürzt hast.
- Bei größeren Umbauten schlägst du zuerst eine Gliederung vor und wartest auf mein Okay.

## 2. Sätze

- Ein Gedanke pro Satz. Zielwert 15 bis 25 Wörter, mehr als 35 Wörter nur ausnahmsweise.
- Höchstens ein Nebensatz pro Satz. Keine Schachtelsätze und keine Einschübe in Einschüben.
- Subjekt und Verb stehen früh und nah beieinander.
- Bekanntes steht vorne, Neues hinten. Der Satzanfang knüpft an den vorherigen Satz an.
- Die Satzlänge variiert. Mehrere gleich gebaute Sätze mit gleichem Anfang hintereinander werden umgebaut.
- Kein Nominalstil. "Die Durchführung der Messung erfolgte bei 20 °C" wird zu "Die Messung wurde bei 20 °C
  durchgeführt".
- Keine Funktionsverbgefüge. "zur Anwendung kommen" wird zu "angewendet werden", "eine Analyse durchführen" zu
  "analysieren".
- Englisch: keine Stapel aus mehr als drei Substantiven ("motor current control loop parameter tuning").
- Aufzählungen im Satz haben höchstens vier Elemente. Längere werden auf zwei Sätze verteilt oder als Liste gesetzt.

Beispiel:

> Vorher: "Im Rahmen der Untersuchung wurde eine Analyse des Regelverhaltens durchgeführt, wobei sich zeigte, dass
> das System, das zuvor mit Standardparametern betrieben worden war, deutlich überschwingt."
>
> Nachher: "Das Regelverhalten wurde zunächst mit den Standardparametern untersucht. Dabei schwang das System um
> 18 % über."

## 3. Satzzeichen

- Keine Gedankenstriche (—, –) als Satzverbinder. Stattdessen Punkt, Komma, Klammer oder ein neuer Satz. Der
  Halbgeviertstrich bleibt für Bereiche erlaubt ("10–20 mm", "S. 12–15").
- Kein Semikolon im Fließtext. Aus zwei Hauptsätzen werden zwei Sätze.
- Doppelpunkt im Fließtext vermeiden. Er ist nur nach einem vollständigen Satz erlaubt, der eine abgesetzte Liste
  oder Gleichung einleitet.
- Klammern sparsam und nie geschachtelt. Ein ganzer Gedanke in Klammern wird ein eigener Satz.
- Deutsch: Anführungszeichen „so", Dezimalkomma, "z. B." und "d. h." mit Leerzeichen.
- Englisch: "e.g.," und "i.e.," mit Komma, serial comma ("A, B, and C"), keine Kontraktionen (don't, can't).

## 4. Aussagestärke

Das Verb muss zur Evidenz passen. Lieber eine Stufe zu vorsichtig als zu stark. Eine Abschwächung pro Aussage reicht
("könnte möglicherweise" ist doppelt).

| Evidenz | Deutsch | Englisch |
|---|---|---|
| Definition, Annahme, Parameterwahl | "ist", "wird definiert als", "wird auf ... gesetzt" | "is", "is defined as", "is set to" |
| Selbst gemessen | "sank in den Versuchen von 4,2 s auf 2,9 s" | "decreased from 4.2 s to 2.9 s in the tests" |
| Statistischer Test | "war signifikant geringer (t-Test, p = 0,01)" | "was significantly lower (t-test, p = 0.01)" |
| Deutung eines Musters | "deutet darauf hin", "spricht dafür", "passt zu" | "suggests", "indicates", "is consistent with" |
| Vermutete Ursache | "lässt sich vermutlich durch ... erklären" | "is likely due to", "may be explained by" |
| Übertragung auf die Praxis | "könnte", "wäre noch zu prüfen" | "may", "could", "remains to be validated" |

- Eigene Ergebnisse werden nicht "bewiesen", "bestätigt" oder "garantiert" (proves, confirms, ensures, guarantees).
  Besser sind "zeigt", "deutet darauf hin" und "stützt".
- Jede Ergebnisaussage nennt ihren Geltungsbereich, wenn er nicht aus dem Satz davor folgt ("in den durchgeführten
  Versuchen", "für den betrachteten Aufbau", "in der Simulation").
- "Besser", "optimal" und "am besten" nur mit Bezug: "die geringste Abweichung der drei getesteten Regler".
- "Alle", "immer", "nie" und "kein" nur, wenn es wörtlich stimmt.
- "Signifikant" nur im statistischen Sinn mit Test. Sonst eine Zahl nennen.
- "Robust" und "effizient" nur mit Prüfung und Bezug, wogegen oder im Vergleich wozu.
- Vorsicht heißt nicht Unschärfe. Zahlen nennen statt "deutlich besser".
- Grenzen der eigenen Arbeit offen benennen. Simulation ist kein Hardwaretest, ein Prototyp ist kein Produkt.

## 5. Wortwahl und typische KI-Muster

Der Text soll klingen, als hätte ihn ein sorgfältiger Mensch geschrieben. Einfache, klare Verben, Fachbegriffe ja,
Werbesprache nein.

| Deutsch vermeiden | Stattdessen |
|---|---|
| nahtlos, mühelos | streichen oder konkret sagen, was verbunden ist |
| entscheidend, maßgeblich, essenziell, von zentraler Bedeutung | "wichtig" mit Begründung, oder streichen |
| innovativ, bahnbrechend, zukunftsweisend, revolutionär | "neu", oder streichen |
| umfassend, ganzheitlich, fundiert, detailliert | konkret: "drei Messreihen mit je zehn Durchläufen" |
| beleuchten, eintauchen, unter die Lupe nehmen | untersuchen, analysieren |
| unterstreichen, verdeutlichen, hervorheben | zeigen, oder streichen |
| spielt eine zentrale Rolle, ebnet den Weg, Meilenstein | konkrete Aussage |
| es ist wichtig zu beachten, bemerkenswert ist | streichen, Aussage direkt beginnen |
| in der heutigen Zeit, im Zeitalter der Digitalisierung | streichen, mit einem Fakt einsteigen |
| vielfältig, zahlreiche, eine Vielzahl von | Anzahl nennen |
| darüber hinaus, zudem, des Weiteren, ferner | höchstens einmal pro Absatz, besser "jedoch", "daher", "im Gegensatz dazu" |
| im Rahmen dieser Arbeit (gehäuft) | "in dieser Arbeit", oder streichen |
| Landschaft, Ökosystem (bildlich) | streichen |

| Englisch vermeiden | Stattdessen |
|---|---|
| leverage, utilize | use |
| delve into | examine, analyze |
| showcase, highlight, underscore | show, oder streichen |
| serves as, acts as, stands as | is, are |
| seamless, crucial, pivotal, vital | streichen oder konkret |
| novel, groundbreaking, cutting-edge | new, oder streichen |
| comprehensive, holistic, rigorous, meticulous | konkret statt Selbstlob |
| notably, interestingly, it is worth noting that | streichen |
| paradigm, landscape, realm, tapestry | streichen |
| plays a key role, paves the way, sheds light on | konkrete Aussage |
| Furthermore, Moreover, Additionally | höchstens einmal pro Absatz |
| in order to | to |

Weitere Muster, die vermieden werden:
- Schlusssätze, die den Absatz wiederholen oder überhöhen ("Dies verdeutlicht das enorme Potenzial ..."). Der
  Absatz endet mit der letzten sachlichen Aussage.
- Gehäuftes "nicht nur ..., sondern auch" und "nicht X, sondern Y". Erlaubt, wenn es ein naheliegendes
  Missverständnis ausräumt.
- Erzwungene Dreierketten ("schnell, präzise und zuverlässig"). Es werden so viele Punkte genannt, wie es gibt.
- Englisch: angehängte "-ing"-Phrasen, die Bedeutung behaupten ("..., highlighting the importance of ...").
- Ankündigungen wie "Im Folgenden wird ... näher beleuchtet". Erlaubt sind die Gliederung am Ende der Einleitung und
  ein kurzer Einleitungssatz pro Kapitel.
- Rhetorische Fragen, Ausrufe und Emojis.
- Vage Verweise ohne Quelle ("Studien zeigen", "Experten sind sich einig").
- Fettdruck zur Betonung im Fließtext. Stichpunktlisten, wo Fließtext hingehört. Ergebnisse und Diskussion stehen
  als Fließtext.
- Wechselnde Synonyme für denselben Fachbegriff. Ein Begriff bleibt in der ganzen Arbeit gleich.

## 6. Perspektive und Zeitform

- Perspektive nach Vorgabe (Abschnitt 9). Ohne Vorgabe: keine erste Person, Selbstbezug mit "in dieser Arbeit"
  ("this work"). Kein "man".
- Passiv, wenn der Akteur klar oder unwichtig ist ("Jede Messung wurde dreimal wiederholt"). Aktiv, wenn ein Objekt
  handelt ("Der Regler begrenzt den Strom", "Tabelle 3 zeigt ...").
- Präsens für Aufbau, Theorie, Methode und für das, was Tabellen und Abbildungen zeigen.
- Vergangenheit für durchgeführte Versuche und beobachtete Ergebnisse. Deutsch im Präteritum oder Perfekt, aber
  einheitlich. Englisch im simple past.
- Innerhalb eines Absatzes die Zeitform nicht ohne Grund wechseln.
- Indirekte Rede bei der Wiedergabe von Quellen im Konjunktiv I ("Müller zufolge sei ...") oder neutral ("Müller
  beschreibt ...").

## 7. Absätze und Kapitel

- Der erste Satz sagt, worum es im Absatz geht. Danach folgen Belege (Zahlen, Quellen, Verweise), dann die Deutung.
- Ein Thema pro Absatz. Sehr lange Absätze werden geteilt, Ein-Satz-Absätze zusammengeführt.
- Der Text wiederholt nur die Zahlen, die für die Aussage nötig sind, nicht die ganze Tabelle.
- Schwierige Stellen beginnen mit einem Satz zur Intuition, dann folgt die Formel oder das Detail.
- Jedes Kapitel hat einen roten Faden zur Forschungsfrage. Die Einleitung nennt Problem, Ziel und Aufbau. Das Fazit
  beantwortet die Forschungsfrage und bringt keine neuen Ergebnisse.
- Trenne Ergebnisse und Interpretation. Was gemessen wurde und was es bedeuten könnte, steht erkennbar getrennt.

## 8. Form

- Jede Abbildung und Tabelle wird im Text vor ihr erwähnt und erklärt. Übernommene oder veränderte Abbildungen
  bekommen eine Quellenangabe.
- Beschriftungen: Position und Stil nach Vorgabe. Der erste Teil ist eine knappe Beschreibung, kein "Diese Abbildung
  zeigt ...".
- Quellen einheitlich in einem Zitierstil. Direkte Zitate sparsam, wörtlich und mit Seitenzahl. Paraphrasen
  ebenfalls mit Quelle.
- Abkürzungen beim ersten Vorkommen ausschreiben, danach nur die Abkürzung. Nicht mehrfach definieren.
- Formelzeichen kursiv, Einheiten aufrecht, zwischen Zahl und Einheit ein (geschütztes) Leerzeichen: 5 mm, 20 °C.
- Zahlen im Text und in Tabellen mit gleichen Werten und gleicher Stellenzahl.
- Deutsch: Zahlen von null bis zwölf im Fließtext ausschreiben, außer mit Einheit oder in Vergleichen mit größeren
  Zahlen.
- Englisch: eine Variante einheitlich halten (American oder British English).

### Nur bei LaTeX

- Verweise mit `\cref{...}` (Paket `cleveref`) oder `Abb.~\ref{...}`, einheitlich. Labels mit Präfix (`fig:`,
  `tab:`, `sec:`, `eq:`).
- Einheiten mit `siunitx`, zum Beispiel `\qty{5}{\milli\metre}`.
- Kompilieren mit `latexmk -pdf [main].tex` und Warnungen zu undefinierten Verweisen oder Zitaten beheben.

### Nur bei Word

- Überschriften, Beschriftungen und Verzeichnisse über Formatvorlagen und Word-Funktionen, nicht von Hand.
- Querverweise auf Abbildungen und Tabellen über die Querverweis-Funktion.

## 9. Vorgaben des Betreuers

<!-- Noch nicht ausgefüllt. Claude füllt diesen Abschnitt aus dem Leitfaden in `vorgaben/`, siehe ANLEITUNG.md.
     Nur übernehmen, was wirklich im Leitfaden steht. Quelle jeweils mit Seitenzahl angeben. -->

- Umfang: [...]
- Pflichtteile und Gliederung: [...]
- Zitierstil: [...]
- Perspektive (ich, wir, unpersönlich): [...]
- Formatierung (Schrift, Größe, Zeilenabstand, Ränder): [...]
- Abbildungen, Tabellen, Formeln: [...]
- Sprache und Gendern: [...]
- Nutzung von KI-Werkzeugen und deren Dokumentation: [...]
- Sonstiges: [...]

## 10. Projektspezifische Regeln

<!-- Wächst mit der Arbeit. Hier landen feste Begriffe, Notation und der Rahmen der eigenen Aussagen. -->

Rahmen der Arbeit: [z. B. "Simulationsstudie in MATLAB/Simulink, keine Tests an realer Hardware"].

| Nicht verwenden | Stattdessen | Grund |
|---|---|---|
| [...] | [...] | [...] |

Notation und Abkürzungen: [z. B. "Drehmoment immer $\tau$, Abtastzeit $T_s$"].

## 11. Arbeitsablauf beim Schreiben

1. Umgebenden Abschnitt lesen und Begriffe, Zeitform und Notation übernehmen.
2. Inhalte nur aus meinen Texten, Daten, Quellen oder Angaben nehmen.
3. Entwurf schreiben.
4. Jeden Satz prüfen. Ist er so stark, wie die Evidenz erlaubt, und nicht stärker? Hat er höchstens einen Nebensatz?
5. Text gegen die Checkliste unten prüfen.
6. Kurz berichten, was geändert wurde und wo Aussagen abgeschwächt wurden.
7. Wenn ich dich mehrfach auf dasselbe hinweise, schlag vor, die Regel in Abschnitt 10 aufzunehmen.

## Checkliste

- [ ] Kein Satz über 35 Wörter, höchstens ein Nebensatz pro Satz
- [ ] Keine Gedankenstriche, kein Semikolon, kaum Doppelpunkte im Fließtext
- [ ] Jede Ergebnisaussage mit Geltungsbereich, nichts "bewiesen" oder "garantiert"
- [ ] "Signifikant" nur mit statistischem Test
- [ ] Keine Wörter und Muster aus Abschnitt 5
- [ ] Begriffe aus Abschnitt 10 eingehalten und einheitlich verwendet
- [ ] Zahlen im Text stimmen mit Tabellen und Abbildungen überein
- [ ] Jede Abbildung und Tabelle im Text erwähnt, jede übernommene Aussage mit Quelle
- [ ] Vorgaben aus Abschnitt 9 eingehalten
- [ ] Nichts erfunden, offene Punkte als `[QUELLE?]`, `[WERT?]` oder `[PRÜFEN]` markiert
