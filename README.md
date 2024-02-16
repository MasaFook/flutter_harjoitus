# Mobiilisovelluskehitys
**Matti Koskinen, Sami Rautalahti, Henri Hämäläinen**

Harjoitustyönä tehty yksinkertainen sovellus, jossa on erilaisia toiminnallisuuksia. Toiminnallisuudet ovat muistilaput, kamera ja shaker. Sovellus hyödyntää Firebasea kirjautumiseen ja käyttäjien tunnistamiseen.

## Main_view näkymä – Matti Koskinen
Main_view on käyttöliittymän perusnäkymä, kun käyttäjä on kirjautunut sisään. Sieltä käyttäjä pystyy navigoimaan kolmen eri sovelluksen ja oman profiilin välillä.
### Käytetyt paketit:
-	**camera**: Plugin kameran käyttöön. käytetään camera sovellukseen siirtymisessä, kun etsitään kamera valmiiksi.
-	**flutter/material**: Flutterin materiaalipaketti.
Visuaalinen toteutus on omaa käsialaa, vinkkejä etsin netistä asetteluun. Henri Hämäläinen oli loppuviimeistelyssä mukana ideoimassa ratkaisuja.

## Muistilappu-näkymä (tehnyt Sami Rautalahti)
Muistilappu-sovellus on muistiinpanosovellus, joka tarjoaa tavan luoda, tallentaa, hallita ja jakaa muistiinpanoja. Sovellus käyttää Firebase Authenticationia ja Cloud Firestorea käyttäjien autentikointiin ja muistilappujen tallentamiseen tietokantaan.
Kirjautunut käyttäjä voi tehdä uusia muistilappuja. Käyttäjän sähköpostiosoitteen alkuosasta muodostuu käyttäjätunnus, joka näkyy kussakin muistilapussa “tekijä:”-kohdassa.  Kukin käyttäjä voi muokata, poistaa tai jakaa eteenpäin (tapahtuu share-toiminnolla, joka avaa valikon eri tavoista, joilla viesti voidaan jakaa käytetyn laitteen sovellusten kautta) omia lappujaan. Muistilapun muokkaaminen, poistaminen tai jakaminen perustuu Firestore-tietokannassa määrättyihin sääntöihin. Laput näkyvät pastellivärisissä korteissa listana allekkain, joten ne erottuvat helposti ja ovat selkeä lukea sekä selata.
### Sovelluksen käytetyt paketit ja palvelut:
-	**flutter/material.dart**: Flutterin materiaalipaketti.
-	**cloud_firestore**: Firebase Cloud Firestore -tuki.
-	**firebase_auth**: Firebase Authentication -tuki.
-	**share_plus**: Share Plus -paketin käyttö muistilappujen jakamiseen.
### Mitä paketteja ja palveluita käytetään?
-	Käytetään **Firebase Authenticationia** käyttäjien tunnistamiseen.
-	Käytetään **Firebase Cloud Firestorea** muistiinpanojen tallentamiseen.

### Mitä puhelimen ominaisuuksia käytetään?
-	Käyttäjä voi kirjautua sisään ja käyttää sovellusta omilla tunnistetiedoillaan.
### Mitä näkymiä sovelluksessa on?
-	Kirjautumisnäkymä, kun mobiililaite käynnistetään. Muistilappu-sovellus käynnistetään myöhemmin, mutta kirjautumisnäkymä on oleellinen, koska siinä tunnistetaan käyttäjä, jonka perusteella muistilaput tallennetaan tietokantaan.
-	Pääsivu, jossa käyttäjä voi selata, lisätä, muokata, poistaa ja jakaa muistiinpanoja.

Sovellus ei perustu valmiiseen koodiin, vaan tutkin tutoriaaleja sekä tunnilla tehtyä harjoitusta, jonka pohjalta lähdin laatimaan omaa sovelluskoodia.
Tutkin tutoriaaleja ja muita vastaavia toteutuksia, joista lähdin pikkuhiljaa kokeilemaan ja soveltamaan muutoksia. Virheitä tai ongelmatilanteita kun ilmeni, niin silloin Visual Studio Code auttoi paljon, mutta joissain tilanteissa minun piti tutkia tutoriaaleja ja esimerkiksi Stack Overflow-sivustoa, josta löytyi paljon apuja tilanteeseen kuin tilanteeseen. Muutaman virheilmoituksen ratkaisin tekoälyn avulla ja noissa tilanteissa piti myös testata vaihtoehtoisia tapoja toteuttaa sama ratkaisu. 

Kun lähdin suunnittelemaan tätä sovellusta, päätin että parempi tehdä siitä mahdollisimman kompakti ja tehokas. Siinä on tarvittavat perustoiminnot, kuten käyttäjien autentikointi, muistiinpanojen lisääminen, muokkaaminen ja poistaminen. Koen sovelluksen yksinkertaisuuden olevan tässä tilanteessa vahvuus, etenkin kun se tarjoaa perusmuistiinpano-toiminnallisuuden. Jatkokehityksessä sovellukseen voi toteuttaa lisätoimintoja.

## Camera – Matti Koskinen
Sovellus on yksinkertainen kamera, sillä voi ottaa kuvan ja tallentaa puhelimen muistiin.
käyttäjä avaa sovelluksen, joka kysyy ensikerralla luvan kameran käyttöön, jonka jälkeen sovellus aukaisee kameran. Tämän jälkeen käyttäjällä on mahdollista ottaa kuva. Kun kuva on otettu, kysyy sovellus lupaa tallentamiseen. Käyttäjä jos antaa luvan tallentuu kuva puhelimen muistiin.

### Käytetyt paketit:
-	**dart.io**: Dart-kielen kirjasto I/O-toimintoihin.
-	**flutter/material**: Flutterin materiaalipaketti.
-	**camera**: Plugin laitteen kameran käyttöön.
-	**permission_handler**: Plugin lupien kyselyyn.
-	**image_gallery_saver**: Plugin kuvien tallentamiseen laitteen galleriaan.
-	**device_info_plus**: Plugin laitteen tietoja varten, käytössä SDK tarkistuksessa.
### Puhelimen ominaisuudet:
-	**kamera**
-	**tallennustila**

Sovellus pohjautuu aika pitkälti flutterin kamera tutoriaalin ”take a picture using the camera” https://docs.flutter.dev/cookbook/plugins/picture-using-camera.
Jouduin kuitenkin tekemään joitain muutoksia kameran etsintään. Muokkasin myös tutoriaalin koodia, jotta sovelluksessa on mahdollisuus tallentaa ja myös tarvittaviin lupien kyselyihin. Vinkkejä näihin etsin netistä. Tekoälyä hyödynsin visuaalisuudessa.

## Shaker – Henri Hämäläinen
Näkymän ideana on vaihtaa taustaväriä hyödyntämällä puhelimen liiketunnistinta. Käyttäjä avaa Shaker-näkymän ja heiluttaa puhelinta, jolloin taustaväri muuttuu. Väri määräytyy Material colorsin primaries-muuttujan mukaan, johon on määritetty perusvärit (pois lukien harmaa).
### Käytety paketit:
-	**material.dart**: Materiaalipaketti
-	**shake.dart**: Havaitsee puhelimen liikkeen
-	**sensors_plus**: Puhelimen antureiden hyödyntäminen (kiihtyvyysanturi, gyroskooppi, magnetometri)
-	**dart:math**: Paketti sisältää matemaattisia muuttujua, mm. satunnaislukugeneraattorin, jota hyödynnetään satunnaisen värin valitsemisessa

Näkymän toteutukseen käytetty apuna Flutterin dokumentaatiota, Stack Overflowta ja Youtube-videota, jossa kerrottiin, kuinka hyödynnetään dart:math-kirjaston satunnaislukugeneraattoria värien generoinnissa. Tekoälyä hyödynnetty vain, jos koodissa ilmeni toiminnallisuuden kanssa ongelmia.





<!-- # Harkka-appi

Mobiilisovelluskehitys-kurssin harjoitustyö

Harjoitustyössä luotu yksinkertainen sovellus, johon on hyödynnetty Firebasen kirjautumista.
Kirjautumissivulla voi luoda käyttäjätunnuksen ja salasanan.

Sovelluksesta löytyy:

## Muistilaput
  - Käyttäjä voi lisätä muistilappuja, jotka tallentuvat Firebasen tietokantaan. Käyttäjä voi myös muokata, poistaa ja jakaa muistilappuja eteenpäin.

## Kamera
  //- Yksinkertainen kamera, jolla voi tallentaa kuvan paikallisesti laitteelle.
    
## Shaker
  - Näkymä, jonka taustaväri vaihtuu, kun käyttäjä heiluttaa laitetta -->
