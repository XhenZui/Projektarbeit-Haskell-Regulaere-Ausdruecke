--Ausdruck/Expression
data Ausdruck = Epsilon | Phi | C Char | Alternative Ausdruck Ausdruck | Konkatenation Ausdruck Ausdruck| Sternbildung Ausdruck deriving (Show)

--Teil 1 Vereinfachen

{- vereinfachung
Vereinfacht einen Regulären Ausdruck
Parameter:
Ausdruck - Ausdruck der Vereinfacht werden soll
Ausdruck - Rückgabe des vereinfachten Ausdrucks
-}
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

{- ausdruckPrinten
Wandelt einen Regulären ausdruck in einen String zum Printen um
Parameter:
Ausdruck - Ausdruck der geprinted werden soll
String - Rückgabe des erstellten Strings
-}
ausdruckPrinten :: Ausdruck -> String
ausdruckPrinten (Phi) = "Phi"
ausdruckPrinten (Epsilon) = "Eps"
ausdruckPrinten (C a) = a:[]
ausdruckPrinten (Konkatenation a b) = (ausdruckPrinten a) ++ " " ++ (ausdruckPrinten b)
ausdruckPrinten (Alternative a b) = (ausdruckPrinten a) ++ " + " ++ (ausdruckPrinten b) 
ausdruckPrinten (Sternbildung a) = "(" ++ (ausdruckPrinten a) ++ ")*"

{- vereinfachungMitPrint
Vereinfacht einen Regulären Ausdruck und wandelt ihn in einen String um
Parameter:
Ausdruck - Ausdruck der geprinted und vereinfacht werden soll
String - Rückgabe des erstellten Strings
-}
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

--Teil 2 Automat erstellen erstellen

--Eine Transition besteht aus int von zustand mit zeichen nach int zustand 
data Transition = Transition Int Char Int deriving (Show)
--Automat besteht aus Transitionen und einem Endzustand
data Automat = Automat [Transition] Int deriving (Show)

{- automatErstellen
Erstellt aus Regulärem Ausdruck einen Passenden Automaten
Parameter:
Ausdruck - Ausdruck der Umgewandelt werden soll
Automat - Rückgabe des erstellten Automaten
-}
automatErstellen :: Ausdruck -> Automat
automatErstellen (C zeichen) = Automat [Transition 1 zeichen 2] 2
automatErstellen (Sternbildung ausdruck) = sternbildung (automatErstellen ausdruck)       
{-sternbildung Transitionenen 1 - 2, 2 a 3, 3 - 4, 1 - 4, 4 - 2-}  
    where sternbildung (Automat transitionsListe endzustand) = Automat ((trippleListeErhöhen transitionsListe 1) ++ sternbildungsTransitionen ) (endzustand+2)
            where   sternbildungsTransitionen = (Transition 1 '-' 2) :
                                                (Transition 1 '-' endzustandGesamt) :
                                                (Transition endzustandTeilA '-' 2 ) :         
                                                (Transition endzustandTeilA '-' endzustandGesamt ) : []                                       
                    endzustandTeilA = endzustand + 1                              
                    endzustandGesamt = endzustand + 2                         
automatErstellen (Konkatenation ausdruckA ausdruckB) = konkatenation (automatErstellen ausdruckA) (automatErstellen ausdruckB)
{- alternative Transitionen 1 a 2,3 b 4, 1 - 3, 2 - 4-}
    where konkatenation (Automat transitionsListeA endzustandA) (Automat transitionsListeB endzustandB) = 
            Automat (transitionsListeA ++ (trippleListeErhöhen transitionsListeB (startzustandTeilB - 1) )) endzustandGesamt
            where   endzustandGesamt = endzustandA + endzustandB - 1
                    startzustandTeilB = endzustandA 
automatErstellen (Alternative ausdruckA ausdruckB) = alternative (automatErstellen ausdruckA) (automatErstellen ausdruckB)
{- konkatenation Transitionen 1 a 2, 2 b 3-}
    where alternative (Automat transitionsListeA endzustandA) (Automat transitionsListeB endzustandB) = 
            Automat (transitionsliste ++ transitionsListeA ++ (trippleListeErhöhen transitionsListeB (startZustandTeilB - 1))) endzustandGesamt
            where   transitionsliste =  (Transition 1 '-' startZustandTeilB) : 
                                        (Transition endzustandA '-' endzustandGesamt) : [] 
                    startZustandTeilB = endzustandA + 1
                    endzustandTeilB = startZustandTeilB + endzustandB - 1
                    endzustandGesamt = endzustandTeilB

-- Hilfsfunktionen

{- zustandsnummernErhöhen
erhöht alle zustandsnummern im Automat um int und gibt Automat zurück
Parameter:
Automat - Automat dessen Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
Automat - Rückgabe des Automaten
-}
zustandsnummernErhöhen :: Automat -> Int -> Automat
zustandsnummernErhöhen (Automat a b) d= Automat (trippleListeErhöhen a d) (b+d)

{- zustandsnummernErhöhen
erhöht alle zustandsnummern in einer Liste von Tripplen
Parameter:
[Transition] - Liste von Transitionen der Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
[Transition] - Rückgabe der Liste von Transitionen mti angepassten Zustandsnummern
-}
trippleListeErhöhen :: [Transition] -> Int -> [Transition]
trippleListeErhöhen [] i = []
trippleListeErhöhen (x:xs) i = (zustandsnummerInTrippleErhöhen x i): (trippleListeErhöhen xs i)


{- zustandsnummerInTrippleErhöhen
erhöht alle Zustandsnummern in einem Tripple
Parameter:
Transition - Transitionen deren Zustandsnummern erhöht werden sollen
Int - Zahl um wieviel die Zustandsnummern erhöht werden sollen
Transition - Rückgabe der Transitionen mit angepassten Zustandsnummern
-}
zustandsnummerInTrippleErhöhen :: Transition -> Int -> Transition
zustandsnummerInTrippleErhöhen (Transition a b c) d = Transition (a+d) (b) (c+d)

--Teil 3 Automat Ausführen 

{- ausführen
Führt Automat auf ein Wort aus um zu sehen ob dieses teil des Automaten ist
Parameter:
Automat - Automat der ausgeführt werden soll
Int - Startzustand in dem der Automat gestartet werden soll
String - Wort das geprüft werden soll
Bool - Rückgabe ob wort teil des Automaten war oder nicht
-}
ausführen :: Automat -> Int -> String -> Bool
ausführen (Automat transitionsListe endzustand) zustand [] =    if endzustand == zustand
                                                                then True 
                                                                else any (== True) (map rekursion gültigeTransitionen)
    where   gültigeTransitionen = filter (\(Transition x _ _) -> x == zustand) transitionsListe      
            rekursion (Transition _ zeichen zielZustand) 
                | zeichen == '-' = ausführen (Automat transitionsListe endzustand) zielZustand []
                | otherwise = False
ausführen (Automat transitionsListe endzustand) zustand (aktuellesZeichen:restString) = any (== True) (map rekursion gültigeTransitionen)
    where   gültigeTransitionen = filter (\(Transition x _ _) -> x == zustand) transitionsListe    
            rekursion (Transition _ zeichen zielZustand) 
                | zeichen == '-' = ausführen (Automat transitionsListe endzustand) zielZustand (aktuellesZeichen:restString)
                | zeichen == aktuellesZeichen = ausführen (Automat transitionsListe endzustand) zielZustand restString
                | otherwise = False
                



    