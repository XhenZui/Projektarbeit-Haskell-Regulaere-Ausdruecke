

--"Epsilon" der leere String
-- "Phi" die leere Sprache
-- das Zeichen c
-- Alternative zwischen r1 und r2
-- Verkettung/Konkatenation von r1 mit r2
-- Kleenesche Hülle, entweder leerer String oder beliebige Verkettung von r

--Ausdruck/Expression
data Ausdruck = Epsilon | Phi | C String | Alternative Ausdruck Ausdruck | Konkatenation Ausdruck Ausdruck| Sternbildung Ausdruck deriving (Show)

vereinfachung :: Ausdruck -> String
vereinfachung (Phi) = "Phi"
vereinfachung (Epsilon) = "Eps"
vereinfachung (C a) = a
vereinfachung (Konkatenation a Phi) = "Phi"
vereinfachung (Konkatenation Phi a) = "Phi"
vereinfachung (Konkatenation a Epsilon) = vereinfachung a
vereinfachung (Konkatenation Epsilon a) = vereinfachung a
vereinfachung (Konkatenation a b) = (vereinfachung a) ++ " " ++ (vereinfachung b)
vereinfachung (Alternative a Phi) = vereinfachung a
vereinfachung (Alternative Phi a) = vereinfachung a
vereinfachung (Alternative a b) = if vereinfachung(a) == vereinfachung(b) then vereinfachung a else (vereinfachung a) ++ " + " ++ (vereinfachung b) 
vereinfachung (Sternbildung Phi) = "Eps"
vereinfachung (Sternbildung Epsilon) = "Eps"
vereinfachung (Sternbildung (Sternbildung a)) = vereinfachung (Sternbildung a)
vereinfachung (Sternbildung a) = (vereinfachung a) ++ "*"

--Beispiel aus Folie eps ((a*)* (phi + b))
--let x = Konkatenation Epsilon (Konkatenation (Sternbildung (Sternbildung (C "a"))) (Alternative Phi (C "b")))


-- beispiel zum testen  Eps + "a" + (Phi | "b")
--main = do
    --let beispielAusdruck = Konkatenation Epsilon Konkatenation C "a" Alternative Phi C "b"
    --putStrLn vereinfachung beispielAusdruck

  --  let beispielAusdruck = Konkatenation (C "abcd") (C "efgh")
  --  vereinfachung beispielAusdruck


    