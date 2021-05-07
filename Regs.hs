

--"Epsilon" der leere String
-- "Phi" die leere Sprache
-- das Zeichen c
-- Alternative zwischen r1 und r2
-- Verkettung/Konkatenation von r1 mit r2
-- Kleenesche Hülle, entweder leerer String oder beliebige Verkettung von r

--Ausdruck/Expression
data Ausdruck = Epsilon | Phi | C String | Alternative Ausdruck Ausdruck | Konkatenation Ausdruck Ausdruck| Sternbildung Ausdruck deriving (Show)




vereinfachung :: Ausdruck -> Ausdruck
vereinfachung (Phi) = Phi
vereinfachung (Epsilon) = Epsilon
vereinfachung (C a) = C a
vereinfachung (Konkatenation a Phi) = Phi
vereinfachung (Konkatenation Phi a) = Phi
vereinfachung (Konkatenation a Epsilon) = vereinfachung a
vereinfachung (Konkatenation Epsilon a) = vereinfachung a
vereinfachung (Konkatenation a b) = Konkatenation (vereinfachung a) (vereinfachung b)
vereinfachung (Alternative a Phi) = vereinfachung a
vereinfachung (Alternative Phi a) = vereinfachung a
vereinfachung (Alternative a b) = if ((ausdruckPrinten (vereinfachung(a))) == (ausdruckPrinten (vereinfachung(a)))) then vereinfachung a else Alternative (vereinfachung a) (vereinfachung b) 
vereinfachung (Sternbildung Phi) = Epsilon
vereinfachung (Sternbildung Epsilon) = Epsilon
vereinfachung (Sternbildung (Sternbildung a)) = vereinfachung (Sternbildung a)
vereinfachung (Sternbildung a) = Sternbildung (vereinfachung a)


ausdruckPrinten :: Ausdruck -> String
ausdruckPrinten (Phi) = "Phi"
ausdruckPrinten (Epsilon) = "Eps"
ausdruckPrinten (C a) = a
ausdruckPrinten (Konkatenation a b) = (ausdruckPrinten a) ++ " " ++ (ausdruckPrinten b)
ausdruckPrinten (Alternative a b) = (ausdruckPrinten a) ++ " + " ++ (ausdruckPrinten b) 
ausdruckPrinten (Sternbildung a) = (ausdruckPrinten a) ++ "*"



vereinfachungMitPrint :: Ausdruck -> String
vereinfachungMitPrint (Phi) = "Phi"
vereinfachungMitPrint (Epsilon) = "Eps"
vereinfachungMitPrint (C a) = a
vereinfachungMitPrint (Konkatenation a Phi) = "Phi"
vereinfachungMitPrint (Konkatenation Phi a) = "Phi"
vereinfachungMitPrint (Konkatenation a Epsilon) = vereinfachungMitPrint a
vereinfachungMitPrint (Konkatenation Epsilon a) = vereinfachungMitPrint a
vereinfachungMitPrint (Konkatenation a b) = (vereinfachungMitPrint a) ++ " " ++ (vereinfachungMitPrint b)
vereinfachungMitPrint (Alternative a Phi) = vereinfachungMitPrint a
vereinfachungMitPrint (Alternative Phi a) = vereinfachungMitPrint a
vereinfachungMitPrint (Alternative a b) = if vereinfachungMitPrint(a) == vereinfachungMitPrint(b) then vereinfachungMitPrint a else (vereinfachungMitPrint a) ++ " + " ++ (vereinfachungMitPrint b) 
vereinfachungMitPrint (Sternbildung Phi) = "Eps"
vereinfachungMitPrint (Sternbildung Epsilon) = "Eps"
vereinfachungMitPrint (Sternbildung (Sternbildung a)) = vereinfachungMitPrint (Sternbildung a)
vereinfachungMitPrint (Sternbildung a) = (vereinfachungMitPrint a) ++ "*"

--Beispiel aus Folie eps ((a*)* (phi + b))
--let x = Konkatenation Epsilon (Konkatenation (Sternbildung (Sternbildung (C "a"))) (Alternative Phi (C "b")))

--Beispiele aus folien 
--let r3 = Alternative Phi (C "c")
--let r4 = Alternative (C "c") Phi
--let r5 = Sternbildung(Sternbildung(C "c"))
--let r6 = Sternbildung Phi
--let r7 = Alternative r3 r5


--Teil Transitionen erstellen






--Teil Ausführen


--variante hülle aller spontanten übergänge bilden
--Ausführen :: Automat String -> bool
--ergebnis = kucken ob es zu zustandsnummer aus automat transition mit passendem zeichen gibt für jede die es gibt rekursiv Ausführen aufrufen 
--paramter = zustandsnummer die nach der transition da ist + string verkürzt um das zeichen
--wenn ein aufruf den ganzen string abarbeitet und in einem endzustand ankommt true zurückgeben - falls es ein dead end gibt false -> true wandert durch







    