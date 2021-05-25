--Ausdruck/Expression
data Ausdruck = Epsilon | Phi | C Char | Alternative Ausdruck Ausdruck | Konkatenation Ausdruck Ausdruck| Sternbildung Ausdruck deriving (Show)

--Vereinfacht einen Regulären Ausdruck und gibt diesen Zurück
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

--Wandelt einen Regulären ausdruck in einen String zum Printen um
ausdruckPrinten :: Ausdruck -> String
ausdruckPrinten (Phi) = "Phi"
ausdruckPrinten (Epsilon) = "Eps"
ausdruckPrinten (C a) = a:[]
ausdruckPrinten (Konkatenation a b) = (ausdruckPrinten a) ++ " " ++ (ausdruckPrinten b)
ausdruckPrinten (Alternative a b) = (ausdruckPrinten a) ++ " + " ++ (ausdruckPrinten b) 
ausdruckPrinten (Sternbildung a) = (ausdruckPrinten a) ++ "*"

--Vereinfacht einen Regulären Ausdruck und wandelt ihn in einen String um
vereinfachungMitPrint :: Ausdruck -> String
vereinfachungMitPrint (Phi) = "Phi"
vereinfachungMitPrint (Epsilon) = "Eps"
vereinfachungMitPrint (C a) = a:[]
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

--Eine Transition besteht aus int von zustand mit zeichen nach int zustand 
--Zeichen kann auch leer sein
data Transition = Transition Int Char Int deriving (Show)
--Automat besteht aus Transitionen und einem Endzustand
data Automat = Automat [Transition] Int deriving (Show)



--brauch ich das überhaupt???? -> beim anlegen eines neuen automaten ist immer fest wie hoch die zustandsnummer ist  
--und beim zusammenfügen weis ich höchste nummer die ich bekommen hab + erhöhung = neue max zustandsnummer
--maxZustandsnummer :: Automat -> Int
--maxZustandsnummer (Automat[_ _ a]) = if a > 


--Wandelt Regulären Ausdruck in Automat um
automatErstellen :: Ausdruck -> Automat
automatErstellen (C a) = Automat [Transition 1 a 2] 2
automatErstellen (Sternbildung a) = automatenZusammenführenSternbildung (automatErstellen a)
automatErstellen (Konkatenation a b) = automatenZusammenführenKonkatenation (automatErstellen a) (automatErstellen b)
automatErstellen (Alternative a b) = automatenZusammenführenAlternative (automatErstellen a) (automatErstellen b)



--Führt drei Automaten Zusammen d.h.
{-
1 a 2
3 b 4
1 - 3
2 - 4
-} 
automatenZusammenführenAlternative  :: Automat -> Automat -> Automat 
automatenZusammenführenAlternative (Automat a b) (Automat c d) = Automat (transitionsliste ++ a ++ (listeVonTrippleErhöhen c (startZustandTeilB - 1))) endzustandTeilGesamt
    where   transitionsliste =  (Transition 1 '-' startZustandTeilB) : 
                                (Transition endzustandTeilA '-' endzustandTeilGesamt) : [] 
            endzustandTeilA = b
            startZustandTeilB = endzustandTeilA + 1
            endzustandTeilB = startZustandTeilB + d - 1
            endzustandTeilGesamt = endzustandTeilB



{-
1 a 2
2 b 3
start 1 ende 3
-}

automatenZusammenführenKonkatenation :: Automat -> Automat -> Automat                                   
automatenZusammenführenKonkatenation (Automat a b) (Automat c d) = Automat (a ++ (listeVonTrippleErhöhen c (startzustandTeilB - 1) )) endzustandTeilGesamt
    where   endzustandTeilGesamt = b + d - 1
            startzustandTeilB = b 






{-
Führt beliebige Transitionen in die einer Sternbildung ein
1 - 2 kann direkt eingetragen werden
2 a 3 -> wird durch den von unten kommenden automat der um 1 erhöht wird eingefügt
3 - 4 -> ist max+1 -> max+2 (max des übergebenen automaten)
1 - 4 -> 1 und max+2 des übergebenen automaten
4 - 2 -> max+2 des übergebenen automaten und 2
endzustand ist max+2
-}

automatenZusammenführenSternbildung:: Automat -> Automat 
automatenZusammenführenSternbildung (Automat a b) = Automat ((listeVonTrippleErhöhen a 1) ++ sternbildungsTransitionen ) (b+2)
    where   sternbildungsTransitionen = (Transition 1 '-' 2) :
                                        (Transition 1 '-' endzustandGesamt) :
                                        (Transition endzustandTeilA '-' 2 ) :         
                                        (Transition endzustandTeilA '-' endzustandGesamt ) : []                                       
            endzustandTeilA = b + 1                              
            endzustandGesamt = b + 2
        




--nimmt 2 Automaten und pack die transitionslisten in eine und nimmt den höheren zustand als endzustand
automatzusammenführen :: Automat -> Automat -> Automat
automatzusammenführen (Automat a b) (Automat c d) = Automat (a ++ c) (if b > d then b else d)



--erhöht alle zustandsnummern im Automat um int und gibt Automat zurück
zustandsnummernErhöhen :: Automat -> Int -> Automat
zustandsnummernErhöhen (Automat a b) d= Automat (listeVonTrippleErhöhen a d) (b+d)

--erhöht alle zustandsnummern in einem Tripple
listeVonTrippleErhöhen :: [Transition] -> Int -> [Transition]
listeVonTrippleErhöhen [] i = []
listeVonTrippleErhöhen (x:xs) i = (zustandsnummerInTrippleErhöhen x i): (listeVonTrippleErhöhen xs i)

--erhöht alle zahlen in einem Tripple aus int char int
zustandsnummerInTrippleErhöhen :: Transition -> Int -> Transition
zustandsnummerInTrippleErhöhen (Transition a b c) d = Transition (a+d) (b) (c+d)






--Teil Ausführen - Parameter Automat Startzustand Wort das Geprüft werden soll , gibt True/False zurück ob das Wort zum Automat/Ausdruck passt
ausführen :: Automat -> Int -> String -> Bool
ausführen (Automat a b) zustand [] =    if b == zustand 
                                        then True 
                                        else any (== True) (map helper gültigeTransitionen)
    where   gültigeTransitionen = filter (\(Transition x _ _) -> x == zustand) a      
            helper (Transition x y z) 
                | y == '-' = ausführen (Automat a b) z []
                | otherwise = False
ausführen (Automat a b) zustand (d:e) = any (== True) (map helper gültigeTransitionen)
    where   gültigeTransitionen = filter (\(Transition x _ _) -> x == zustand) a      
            helper (Transition x y z) 
                | y == '-' = ausführen (Automat a b) z (d:e)
                | y == d = ausführen (Automat a b) z e
                | otherwise = False
                




    