
--"Epsilon" der leere String
-- "Phi" die leere Sprache
-- das Zeichen c
-- Alternative zwischen r1 und r2
-- Verkettung/Konkatenation von r1 mit r2
-- Kleenesche Hülle, entweder leerer String oder beliebige Verkettung von r


annahme es werden nur bereits vereinfachte ausdrücke in automaten umgewandelt

Regulärer Ausdruck wird als "objekt" erstellt mit Konstruktoren angegeben 
aus Regulärem ausdruck wird automat mit transitionen erstellt
programm muss mit Transitionen ermitteln können ob string teil des regulären ausdrucks ist



## erstellen von transitionen
es gibt eigentlich nur 3 pattern 

# alternative
a + b
1 a 2 
1 b 2
start 1 ende 2

# konkatenation
a b
1 a 2
2 b 3
start 1 ende 3

# Sternbildung 
1 a 2
2 - 1
1 - 2
start 1 ende 2

-> um loops/fehler von spontanen übergängen zu vermeiden 
1 - 2
2 a 3
3 - 4
1 - 4
4 - 2



# erstellen von großen ausdrücken durch verschachteln -> aus a/b werden andere Transitionen

(a b)*

Sternbildung(konkatenation((C "a") (C "b")))

bsp abab

start 1 ende 5

1 - 2
2 a 3
3 b 4
4 - 5
5 - 2


vorgehen rekursiv in ausdruck reingehen bis man auf ein C stößt unten angekommen
je nach ausdruck 




# datentyp transition step 1 funktion erstellt datenstruktur im nachfolgenden muster
---->>> kann man sich warscheinlich schenken und stattdessen direkt die Regulärer Ausdruck datenstruktur verwenden

Transition = Transition[Int,Transition,Int] | Transition[Int,Char,Int]

Sternbildung(Konkatenation (C "a") (C "b"))


Sternbildung 1
    + transition 1 - 2
    + transition 1 Konkatenation 2
    + transition 2 - 1

        Konkatenation
        + transition 1 a 2
        + transition 2 b 3

bsp mit alternative

a + b*

Alternative
    + transition 1 a 2
    + transition 1 alt 2




# umwandlung in step 2 -> lokale nach globale nummern umwandeln
Transitionstep2 = Transition [int,char,int] Int  ->> aktuelle endzustandsnummer + startzustandsnummer braucht nicht mitgegeben werden ist immer 1

funktion parameter Transitionsliste rückgabe Transitionsliste
rückgabe ist immer transitionsliste die nichtmehr verschachtelt ist

überspringe step 1,2,3 falls übergeben transitionsliste nicht verschachtelt ist

    Step 1 führe funktion für erste untertransitionsliste aus (entfällt falls linker teil bereits nicht mehr verschachtelt ist)
        rückgabe ist nicht verschachtelte liste
        

    Step 2 führe funktion für zweite untertransitionsliste aus (entfällt falls es sternbildung ist, oder falls rechter teil nicht mehr verschachtelt ist) 
        rückgabe ist nicht verschachtelte liste

    Step 3 
        führe die zustandsnummern der 2 listen die aus step 1 und 2 zurückkamen zusammen mit denen aus dieser transition aka nummern anpassen
            -> ist abhängig davon in was für einer eigenen transition man drin ist
                -> evtl sinnvoll in erster struktur info mitzugeben in was für einem ausdrucksteil man grade ist zb.



    Step 4 gebe nicht verschachtelte transitionsliste zurück


# komplexeres beispiel

(a b)* (c d)*

Konkatenation((Sternbildung(Konkatenation (C "a") (C "b")))(Sternbildung(Konkatenation (C "c") (C "d"))) )


Konkatenation 
+ transition 1 Sternbildung-1 2
+ transition 2 Sternbildung-2 3

    Sternbildung 1
    + transition 1 - 2
    + transition 1 Konkatenation-1 2

        Konkatenation 1
        + transition 1 a 2
        + transition 2 b 3

    Sternbildung 2
    + transition 1 - 2
    + transition 1 Konkatenation-2 2

        Konkatenation 2
        + transition 1 c 2
        + transition 2 d 3


# beispielsachen zum Testen

Konkatenation (C 'a') (C 'b')
müsste geben 
1a2
2b3

Sternbildung(Konkatenation (C 'a') (C 'b'))

müsste geben 
1-2
2a3
3b4
4-5
4-

# Beispiel (ab)*
let a = Sternbildung(Konkatenation (C 'a') (C 'b'))
let b = regulärerAusdruckUmwandeln a
let c = ausführen b 1 "ab"


# Beispiel 2  (a(a|b)*b) | (b(a|b)*a)
let a = Alternative(Konkatenation (C 'a') (Konkatenation (Sternbildung (Alternative (C 'a')(C 'b'))) (C 'b')))(Konkatenation (C 'b') (Konkatenation (Sternbildung (Alternative (C 'a')(C 'b'))) (C 'a')))
let b = regulärerAusdruckUmwandeln a
let c = ausführen b 1 "ab"

# Beispiel 3 (a(a|b)*b)
let a = Konkatenation (C 'a') (Konkatenation (Sternbildung (Alternative (C 'a')(C 'b'))) (C 'b'))
let b = regulärerAusdruckUmwandeln a
let c = ausführen b 1 "ab"

# Beispiel 4 (a|b)*b
let a = Konkatenation (Sternbildung (Alternative (C 'a')(C 'b'))) (C 'b')
let b = regulärerAusdruckUmwandeln a
let c = ausführen b 1 "ab"

# Beispiel 4 (a|b)*
let a = Sternbildung (Alternative (C 'a')(C 'b'))
let b = regulärerAusdruckUmwandeln a
let c = ausführen b 1 "ab"