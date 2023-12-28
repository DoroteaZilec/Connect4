# Connect4
Domaća zadaća iz kolegija Multimedijski sustavi

Dorada igre (url na originalnu igru: https://github.com/lojelen/Four-in-a-Row) koju sam trebao napraviti za 7. domaću zadaću iz kolegija Multimedijski sustavi.
Kolege koje su radile na projektu su već ostavile puno dobrih komentara u vezi mogućih poboljšanja od kojih sam ja napravio jednu.
Ja bih rekao da bi sljedeći korak na radu ovog projekta trebao biti dodatno refaktoriranje koda tako da se koristi više klasa i principi OOP-a.
Tako refkatoriran kod bi olakšao svaku sljedeću doradu projekta. Od funkcionalnih zahtjeva bih predložio omogućavanje igranja igre između dva ljudska igrača.

Moje promjene:
Radila sam na projektu Four in a row (https://github.com/mhalavanja/Connect4).
Napravljeno:
•	Dodana je multiplayer opcija, pa igrač ima mogućnost odabira želi li igrati s računalom ili s još jednim igračem. Odabir je omogućen na glavnom izborniku, klikom na gumb One Player. Defaultno je postavljeno da se igra protiv računala, zato na početnom izborniku piše One Player, no klikom na taj gumb mijenja se način igre te na gumbu piše Two Players. Klikom na navedeni gumb omogućena je promjena načina igre.
o	Kako je bilo omogućeno igrati samo protiv računala, nisu bile napravljene slike potrebne za vraćanje informacije korisniku o pobjedniku, stoga su dodane i potrebne slike.
•	Omogućen je izlaz iz trenutne igre klikom na gumb Exit koji se nalazi u gornjem desnom kutu za vrijeme trajanja igre. Klikom na taj gumb, korisnik se vraća na početni izbornik, a igra se briše.
•	Ispisan je broj pobjeda svakog od igrača ako su igrali više partija neposredno jednu za drugom.
•	Dodana je mogućnost izbora boje diska s kojim trenutačni igrač igra. To je omogućeno odabirom na dropdown menu-u. 
•	Padanje žetona u rešetku popraćeno je odgovarajućim zvučnim efektom.
•	Pokušala sam implementirati timer kojim bi svaki od igrača imao neko određeno vrijeme da napravi svoj potez, no bez obzira što pokušala nisam uspjela vjerno prikazati preostalo vrijeme koje igrač ima za napraviti potez. Uspjela sam napraviti da nakon što istekne 30 sekundi drugi igrač ima pravo na potez, no to sam obrisala jer mi se nije svidjelo što nije nigdje pisalo preostalo vrijeme koje igrač ima za napraviti svoj potez. 
Daljnja poboljšanja:
•	Implementirati timer koji radi po gore navedenom principu.
•	Omogućiti veći odabir boja.
•	Dodati još raznih težina.
•	Omogućiti odabir veličine ploče na kojoj će se igrati.

