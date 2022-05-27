GameShell: un "gioco" per insegnare il terminale Unix
===========================================

![Illustration inspired by the game](art/illustration-small.png)

Insegnare a studenti universatari o delle superiori a usare un terminale Unix non é la cosa piú semplice o divertente. Gameshell é stato creato come strumento per aiutare gli studenti alla [Université Savoie Mont Blanc](https://univ-smb.fr)  per fare pratica con un terminale *reale* per imparare divertendosi.

L'idea originale, di  Rodolphe Lepigre, era di avere una sessione bash standard con una configurazione specifica via file definiti "missioni" che potevano essere "verificate" tramite i progressi nel gioco.

Ecco i risultati...

Sentiti libero di inviare i tuoi commenti, domande o suggerimenti aprendo dei [ticket](https://github.com/phyver/GameShell/issues) o inviando [pull request](https://github.com/phyver/GameShell/pulls).
Siamo particolarmente interessati nel creare nuove missioni!


Come cominciare
---------------

**Nota:** GameShell é attualmente sotto uno sviluppo pesante: la versione corrente non é stata testata dagli studenti. Non esitare a segnalare qualunque problema che potresti incontrare o suggerimenti che potresti avere [aprendo un ticket](https://github.com/phyver/GameShell/issues/new).

GameShell dovrebbe funzionare in qualunque sistema Linux standard, e anche su macOS e BSD (ma abbiamo eseguito pochi test su questi). Su Debian e Ubuntu, le uniche dipendenze (oltre `bash`) sono i pacchetti `gettext-base` e `awk`(questo di solito presente di default). Alcune missioni hanno dipendenze addizionali: queste missioni sono saltate se le dipendenze non sono state risolte.  
Su Debian o Ubuntu, esegui i comandi seguenti per installare tutte le dipendenze del gioco e delle missioni.  
```sh
$ sudo apt install gettext man-db procps psmisc nano tree bsdmainutils x11-apps wget
```
Verifica il [manuale utente](doc/user_manual.md) per vedere come installare le dipendenze su altri sistemi (macOS, BSD, ...).

Se tutte le dipendenze sono installate, puoi provare l'ultima versione del gioco eseguendo questi due comandi in un terminale.  
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```
Il primo commando scaricare l'ultima versione del gioco nella forma di un pacchetto che si auto estrarrá e il secondo commando avvierá e inizializzerá il gioco dall'archivio. Istrunzioni su come giocare sono fornite nel gioco direttamente. 

Nota che quando si esce dal gioco (con `control-d` o il commando `gsh exit`) i tuoi progressi saranno salvati in un nuovo archivio (chiamato `GameShell-save.sh`).  
Esegui questo script per ritornare al gioco nel punto in cui lo hai lasciato.


Se preferisci non eseguire script shell estranei sul tuo computer puoi generare una immagine Docker con i comandi seguenti: 
```sh
$ mkdir GameShell; cd GameShell
$ wget --quiet https://github.com/phyver/GameShell/releases/download/latest/Dockerfile
$ docker build -t gsh .
$ docker run -it gsh
```
Il gioco NON verrá salvato quando esci e paramentri aggiuntivi sono necessari se vuoi eseguire X programmi da GameShell.  Approfondisci le differenze su [questa seaione](./doc/deps.md#running-GameShell-from-a-docker-container) del manuale utente.


Documentazione
-------------

Per trovare altre informazioni su GameShell, guarda questi documenti:
- Il [manuale utente](doc/user_manual.md) fornisce informazioni aggiuntive su come lanciare il gioco su tutti i sistemi supportati (Linux, macOS, BSD), spiega come eseguire il gioco dai sorgenti, come creare degli archivi personalizzati (utili se vuoi delle versioni del gioco per fare formazioni in classe) e altro.
- Il [manuale di sviluppo](doc/dev_manual.md) fornisce informazioni su come creare nuove missioni, tradurre le missioni e come partecipare allo sviluppo del gioco. 


Chi sta sviluppando GameShell?
----------------------------

### Sviluppatori

Il gioco é sviluppato da:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (main developer,
  [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Mission contributors

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Ringraziamenti speciali

* AA tutti gli studenti che hanno trovato *molti* bug nelle prime versioni.
* Joan Stark (a.k.a, jgs), che ha disegnati centinaia di ASCII-art negli anni 90s. Molte delle ASCII-art in GameShell sono sue.


Licence
-------

GameShell is released under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Please link to this repository if you use GameShell.

GameShell is open source and free to use. One way you can acknowledge the work
it required is by sending an actual postcard to

```
  Pierre Hyvernat
  Laboratoire de Mathématiques, CNRS UMR 5127
  Université de Savoie
  73376 Le Bourget du Lac
  FRANCE
```

