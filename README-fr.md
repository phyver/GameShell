GameShell : un "jeu" pour apprendre le shell Unix
=================================================


GameShell (gsh) est le résultat d'une réflexion sur comment enseigner les
rudiments (et un peu plus) du shell à des étudiants en première année à
l'université Savoie Mont Blanc.

L'idée initiale, due à Rodolphe Lepigre, était de lancer une session bash avec
un fichier de configuration qui définissait des "missions", qui seraient
"validées" pour avancer.

Voila le résultat...

N'hésitez pas à nous envoyer vos remarques, questions ou suggestions autour de
GameShell. Nous sommes particulièrement intéressés pas toute nouvelle mission
que vous pourriez créer !

GameShell est distribué sous la licence [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)


### Développeurs

* Pierre Hyvernat
* Rodolphe Lepigre


### contact

Pierre Hyvernat

http://www.lama.univ-smb.fr/~hyvernat

pierre.hyvernat@univ-smb.fr




Prérequis
---------

GameShell devrait (??) fonctionner sur un système Linux standard. Pour
Debian/Ubuntu, la seule vrai dépendance (à part `bash`) pour jouer est le
[paquet](paquet) `gettext-base`.

Si vous souhaitez créer vos propres missions et les traduire, il faudra
également installer le paquet `gettext`.

Si disponible, `python3` est utilisé pour afficher des boites en ASCII-art
("parchemins") autours de plusieurs messages. Sinon, `awk` est utilisé.
Suivant votre version de `awk`, les caractères UTF-8 peuvent provoquer des
erreurs d'alignement. Si c'est un problème, installez `python3`.

Certaines missions ont des dépendances supplémentaires. Si elles ne sont pas
satisfaites, ces missions seront simplement ignorées. Pour pouvoir lancer
toutes les missions actuellement disponibles, il faut disposer des commandes
suivantes

  - `man` (paquet `man-db` sous Debian/Ubuntu)
  - `ps` (paquet `procps` sous Debian/Ubuntu)
  - `pstree` (paquet `psmisc` sous Debian/Ubuntu)
  - `nano` (paquet `nano` sous Debian/Ubuntu)
  - `tree` (paquet `tree` sous Debian/Ubuntu)
  - `cal` (paquet `bsdmainutils` sous Debian/Ubuntu)
  - `xeyes` (paquet `x11-apps` sous Debian/Ubuntu)
  - `python3` (paquet `python3` sous Debian/Ubuntu)

Sur un système Debian / Ubuntu, la commande suivante devrait garantir que vous
pouvez lancer une partie de GameShell sans problème.

    $ sudo apt install gettext-base python3 man-db psmisc nano tree bsdmainutils x11-apps gettext



### Autres systèmes

#### macOS

Il devrait être possible de lancer GameShell depuis macOS, mais nous n'avons
pas testé depuis bien longtemps.

Le plus simple est probablement d'utiliser le gestionnaire de paquets [homebrew](https://brew.sh/index_fr) :

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

puis d'installer les paquets nécessaires avec

    $ brew install coreutils md5sha1sum pstree tree man-db


#### BSD ???

TODO


#### Windows ???

Il est peut-être possible de lancer GameShell depuis Windows si vous avez
installé [Cygwin](https://www.cygwin.com/).

Nous n'avons pas testé.



Lancer GameShell
----------------

### 1/ depuis les sources

Récupérez l'archive et lancez le script `start.sh` :

    $ rm -rf GameShell && mkdir GameShell && wget  https://api.github.com/repos/phyver/GameShell/tarball -O -  |  tar -xz -C GameShell --strip-components 1
    $ ./GameShell/start.sh
    ...
    ...

Si votre version de `tar` ne supporte pas l'option `--strip-components`,
utilisez

    $ rm -rf phyver-GameShell-* && wget  https://api.github.com/repos/phyver/GameShell/tarball -O -  |  tar -xz
    $ ./phyver-GameShell-*/start.sh
    ...
    ...


### 2/ depuis le dépôt git

Après avoir cloné le dépot, lancez le script `start.sh` (avec l'option `-F`
pour éviter un message d'avertissement) :

    $ git clone https://github.com/phyver/GameShell.git
    $ ./GameShell/start.sh -F
    ...
    ...


### 3/ depuis une archive exécutable

C'est le plus simple pour distribuer GameShell à des étudiants. Après avoir
cloné le dépot, créez une archive exécutable avec le script `archive.sh` :

    $ cd GameShell
    $ ./bin/archive.sh
    copy missions
    01_cd_1  -->  000001_cd_1
    ...
    ...
    generating '.mo' files
    removing 'auto.sh' scripts
    removing unnecessary (_*.sh, Makefile) files
    setting admin password
    setting default GameShell mode
    creating archive
    creating self-extracting archive
    removing tgz archive
    removing temporary directory
    $ ls
    ... GameShell.sh ...

Le fichier `GameShell.sh` contient une instance de GameShell que l'on peut
transférer sur n'importe quel ordinateur. Pour le lancer, vous pouvez utiliser
soit

    $ ./GameShell.sh

soit

    $ bash ./GameShell.sh


### 4/ en créant et utilisant une image Docker

L'idée de GameShell est d'avoir une session "la plus proche possible" d'une
session shell "standard". Je l'utilise donc sur des machines Linux "standard",
ou sur une machine virtuelle.

Il est possible de créer une image Docker en utilisant le fichier `Dockerfile`
fourni pour lancer GameShell sans s'occuper des dépendances :

* création de l'image :

        $ docker build -t gsh .

* lancement de l'image, si vous avez un serveur X :

        $ host +"local:docker@" &&    \
          docker run -it              \
             -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix \
             gsh

* lancement de l'image, sans serveur X :

        $ docker run -it gsh


Commandes de base
-----------------

GameShell est simplement une instance de bash avec des commandes
supplémentaires. Vous pouvez les appeler avec la commande ``gsh``.

  - `gsh help` : affiche une petite liste des commandes
  - `gsh goal` : affiche l'objectif de la mission courante
  - `gsh check` : vérifie si la mission actuelle est validée
  - `gsh reset` : recommence la mission courante

D'autre commandes existent mais ne sont normalement pas utiles dans une partie
standard. Vous pouvez en obtenir la liste avec

  - `gsh HELP` : affiche une liste complète des commandes `gsh`

Les commandes sont détaillés dans le fichier `doc/gameshell.md`.


Ajout de missions
-----------------

La création de nouvelles missions est détaillées dans le fichier dédié
`doc/missions.md`.



Contributeurs missions
----------------------

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard


Remerciements
-------------

* Tous mes étudiants qui ont testé les toutes premières versions
* Joan Stark, qui a créé des centaines d'ASCII-art à la fin des années 90. La
  majorité des ASCII-art que vous rencontrerez dans GameShell lui sont dus.
  (Les "`jgs`" que vous verrez sont ses initiales.)

Licence
-------

GameShell est distribué sous la licence [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

Merci de pointer vers ce dépôt si vous l'utilisez.
