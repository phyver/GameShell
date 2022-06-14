GameShell: un "gioco" per insegnare il terminale Unix
===========================================

![Disegno ispirato dal gioco](art/illustration-small.png)

Insegnare a studenti universitari o delle superiori a usare un terminale Unix non é la cosa piú semplice o divertente. Gameshell è stato creato come strumento per aiutare gli studenti alla [Université Savoie Mont Blanc](https://univ-smb.fr) per fare pratica con un terminale *reale* e imparare divertendosi.

L'idea originale, di Rodolphe Lepigre, era di avere una sessione da terminale standard, con una configurazione specifica via file, definiti "missioni", che potessero essere "validati" tramite i progressi nel gioco.

Ecco i risultati...

Sentiti libero di inviare i tuoi commenti, domande o suggerimenti aprendo dei [ticket](https://github.com/phyver/GameShell/issues) o inviando [pull request](https://github.com/phyver/GameShell/pulls).
Siamo molto interessati nella creazione di nuove missioni!


Come cominciare
---------------

**Nota:** GameShell è attualmente sotto uno sviluppo pesante: la versione corrente non é stata testata dagli studenti. Non esitare a segnalare qualunque problema o suggerimento [aprendo un ticket](https://github.com/phyver/GameShell/issues/new).

GameShell dovrebbe funzionare in qualunque sistema Linux standard, e anche su macOS e BSD (ma abbiamo eseguito pochi test su questi). Su Debian e Ubuntu, le uniche dipendenze (oltre `bash`) sono i pacchetti `gettext-base` e `awk`(questo di solito presente di default). Alcune missioni hanno dipendenze addizionali: queste missioni verranno saltate se le dipendenze non sono state risolte.
Su Debian o Ubuntu, esegui i comandi seguenti per installare tutte le dipendenze del gioco e delle missioni.  
```sh
$ sudo apt install gettext man-db procps psmisc nano tree bsdmainutils x11-apps wget
```
Controlla il [manuale utente](doc/user_manual.md) per vedere come installare le dipendenze su altri sistemi (macOS, BSD, ...).

Se tutte le dipendenze sono installate, puoi provare l'ultima versione del gioco eseguendo questi due comandi in un terminale.  
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```
Il primo comando scarica l'ultima versione del gioco nella forma di un pacchetto che si auto estrarrà e il secondo commando avvierà e inizializzerà il gioco dall'archivio. Istruzioni su come giocare sono fornite nel gioco direttamente.

Nota che quando si esce dal gioco (con `control-d` o il commando `gsh exit`) i tuoi progressi saranno salvati in un nuovo archivio (chiamato `GameShell-save.sh`).  
Esegui questo archivio per ritornare alla partita salvata.


Se preferisci non eseguire script shell estranei sul tuo computer puoi generare una immagine Docker con i comandi seguenti: 
```sh
$ mkdir GameShell; cd GameShell
$ wget --quiet https://github.com/phyver/GameShell/releases/download/latest/Dockerfile
$ docker build -t gsh .
$ docker run -it gsh
```
Il gioco NON verrà salvato quando esci e paramentri aggiuntivi sono necessari se vuoi eseguire X programmi da GameShell.  Approfondisci le differenze in [questa sezione](./doc/deps.md#running-GameShell-from-a-docker-container) del manuale utente.


Documentazione
-------------

Per trovare altre informazioni su GameShell, guarda questi documenti:
- Il [manuale utente](doc/user_manual.md) fornisce informazioni aggiuntive su come lanciare il gioco su tutti i sistemi supportati (Linux, macOS, BSD), spiega come eseguire il gioco dai sorgenti, come creare degli archivi personalizzati (utili se vuoi delle versioni del gioco per fare formazioni in classe) e altro.
- Il [manuale di sviluppo](doc/dev_manual.md) fornisce informazioni su come creare nuove missioni, tradurre le missioni e come partecipare allo sviluppo del gioco. 


Chi sta sviluppando GameShell?
----------------------------

### Sviluppatori

Il gioco é sviluppato da:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (sviluppatore principale,
  [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Contributori delle missioni

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Ringraziamenti speciali

* A tutti gli studenti che hanno trovato *molti* bug nelle prime versioni.
* Joan Stark (a.k.a, jgs), che ha disegnato centinaia di ASCII-art negli anni 90. Molte delle ASCII-art in GameShell sono sue.


Licenza
-------

GameShell è rilasciato con la [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Lascia un link a questo repository se utilizzi GameShell.

GameShell è open source e gratuito per l'uso. Un modo per ringraziare del lavoro è 
inviare una cartolina a

```
  Pierre Hyvernat
  Laboratoire de Mathématiques, CNRS UMR 5127
  Université de Savoie
  73376 Le Bourget du Lac
  FRANCE
```

