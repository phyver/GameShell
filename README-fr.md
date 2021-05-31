GameShell : un "jeu" pour apprendre le shell Unix
=================================================

![Illustration inspired by the game](art/illustration-small.png)

Enseigner l'utilisation d'un shell Unix à des étudiants de première année à
l'université ou à des lycéens n'est pas toujours simple, ni très amusant.
GameShell a été conçu comme un outil pour aider les étudiants de [l'Université
Savoie Mont Blanc](https://univ-smb.fr) à découvrir un *vrai* shell, avec une
approche qui favorise l'apprentissage tout en s'amusant.

L'idée initiale, due à Rodolphe Lepigre, était de lancer une session bash avec
un fichier de configuration qui définissait des "missions", qui seraient
"validées" pour avancer dans le jeu.

Voilà le résultat...

N'hésitez pas à nous envoyer vos remarques, questions ou suggestions en
ouvrant des ["issues"](https://github.com/phyver/GameShell/issues) ou en
soumettant des ["pull requests"](https://github.com/phyver/GameShell/pulls).
Nous sommes particulièrement intéressés pas toute nouvelle mission que vous
pourriez créer !


Comment jouer ?
---------------

**Note:** GameShell est en phase de développement : la version courante n'a
pas été intensivement testée par des étudiants. N'hésitez pas à rapporter tout
problème que vous pourriez rencontrer et toute suggestion d'amélioration en
ouvrant une ["issue"](https://github.com/phyver/GameShell/issues/new).

GameShell devrait fonctionner sur n'importe quel système Linux standard, et
aussi sur macOS et BSD (mais ces systèmes ont été moins testés). Sur Debian ou
Ubuntu, les seules dépendances (autres que `bash`) sont les paquets `awk` et
`gettext-base` (le premier étant généralement installé par défaut). Certaines
missions ont des dépendances additionnelles : elles seront annulées si leurs
dépendances ne sont pas satisfaites. Sur Debian ou Ubuntu, lancez la commande
suivante pour installer toutes les dépendances pour le jeu et les missions.
```sh
$ sudo apt install gettext-base man-db psmisc nano tree bsdmainutils x11-apps
```
Consultez le [manuel utilisateur](doc/user_manual.md) (en anglais) pour voir
comment installer les dépendances sur d'autres systèmes (macOS, BSD, ...).

En supposant que toutes les dépendances sont installées, vous pouvez essayer
la dernière version du jeu en lançant les deux commandes suivantes dans un
terminal.
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/GameShell.sh
$ bash GameShell.sh
```
La première commande téléchargera la dernière version du jeu sous la forme
d'une archive auto-extractible, et la seconde commande initialisera et lancera
le jeu à partir de cette archive. Les instructions pour jouer sont données
directement dans le jeu.

Quand vous quitterez le jeu (avec `control-d` ou la commande `gsh exit`) votre
progression sera sauvegardée dans une nouvelle archive (nommée
`GameShell-save.sh`). Elle peut être lancée pour reprendre le jeu où vous vous
étiez arrêté.


Documentation
-------------

Pour en savoir plus sur GameShell les documents suivants sont disponibles (en
langue anglaise uniquement):
- Le [manuel utilisateur](doc/user_manual.md) explique, entre autres, comment
  lancer le jeu sur toutes les plateformes supportées (Linux, macOS, BSD),
  comment lancer le jeu à partir des sources, et comment générer une archive
  de jeu personnalisée (ce qui est utile pour utiliser le jeu dans le cadre
  d'un cours).
- Le [manuel développeur](doc/dev_manual.md) explique, entre autres, comment
  créer une nouvelle mission, comment traduire le jeu et les missions, et
  comment participer au développement du jeu.


Qui développe GameShell?
------------------------

### Développeurs

Le jeu est développé par:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (développeur
  principal, [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Contributeurs missions

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Remerciements

* Tous les étudiants qui ont testé les toutes premières versions du jeu.
* Joan Stark (alias jgs) qui a créé des centaines d'ASCII-art à la fin des
  années 90. La majorité des ASCII-art que vous rencontrerez dans GameShell
  lui sont dus.


Licence
-------

GameShell est distribué sous la licence [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Merci de pointer vers ce dépôt si vous l'utilisez.
