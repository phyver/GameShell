GameShell : un "jeu" pour apprendre le shell
============================================


GameShell (gash) est le résultat d'une réflexion sur comment enseigner les
rudiments (et un peu plus) du shell à des étudiants en première année à
l'université Savoie Mont Blanc.

L'idée initiale, due à Rodolphe Lepigre, était de lancer un shell bash avec un
fichier de configuration qui permettait d'effectuer des "missions", qui
seraient "validées" pour avancer.

N'hésitez pas à m'envoyer vos remarques, questions ou suggestions autour de
GameShell. En particulier, je suis preneur de nouvelles missions !


### Prérequis

GameShell devrait (??) fonctionner sur un système Linux standard.

Pour macOS, il faut installer ``coreutils`` et ``md5sha1sum``. Le plus simple
de d'utiliser le gestionnaire de paquet [homebrew](https://brew.sh/index_fr) :

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

puis d'installer les paquets nécessaires avec

    $ brew install coreutils
    $ brew install md5sha1sum


### contact

Pierre Hyvernat

http://www.lama.univ-smb.fr/~hyvernat

pierre.hyvernat@univ-smb.fr



Utilisation
-----------

### 1/ directement depuis les sources

    $ ./GameShell/start.sh
    Attention, vous êtes en train d'exécuter
    GameShell dans la version de développement.
    Faut-il le continuer ? [o/N]
    o
    ...
    ...

Note : lancer GameShell directement dans le répertoire des sources ne devrait
pas poser de problème...


### 2/ en créant une archive spécifique

    $ cd GameShell
    $ ./bin/archive.sh -M"*find*"
    copie des missions choisies
        /export/home/hyvernat/src/Shell/GameShell/missions/20_find_1  --> 01_find_1
        /export/home/hyvernat/src/Shell/GameShell/missions/31_find_2  --> 02_find_2
        /export/home/hyvernat/src/Shell/GameShell/missions/32_find_3_xargs -->  03_find_3_xargs
    suppression des script 'auto.sh' des missions
    choix du mode de lancement
    création de l'archive
    suppression du répertoire temporaire
    $ ls
    GameShell.tar  README  World/  bin/  doc/  lib/  missions/  start.sh*

Le fichier GameShell.tar contient une instance de GameShell avec uniquement
les 3 missions autour de la commande ``find``.

On peut maintenant copier cette archive n'importe où et lancer le jeu:

    $ mv GameShell.tar /tmp
    $ cd /tmp
    $ tar xf GameShell.tar
    $ ./GameShell/start.sh


Commandes de base
-----------------

GameShell est simplement une instance de bash avec des fonctions
supplémentaires. Ces fonctionnalités passent par la commande ``gash``.

  - gash help : affiche une petite liste des commandes
  - gash HELP : affiche une liste plus complète des commandes
  - gash show : affiche l'objectif de la mission courante
  - gash check : vérifie si la mission actuelle est validée
  - gash restart : recommence la mission courante



Ajout de mission
----------------

Chaque mission est contenue dans un répertoire dédié et peut fournir les
fichiers suivants

  - goal.txt
        petite description de la mission, affichée par ``gash show``
        (fichier texte, obligatoire)

  - static.sh
        fichier lu par bash __au lancement de GameShell__. C'est par exemple
        dans ce fichier que l'on peut créer des répertoire qui existeront pour
        toute les missions.
        Remarque : ce fichier est lu par bash (``source static.sh``) et peut
        donc par exemple définir des variables d'environnement.
        (fichier bash, facultatif)

  - init.sh
        fichier lu par bash __au lancement de la mission__. C'est par exemple
        dans ce fichier qu'on peut (re)générer des parties dynamiques de la
        mission.

  - check.sh
        fichier lu par bash pour vérifier que la mission est validée.
        Remarque : ce fichier est lu par bash (``source check.sh``) et __doit
        se terminer__ par une commande renvoyant la valeur 0 (typiquement,
        ``true``) en cas de succès, et par une commande renvoyant une valeur
        différente de 0 (typiquement ``false``) en cas d'échec.
        (fichier bash, obligatoire)

  - auto.sh
        fichier lu par bash pour valider automatiquement la mission
        Remarque : ce fichier est lu par bash (``source auto.sh``).
        (fichier bash, facultatif)

  - treasure.sh
        fichier bash lu par bash après validation de la mission. Cela permet
        d'ajouter des fonctionnalités comme "récompense" à certaines missions.
        (fichier bash, facultatif)

  - treasure.txt
        fichier texte affiché par bash après validation de la mission
        (fichier texte, facultatif)
