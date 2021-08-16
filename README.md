# Projektarbeit-Haskell-Regulaere-Ausdruecke

In diesem Github Repository geht es um die Projekt Arbeit von Jonas E die sich mit der Umsetzung von Diversen Anwendungsfällen rund um Reguläre Ausdrücke in der Programmiersprache Haskell beschäftigt.

Die Aufgabestellungen sind unter https://sulzmann.github.io/SoftwareProjekt/labor.html#(10) zu finden.

Die Einarbeitung in Haskell wurde mit dem Beginner's Guide "Lean you a Haskell" durchgeführt dieser ist unter http://learnyouahaskell.com/ zu finden.

## Haskell Erweiterung & Ausführung des Codes in VS Code

Der Code wurde in Visual Studio Code mit GHC Haskell erweiterung entwickelt, diese ist im Marketplace für Visual Studio zu finden https://marketplace.visualstudio.com/items?itemName=haskell.haskell.
Die Haskell Erweiterung wird zum kompilieren und ausführen des Codes verwendet. Für verbessertes Code Highlighting wurde noch eine Haskell Syntax Highlighting Erweiterung verwendet https://marketplace.visualstudio.com/items?itemName=justusadam.language-haskell .

Zur verwendung von GHC muss zuerst in das Projekt Verzeichnis Navigiert werden. Anschliesend kann mit ghci die GHC interactive console gestartet werden. Als nächstes muss der Code mit <:l Regs.hs> kompiliert werden.
Nun kann man in der Konsole beliebig Funktionen aufrufen.

I think you should use an
`<addr>` element here instead.

## Datenstruktur regulärer ausdruck
Basis für alle Regulären Ausdrücke in diesem Projekt ist die Algebraische datenstruktur "Ausdruck"

data Ausdruck = Epsilon | Phi | C Char | Alternative Ausdruck Ausdruck | Konkatenation Ausdruck Ausdruck| Sternbildung Ausdruck deriving (Show)


Mithilfe dieser Datenstruktur Lassen sich beliebige gültige Reguläre Ausdrucke erstellen es ist nicht möglich
mit dem algebraischen datentyp ein objekt zu erstellen das nicht dem konstruktor entspricht
besonders zu beachten ist hierbei die rekursive struktur des datentyps möchte man zb.
eine Konkatenation von "A" und "B" darstellen dann besteht dieser aus 3 teil Ausdrücken
aus C "A" ,  C "B" und Konkatenation Ausdruck Ausdruck - dabei fügt man die Teilausdrücke für die Zeichen
in den Ausdruck der konkatenation also hier Konkatenation (C "A") (C "B")
die klammern sind wichtig da das erstellen einer konkatenation zwei parameter erwartet
alternativ könnte man auch die Teil ausdrücke C"A" und C"B" in zwei Variablen speichern und stattdessen die 
Variablen angeben also z.b. Teil1 = C "A", Teil2 = C "B" und dann einfügen Konkatenation Teil1 Teil2

### Code beispiele zum erstellen von Ausdrücken
der code zum erstellen des Ausdrucks (A|B)*
Sternbildung(Konkatenation (C "A") (C "B"))

Ausdruck A A*
Konkatenation ((C "A") (Sternbildung (C"A"))

Ausdruck A B C
Konkatenation(Konkatenation((C"A")(C"B")) (C"C"))
da in unserer Struktur konkatenationen immer zweistellig sind muss für die konkatenation von 3 zeichen
2x konkateniert werden

## vereinfachung regulärer ausdruck
vereinfachung :: Ausdruck -> Ausdruck
Die funktion nimmt einen Regulären Ausdruck und gibt einen anhand einer Menge von Regeln vereinfachten
Ausdruck zurück. Das Durchschreiten des Ausdrucks erfolgt Rekursiv. Das erkennen welche vereinfachungsregel
angewendet werden soll wird mit Pattern matching erreicht dabei prüft die funktion nacheinander von oben nach
unten in der methode welches pattern er hat und wendet dann die funktion nach dem gleichzeichen aus, wichtig
dabei zu beachten ist das immer nur der oberste teil des ausdrucks bei jedem durchlauf betrachtet wird
gibt man zum beispiel den Ausdruck Vereinfachung Konkatenation ((C "A") (Sternbildung (C"A")) an dann wird im ersten durchlauf
erkannt das es sich um eine Konkatenation mit zwei beliebigen parametern a b handelt. Da sich dies nicht vereinfachen
lässt wird die konkatenation beibehalten und es werden für die Darunter liegende Teilausdrücke
jeweils die Vereinfachung funktion aufgerufen. Beim ersten aufruf wird erkannt das es sich um ein C handelt 
da es keine weitere verschachtelung gibt wird C "A" zurück gegeben. Beim anderen aufruf wird erkannt das es sich
um eine Sternbildung mit beliebigem Parameter handelt, für diesen parameter wird wider vereinfachung aufgerufen
anschliesend wird erkannt das es sich um ein C handelt und dieses wider direkt zurück gegeben

liste der regeln aus doku einfügen
aufrufbaum für beispiel einfügen


## printen von regulärem ausdruck
Bei der Funktion Ausdruck Printen wird ein Ausdruck in einen String umgewandelt
Dabei wird wie bei der vorheringen funktion das durchschreitten rekursiv durchgeführt und das unterscheiden der 
verschiedenen situationen mithilfe von Pattern matching gemacht
beispiel code ausdruckPrinten Konkatenation((C"A")(C"B")
ergebnis AB

datenstruktur transitionen
data Transition = Transition Int Char Int deriving (Show)
die Datenstruktur wird zum erstellen von Transitionen innerhalb eines Automaten benutzt
dabei steht der erste Int für den ausgangszustand der Char für das Zeichen das bei der Transition eingesetzt werden soll
- für einen spontanen übergang wir "-" eingesetzt der zweite int steht für den zielzustand der nach ausführen
der transition erreicht wird

beispiel Transition 1 "A" 2
ist die Transition von Zustand 1 mit dem Zeichen "A" in den Zustand 2


datenstruktur Automat
data Automat = Automat [Transition] Int deriving (Show)
Die Datenstruktur wird zum erstellen von Automaten benutzt
Ein Automat enthält eine Liste von Transitionen und einen Int für den Endzustand 
des Automaten - der Startzustand ist immer die 1 daher wird er hier nicht angegeben
alle Automaten haben nur einen Start und Endzustand

## Hilfsfunktion

Zustandsnummern Erhöhen
zustandsnummernErhöhen :: Automat -> Int -> Automat
erhöht alle zustandsnummern im Automat um int und gibt Automat zurück
Parameter:
Automat - Automat dessen Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
Automat - Rückgabe des Automaten

Tripple Liste Erhöhen
trippleListeErhöhen :: [Transition] -> Int -> [Transition]
erhöht alle zustandsnummern in einer Liste von Tripplen
Parameter:
[Transition] - Liste von Transitionen der Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
[Transition] - Rückgabe der Liste von Transitionen mti angepassten Zustandsnummern

Tripple zustand erhöhen
zustandsnummerInTrippleErhöhen :: Transition -> Int -> Transition
erhöht alle Zustandsnummern in einem Tripple
Parameter:
Transition - Transitionen deren Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
Transition - Rückgabe der Transitionen mit angepassten Zustandsnummern


## Automat erstellen
erstellt aus einem Regulären Ausdruck einen Automaten der genutzt werden kann
um zu prüfen ob ein Wort teil des Regulären Ausdrucks ist
Parameter:
Ausdruck - Ausdruck der Umgewandelt werden soll
Automat - Rückgabe des erstellten Automaten
Das durchlaufen des audrucks erfolgt rekursiv - die unterscheidung von verscheidenen situationen
erfolgt mithilfe von Pattern matching
wichtig beim erstellen des automaten ist das es keine Kreisläufe von Spontanen übergängen geben darf
da sonst das ausführen des Automaten in einer endlos schleife hängen bleibt

aufrufbaum für ein beispiel

umwandlungsregeln 
C
konkatenation
Sternbildung
Alternative

bilder wie umwandlung passieren muss damit keine kreise entstehen - hinweis das ja beim vereinfachen doppelte
sternbildung schon rausgeworfen wird
    vermeiden von schleifen mit epsilon übergängen


## Automat ausführen
Führt Automat auf ein Wort aus um zu sehen ob dieses teil des Automaten bzw des regulären ausdrucks
aus dem der Automat erstellt wurde. Wenn das Wort teil des Automaten war wird true zurück gegeben
falls nicht false
ausführen :: Automat -> Int -> String -> Bool
Parameter:
Automat - Automat der ausgeführt werden soll
Int - Startzustand in dem der Automat gestartet werden soll
String - Wort das geprüft werden soll
Bool - Rückgabe ob wort teil des Automaten war oder nicht
Beim ersten Aufruf des Automaten sollte immer 1 für den Startzustand angegeben werden

Das Automat ausführen funktioniert rekursiv und mit pattern matching
Bei jedem rekusriven aufruf wird für jeden in diesem Zustand und mit dem aktuelle zeichen
gültige transition ein neuer rekursiver aufruf gemacht - erreicht ein pfad den endzustand und hat kein ezichen übrig so returnt
dieser true und beim rücklaufen der rekursion wird dieses true weitergegeben bis zum ursprünglichen aufruf

kann evtl bei der filter funktion in automat ausführen auch gleich geprüft werden ob das zeichen passt

aufrufbaum für ein beispiel erstellen



## Vergleich zu c++ umsetzung