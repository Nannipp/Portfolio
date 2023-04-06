# Harjoitustyö-TTC2030 (c) Anni Orilähde AC8081/TTV22S5

Tämä repositorio on "Ohjelmoinnnin perusteet" -kurssin harjoitustyötä varten syksyllä 2022. Jyväskylän ammattikorkeakoulu.
Harjoitustyössä on tarkoitus näyttää oma osaaminen ja se mitä on kurssin aikana opittu.
Tein harjoitustyö ohjelman 'Ventti'-korttipelistä, josta löytyy päävalikosta pelin lisäksi pelin ohje ja tulostaulukko pelatuista peleistä.

Ohjelmakoodin ohessa Harjoitustyön rakennekaavio, joka on toteutettu MS Word ohjelmalla. Kaaviolla kuvastetaan ohjelmarakennetta.

# Ventti

Ventti pelin idea on saada nostettua kortteja, jotta kädessä olevien korttien summa on luku 21 tai sen alle.
Pelissä pelaaja pelaa Dealeria vastaan. Pelin voittaa se, jonka kädessä olevien summa on joko luku 21 tai jompikumpi on lähellä lukua 21.

# Aloitus

Ohjelman käynnistyksen edellytyksenä on, että tietokoneelle on asennettu Python 3.11 - ohjelma ja GitBash.
Lataa Python 3.11: https://www.python.org/downloads/
GitBash: https://gitforwindows.org/

Gitlabin sivulla haetaan Repositorio tietokoneelle painamalla oikealla yläkulmassa olevaa 'Fork' -painiketta. Tämä kopioi kansiorakennelman omaan käyttöösi. 'Clone' - painike kopioi repositoriosta käytettävän URL-linkin.

Avaa GitBash ja kirjoita seuraava komento: "git clone [URL-linkki]"
Repositorio kopioituu paikallisesti tietokoneellesi.

Avaa Komentokehoite kirjoittamalla työpöydän hakupalkkiin cmd.exe
Siirry kansiorakennelmaan seuraavalla komennolla: cd harjoitustyoe-ttc2030

Käynnistä ohjelma kirjoittamalla harjoitustyo.py ja valitse ohjelman käynnistämiseen Python -sovellus.

# Ohje

Päävalikosta voidaan aloittaa peli painamalla enter-näppäintä.
O - Näppäin tulostaa pelin ohjeet
T - Näppäin tulostaa pelatut pelit
E - Näppäin sulkee ohjelman

Pelaaja aloittaa pelin painamalla enteriä. Pelaajalle ja Dealerille jaetaan kummallekkin aluksi 2 korttia.
Jos kädessä olevien korttien summa on pienempi kuin luku 21, voidaan päättää nostetaanko kortti vai jäädäänkö siihen. 
1 - Näppäin lopettaa korttien nostamisen
2 - Näppäin nostaa uuden kortin

Pelin päättyessä tarkistetaan tulokset.

# Tärkeää

Ohjelma tallentaa ensimmäisen pelatun pelin jälkeen tiedoston "ventti_score.txt" tietokoneen kotihakemistoon.

Windowsissa: C:\Users\(käyttäjännimi)\
Mac: /home/(käyttäjänimi)/
Linux: /home/(käyttäjänimi)/