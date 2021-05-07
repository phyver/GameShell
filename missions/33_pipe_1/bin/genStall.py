#!/usr/bin/env python3

import random
import sys
from subprocess import getoutput
import gettext
import os

gettext.bindtextdomain(os.environ.get("TEXTDOMAIN"), localedir=os.environ.get("TEXTDOMAINDIR"))
gettext.textdomain(os.environ.get("TEXTDOMAIN"))


# gettext.gettext makes the script slow, use memoizing
G = {}
def _(k):
    global G
    if k in G:
        return G[k]
    v = gettext.gettext(k)
    G[k] = v
    return v


firstname = ["Abdallah", "Abdel", "Adelaide", "Adrien", "Agnes", "Alaric",
             "Ali", "Ali", "Alienor", "Alix", "Alphonse", "Alphonse", "Alwin",
             "Amaury", "Amedee", "Amin", "Amina", "Anastase", "Anastase",
             "Anastasie", "Anastasie", "Ariane", "Arnaud", "Arnaut", "Arthur",
             "Arthur", "Astrid", "Aubin", "Aude", "Aude", "Audoin", "Augustin",
             "Aure", "Avit", "Avit", "Aymar", "Bathilde", "Bathilde",
             "Baudoin", "Baudry", "Beatrice", "Beatrice", "Benedicte",
             "Benedicte", "Benoit", "Berenger", "Bernard", "Bernard", "Berthe",
             "Berthe", "Bertille", "Bertille", "Bertrand", "Bertrand", "Bilal",
             "Blanche", "Blanche", "Boniface", "Boniface", "Brice", "Brunhild",
             "Cassius", "Catherine", "Catherine", "Charles", "Charles",
             "Childebert", "Clodomir", "Clotaire", "Clotaire", "Clotilde",
             "Clotilde", "Cloud", "Cloud", "Clovis", "Colin", "Colomban",
             "Colombe", "Colombe", "Constance", "Constance", "Constantin",
             "Crepin", "Cyrielle", "Dagobert", "Didier", "Djafar", "Domitille",
             "Edouard", "Edouard", "Edwin", "Elisabeth", "Elizabeth", "Eloi",
             "Eloi", "Eloise", "Elvira", "Emeline", "Emeline", "Emma",
             "Engueran", "Enguerrand", "Eric", "Ermeline", "Etienne",
             "Etienne", "Eudes", "Eudes", "Eulalie", "Eulalie", "Evrard",
             "Fatima", "Fatima", "Ferdinand", "Fernand", "Fernande", "Fiacre",
             "Fiacre", "Firmin", "Firmin", "Flavien", "Flavien", "Florentin",
             "Florentin", "Foulques", "Frederic", "Frederic", "Fulbert",
             "Garcia", "Gaspard", "Gaston", "Gaston", "Gaultier", "Gauthier",
             "Gautier", "Gauvin", "Genevieve", "Geoffroy", "Geoffroy",
             "Gerald", "Germain", "Germain", "Gertrude", "Gertrude", "Gilbert",
             "Gilbert", "Gildas", "Gildas", "Gisele", "Goery", "Gontran",
             "Gontran", "Gregoire", "Gregoire", "Guenievre", "Guillaume",
             "Guillaume", "Guy", "Gysele", "Hadi", "Hafsa", "Halima", "Haroun",
             "Hassan", "Heloïse", "Hermance", "Hermine", "Hildegarde",
             "Hisham", "Hubert", "Hubert", "Hugues", "Hugues", "Hussein",
             "Ida", "Idriss", "Irene", "Isaac", "Isabel", "Isabelle", "Iseult",
             "Isidore", "Jean", "Jeanne", "Jeanne", "Jehanne", "Jimena",
             "Joséphine", "Julien", "Justin", "Justine", "Justinien",
             "Khadidja", "Lancelot", "Louis", "Louis", "Louise", "Lubin",
             "Mahaut", "Malvina", "Mansour", "Marcus", "Margaux", "Margaux",
             "Margot", "Margot", "Marguerite", "Maria", "Maria", "Mathilde",
             "Mathilde", "Maurice", "Maurice", "Maurin", "Melusine", "Merlin",
             "Morgane", "Musa", "Nestor", "Norbert", "Ode", "Ode", "Odeline",
             "Odile", "Odile", "Odilon", "Ogier", "Olivier", "Omar", "Omer",
             "Omer", "Oswald", "Pacome", "Pacome", "Paul", "Paulin", "Paulin",
             "Penda", "Pepin", "Pepin", "Perceval", "Petrus", "Philibert",
             "Philibert", "Philippe", "Philippe", "Pierre", "Pierre",
             "Pierrick", "Radegonde", "Raoul", "Raoul", "Raymond", "Remi",
             "Renaud", "Richard", "Robert", "Robert", "Robin", "Robin",
             "Roger", "Roland", "Roland", "Romain", "Romaric", "Samson",
             "Sawda", "Sebastien", "Sigismond", "Stanislas", "Sylvia",
             "Tancrede", "Tanguy", "Tarik", "Tariq", "Tassilo", "Theodore",
             "Thibaud", "Thibert", "Thierry", "Thierry", "Tiphaine",
             "Tiphaine", "Tristan", "Ulric", "Ulrich", "Urbain", "Ursula",
             "Ursule", "Venance", "Venance", "Veneranda", "Victoire",
             "Vincent", "Vincent", "Virgile", "Waldo", "Wilfrid", "Wilfried",
             "William", "Yazid", "Zacharia", "Zacharie"]

lastname = [_("the son of Martin"), "Langlois", "Anglais", "Duchesne", "du Chêne",
            "Marchand", "Boulanger", _("the Bold"), "Courtois", "Ageorges",
            "Aubernard", "Alamartine", _("Georges' son"), _("from next town"),
            "Fromentin", "Rabier", "Coulomb", "Coulon", "Cabrera", "Poudevigne",
            "Messonnier", "Métivier", "Pelletier", "Larsonneur", "Legros",
            "Lenain", "Sarrazin", "Chauvin", "Roux"]

thing = [_("a spade"), _("a pick"), _("an apple"), _("a chicken"), _("a horse"),
         _("a cow"), _("a goat"), _("a chackal"), _("a bag flour"), _("a ruby"),
         _("a piece of soap"), _("a leather ball"), _("a blanket"), _("a shiny rock"),
         _("an opal"), _("walking stick"), _("a leather bag"), _("a stool"), _("a pin"),
         _("a belt"), _("a dented helmet"), _("a wooden spoon"), _("a knife"),
         _("a bottle of cider")]


def genBooks(nbLines, nbKing, prob_paid, dir):
    amountKing = 0
    nbUnpaid = 0
    scroll = open(f"{dir}/{random.randint(0,1<<128):032x}_{_('_s_c_r_o_l_l_')}_{random.randint(0,1<<128):032x}", mode="w")
    for i in range(random.randint(int(nbLines*0.9), int(nbLines*1.1))):
        name = random.choice(firstname) + " " + random.choice(lastname)
        object = random.choice(thing)
        price = random.randint(2, 5)

        if random.random() <= prob_paid:
            end = " -- " + _("PAID")
            paid = True
        else:
            end = "."
            paid = False
            nbUnpaid += 1

        if i == 0 or random.randint(1, nbLines) <= nbKing:
            name = _("the King")
            if not paid:
                amountKing += price
        scroll.write(_("{} bought {} for {} coppers{}\n").format(name, object, price, end))
    getoutput("echo -n {} | sha1sum | cut -c 1-40 > $GSH_MISSION_DATA/amountKing".format(amountKing))
    getoutput("echo -n {} | sha1sum | cut -c 1-40 > $GSH_MISSION_DATA/nbUnpaid".format(nbUnpaid))


def genObjects(nbObjects, dir):
    for i in range(random.randint(int(nbObjects*0.9), int(nbObjects*1.1))):
        open(f"{dir}/{random.randint(0,1<<128):032x}_{_('boring_object')}_{random.randint(0,1<<128):032x}", mode="a").close()


if __name__ == "__main__":
    nbLines = int(sys.argv[1]) if len(sys.argv) >= 2 else 100
    nbKing = int(sys.argv[2]) if len(sys.argv) >= 3 else 10
    proba_paid = float(sys.argv[3]) if len(sys.argv) >= 4 else 0.2
    dir = sys.argv[4]
    genBooks(nbLines, nbKing, proba_paid, dir)
    genObjects(5000, dir)
