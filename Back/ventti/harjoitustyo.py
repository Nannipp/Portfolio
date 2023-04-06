# (c) Anni Orilähde, Opiskelijatunnus: AC8081, TTV22S5
# Tämä työ on tehty harjoitukseksi kurssille Ohjelmoinnin perusteet TTC2030-3032
#
# Tavoitteena on osoittaa hallitsevansa riittävästi ja kattavasti opintojakson asiat
# sekä osoittaa kykenevänsä kirjoittamaan siistiä, johdonmukaista koodia.(Moodle, 2022)
#
##########################################################################
# Hakemistot
import os
import os.path
import random
import sys
import time
from datetime import datetime
from time import sleep

# Pakka / Käsikortit
pakka = [2,3,4,5,6,7,8,9,10,'A','J','Q','K',
        2,3,4,5,6,7,8,9,10,'A','J','Q','K',
        2,3,4,5,6,7,8,9,10,'A','J','Q','K',
        2,3,4,5,6,7,8,9,10,'A','J','Q','K']
pelaajaKasi = []
dealerKasi = []
peliPakka = pakka.copy()
viimeinenkortti = []

# Muuttujat, jossa haetaan käyttäjän kotihakemisto, alustetaan tuloksille oma tekstitiedosto ja luodaan polku
polku = os.path.expanduser("~")
tiedosto = "ventti_score.txt"
tiedosto2 = polku + "/" + tiedosto

# Pelin tarkastus, kun korttien nosto päätetään tai pelaajan/dealerin käsi summa ylittää 21
def checkResult(pelaajaKasi, dealerKasi):
    if total(pelaajaKasi) == 21:
            print("Ventti! Pelaaja voitti.")
    elif total(dealerKasi) == 21:
            print("Ventti! Dealer voitti.")
    elif total(dealerKasi) > 21 and total(pelaajaKasi) > 21:
            print("Ventti ylitetty! Molemmat hävisi.")
    elif total(pelaajaKasi) > 21:
            print("Hävisit! Dealer voitti.")
    elif total(dealerKasi) > 21:
            print("Dealer hävisi! Voitit pelin.")
    elif 21 - total(dealerKasi) < 21 - total(pelaajaKasi):
            print("Hävisit! Dealer voitti.")
    elif 21 - total(dealerKasi) > 21 - total(pelaajaKasi):
            print("Dealer hävisi! Voitit pelin.")
    elif total(dealerKasi) == total(pelaajaKasi):
            print("Tasapeli!")

# Tekstin tulostus visuaalisesti, aliohjelma looppaa kirjoitetun tekstin ja teksi tulostuu sekunnin 10 osan nopeudella
def delprint(text):
    for kirjain in text:
        sys.stdout.write(kirjain)
        sys.stdout.flush()
        time.sleep(1./10)

# Korttien jako, valitsee alustetun pakan kopiosta satunnaisesti kortin, 
# jonka muuttuja tallennetaan sen vuorossa olevalle muuttujalle, lopuksi kortti poistuu pakasta
def dealCard(vuoro):
    kortti = random.choice(peliPakka)
    vuoro.append(kortti)
    peliPakka.remove(kortti)

# Korttien summa, aliohjelma muuttaa kortin arvon vastaamaan lukua, 
# koska ohjelma ei ymmärrä esim. K = 13 jne. Lopuksi palautetaan arvo
# Ohjelma tarkistaa lopuksi, että korttien yhteissumma pysyy alle 21
def total(vuoro):
    total = 0
    for kortti in vuoro:
        if kortti in range(1,11):
            total += kortti
        elif kortti in ['J']:
            total += 11
        elif kortti in ['Q']:
            total += 12
        elif kortti in ['K']:
            total += 13
        else:
            total += 14
    return total
    
# Pelin tulokset tallennetaan tiedostoon, joka tallentuu sisäisesti käyttäjän kotihakemistoon, on myöhemmin luettavissa
# Pelitä tuodaan muuttujilla pelaajan ja dealerin kortit, ja haetaan sen hetkinen ajankohta, kun peli on ratkaistu
def kirjoitapisteet(deal, player):
    d = deal
    p = player
    date = datetime.now()
    dt_string = date.strftime("%d/%m/%Y %H:%M:%S")
    if not os.path.exists(polku):
        os.makedirs(polku)
    try:
        pistetaulukko = open(tiedosto2, "a")
        pistetaulukko.write(f"Peliaika: {dt_string}\nKätesi: {str(p)}\nDealer: {str(d)}\n")
        pistetaulukko.close()
    except:
        print("Tuloksia ei voitu tallentaa!")

# Luetaan pelin tulokset päävalikon kautta, jos tiedosto on olemassa, tiedostosta luku onnistuu
def luepisteet():
    try:
        pistetaulukko = open(tiedosto2, "r")
        for rivi in pistetaulukko:
            print(rivi)
    except:
        print("Pistetaulukko on tyhjä")
        time.sleep(5)

##########################################################################
# Pääohjelma/Peli
os.system('cls')
delprint("Pelattaan Venttiä!\n")
sleep(1)

while(True):
    pelaajainput = input("Paina enter aloittaaksesi pelin.\n'O' painamalla pääset pelin ohjeisiin.\n'T' avaa pistetaulukon.\n'E' poistuu ohjelmasta.\n")
    os.system('cls')

    # Peli alkaa tyhjästä syötteestä
    if pelaajainput == "":
        delprint("Aloitetaan peli...\n")
        sleep(2)

        # Aina uuden pelin alkaessa nollataan muuttujien alkuperäiset asetukset. 
        # Puhdistetaan pelaajan ja dealerin käsi, jotta edellisen pelin kortit eivät kummittele
        # Kopioidaan uusi korttilista, jotta kortit eivät lopu kesken. Testasin ilman uutta listaa ja korttien loppuessa ohjelma kaatui.
        playerIn = True
        dealerIn = True
        dealerKasi.clear()
        pelaajaKasi.clear()
        viimeinenkortti.clear()
        peliPakka = pakka.copy()

        # Jaetaan 2 korttia kummallekkin pelaajalle
        for _ in range(2):
            dealCard(dealerKasi)
            dealCard(pelaajaKasi)

        # Peliloop
        while playerIn or dealerIn:
            # Kun listaan tallennetaan, se tallentuu puhdistettuun muuttujaan ja numeriset (int) muuttujat pitää muuttaa str muotoon
            kasiClear = " ".join(str(v) for v in pelaajaKasi)
            dealClear = " ".join(str(v) for v in dealerKasi)
            os.system('cls')
            # Kerrotaan pelaajalle montako korttia dealer pitää tällä hetkellä
            print(f"Dealerillä on {len(dealerKasi)} korttia")
            sleep(2)
            print(f"Sinulla on {kasiClear}, yhteensä {total(pelaajaKasi)}")
            sleep(2)
            
            # Aliohjelmalla tarkistetaan, että kädessä olevat kortit pysyvät alle 21
            if total(pelaajaKasi) >= 21:
                break
            elif total(dealerKasi) >= 21:
                break

            # Jos korttien summa on alle 21, saa pelaaja päättää nostaako seuraavan kortin
            if playerIn:
                lopetaNosta = input("1: Lopeta nosto\n2: Nosta kortti\n")
                if lopetaNosta == '1':
                    playerIn = False
                    # Lisätty ominaisuus: Näytetään, mikä "seuraava" nosto olisi ollut
                    os.system('cls')
                    dealCard(viimeinenkortti)
                    print(f"Seuraava kortti olisi ollut: {viimeinenkortti[-1]}")
                else:
                    dealCard(pelaajaKasi)

            # Tarkistetaan samoin dealerin korttien summa, jos summa on alle 21 ohjelma nostaa uuden kortin
            if total(dealerKasi) > 16:
                dealerIn = False
            else:
                dealCard(dealerKasi)

        # Tulosten tarkistus
        checkResult(pelaajaKasi, dealerKasi)
        # Lopuksi paljastetaan käsi ja tallennetaan tulos aliohjelman kautta tiedostoon
        kirjoitapisteet(dealClear, kasiClear)
        print(f"Kätesi: {kasiClear} = {total(pelaajaKasi)}\nDealer: {dealClear} = {total(dealerKasi)}")
        sleep(2)
        delprint("Paina enter palattaksesi takaisin valikkoon")
        input()
        os.system('cls')
        delprint("Palataan päävalikkoon...")
        sleep(2)
        os.system('cls')

    # Ohjelma päättyy jos pelaaja painaa päävalikossa 'e' = "exit" 
    elif pelaajainput == "e":
        break

    # Ohjelma tulostaa käyttäjälle pelin ohjeet, kun painetaan 'o' -päävalikossa
    elif pelaajainput == "o":
        print("Ventti on korttipeli, jota pelataan jakajaa vastaan. \nPelaaja ja Dealer ottavat kortteja yksitellen ja yrittävät saada mahdollisimman suuren tuloksen menemättä yli pisteluvun 21 eli ventin.\nPistemäärän 21 ylittänyt pelaaja häviää heti. Jos jompikumpi saa 21 suoraan, voittaa hän pelin.\n")
        time.sleep(2)
        delprint("Paina enter palattaksesi takaisin valikkoon")
        input()
        os.system('cls')

    # Ohjelma tulostaa tulokset käyttäjälle aliohjelman avulla, kun painetaan 't' -päävalikossa
    elif pelaajainput == "t":
        luepisteet()
        time.sleep(2)
        delprint("Paina enter palattaksesi takaisin valikkoon")
        input()
        os.system('cls')

    # Pohjalle päädytään, jos syöte on ihan mitä sattuu
    else:
        os.system('cls')
        continue

# Hyvästelyt  
delprint("Suljetaan peli...")