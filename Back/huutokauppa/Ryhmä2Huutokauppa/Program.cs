using System;
using System.Collections.Generic;
using System.Linq;
namespace Meklaritehtävä
//Ryhmätyö Anni Orilähde, Lauri Kankkonen & Sami Vilenius
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.WriteLine("Tervetuloa huutokauppaohjelmaan!");
            Console.WriteLine("");
            Console.WriteLine("----------------------------------------------------");
            Console.WriteLine("Syötä huutokaupan tavoitesumma ja paina enter");
            int tavoiteSumma = 0;
            tavoiteSumma += syoteTarkistus(tavoiteSumma);
            Console.WriteLine("----------------------------------------------------");
            Console.WriteLine("");

            //Alustetaan muuttujia
            int summa = 0; //Tallennetaan huudettujen artikkeleiden yhteenlaskettu summa
            List<int> tuoteHinnasto = new List<int>(99);
            int lukuTeksti = 0;
            int tuotehinta = 0;
            int edellinenHinta = 0;
            int jaljellaSumma = 0;
            List<string> tuotelista = new List<string>(99);
            string tuote;
            string syote = "";

            while (syote != "stop") //pitää testata jos tuon kirjoittaa kesken huudon, mitä tapahtuu
            {

                for (int i = 0; i < 99; i++) //ARTIKKELILOOP
                {

                    Console.Write("Artikkeli {0}. ", i + 1);
                    Console.Write("Syötä huudettavan artikkelin nimi: ");
                    tuote = Console.ReadLine();
                    tuotelista.Add(tuote);

                    for (int j = 0; j < 99; j++)//HINTA LOOP
                    {
                        Console.WriteLine("");
                        Console.WriteLine("Anna artikkelin hinta (Huom! Jos huutoja ei tule enempää, syötä 'x') : ");
                        Console.Write(">");
                        //Console.WriteLine(edellinenHinta); testirivi osa 5
                        syote = Console.ReadLine();//syotteen tarkistus

                        if (syote == "x")
                        {
                            tuoteHinnasto.Add(tuotehinta);
                            summa = summa + tuotehinta; // summa += tuotehinta
                            int edellinen = 0;
                            Console.WriteLine("");
                            Console.WriteLine("Artikkeli myyty!");
                            Console.WriteLine("Artikkeleita on huudettu tähän mennessä {0} kappale(tta)", tuotelista.Count);
                            Console.WriteLine("Artikkelin hinnaksi tuli {0} €", tuotehinta);
                            if (tuoteHinnasto.Count > 1)
                            {
                                edellinen = tuoteHinnasto[tuoteHinnasto.Count - 2]; //Hakee edellisen tuotteen.
                                //Console.WriteLine(edellinen); Testirivi osa 500
                            }
                            int maxi = tuoteHinnasto.Max(); // Hakee kalleimman tuotteen.
                            if (edellinen > tuotehinta)
                            {
                                Console.WriteLine("--------------------------------------------------------------------------");
                                Console.WriteLine("Nykyinen artikkeli myytiin pienemmällä hinnalla, kuin edellinen artikkeli!");
                            }
                            else if (edellinen < tuotehinta)
                            {
                                Console.WriteLine("--------------------------------------------------------------------------");
                                Console.WriteLine("Nykyinen artikkeli myytiin suuremmalla hinnalla, kuin edellinen artikkeli!");
                            }

                            Console.WriteLine("Korkeimman huudetun artikkelin hinta on: " + maxi + "€");
                            Console.WriteLine("");
                            if (summa < tavoiteSumma)
                            {
                                Console.WriteLine("Tavoitteen saavuttamiseksi pitäisi vielä tienata " + (jaljellaSumma = tavoiteSumma - summa) + " euroa");
                            }
                            else if (summa >= tavoiteSumma)
                            {
                                Console.WriteLine("Myyntitavoite saavutettu!");
                            }

                            j = 99;
                            tuotehinta = 0;
                            edellinenHinta = 0;
                        }
                        else if (string.IsNullOrEmpty(syote) || !int.TryParse(syote, out lukuTeksti)) // || = joko tai, && = molemmat täsmää
                        {
                            Console.WriteLine("Yritä uudelleen!!!");
                            Console.WriteLine("");
                            Console.WriteLine("Artikkelin hinta tällä hetkellä on : {0}€", tuotehinta); //Testilauseke
                        }
                        else if (syote != "x")
                        {
                            tuotehinta = int.Parse(syote);
                            if (tuotehinta > edellinenHinta)
                            {
                                edellinenHinta = 0; // edellinen hinta on nollattava, jotta summa ei kasva liian suureksi ja voidaan seurata edellistä huutoa
                                Console.WriteLine("");
                                Console.WriteLine("Hinta tallennettu!");
                                Console.WriteLine("Artikkelin hinta tällä hetkellä on : {0}€", tuotehinta);
                                Console.WriteLine("");
                                edellinenHinta = edellinenHinta + tuotehinta; //Tallennetaan tuotehinta edellinen hinta -muuttujaan, jotta seuraavalla kierroksella ohjelma voi verrata edellistä numeroa uuteen hintaan.
                            }
                            else if (tuotehinta < edellinenHinta)
                            {
                                Console.WriteLine("Hinta ei voi olla pienempi kuin edellinen summa!!!");
                            }
                        }// if päättyy
                    }// j -loop loppuu
                    Boolean loop = true;
                    while (loop == true)
                    {
                        Console.WriteLine("Haluatko lisätä uuden artikkelin (Painamalla enter) vai lopettaa huutokaupan? (Kirjoittamalla 'stop')"); //SYÖTTEEN TARKISTUS
                        syote = Console.ReadLine();
                        if (syote == "stop")
                        {
                            int maxi = tuoteHinnasto.Max();
                            i = 100;
                            Console.WriteLine("------------------");
                            Console.WriteLine("HUUTOKAUPPA PÄÄTTYI!!!");
                            Console.WriteLine("");
                            Console.WriteLine("Seuraavat tuotteet myytiin: ");
                            Console.WriteLine("");

                            for (int k = 0; k < tuotelista.Count; k++) // Loopataan lista myydyistä tuotteista ja niiden hinnoista.
                            {
                                Console.WriteLine(" - " + tuotelista[k] + " " + tuoteHinnasto[k] + "€");
                            }
                            Console.WriteLine("");
                            Console.WriteLine("Korkeimman huudetun artikkelin hinta on: " + maxi + "€");
                            Console.WriteLine("");
                            loop = false;
                        }

                        else if (string.IsNullOrWhiteSpace(syote))
                        {
                            Console.WriteLine("Jatketaan huutokauppaa...");
                            loop = false;
                        }
                        else if (syote != "stop")
                        {
                            Console.WriteLine("Yritä uudelleen!!!");
                            Console.WriteLine("");
                        }

                    }
                }// i -loop loppuu
            }// while -loop loppuu
            //Tästä alkaa artikkeleiden ja hintojen ynnääminen
            Console.WriteLine("Tarkistetaan saavutettiinko myyntitavoite. (Paina enter)");
            Boolean loop3 = true;
            while (loop3 == true)
            {
                string tulosTarkistus = Console.ReadLine();
                if (string.IsNullOrWhiteSpace(tulosTarkistus))
                {
                    tulos(tavoiteSumma, summa);

                    Console.WriteLine("");
                    Console.WriteLine("Paina mitä tahansa näppäintä lopettaaksesi");
                    loop3 = false;
                }
                else
                {
                    Console.WriteLine("Paina enteriä :)");
                }

            }
            Console.ReadKey();
        }//Pääohjelma päättyy
        static void tulos(int tavoiteSumma, int summa)//Aliohjelma, joka tarkistaa huutokaupan lopputuloksen
        {
            Console.WriteLine("Myyntiä tuli yhteensä: " + summa + " euroa.");


            if (tavoiteSumma > summa)//Tavoite ei täyttyny
            {
                Console.WriteLine("Harmi, tavoite ei täyttynyt, jäätiin vajaaksi " + (tavoiteSumma - summa + " euroa"));
            }
            else if (tavoiteSumma <= summa)//Tavoite täyttyy
            {
                Console.WriteLine("JES, TAVOITE TÄYTTYI!! Voittoa tuli " + (summa - tavoiteSumma + " euroa"));
            }
            return;
        }//Aliohjelma päättyy
        static int syoteTarkistus(int tavoiteSumma)
        {
            Boolean loop = true;
            while (loop == true)
            {
                string rivi = Console.ReadLine();
                if (int.TryParse(rivi, out tavoiteSumma))
                {
                    tavoiteSumma = int.Parse(rivi);
                    loop = false;
                }
                else if (!int.TryParse(rivi, out tavoiteSumma))
                {
                    Console.WriteLine("Yritä uudelleen!!!");
                    Console.WriteLine("");
                    Console.WriteLine("----------------------------------------------------");
                    Console.WriteLine("Syötä huutokaupan tavoitesumma ja paina enter");

                }
            }//while päättyy
            return tavoiteSumma;
        }//Aliohjelma päättyy
    }
}