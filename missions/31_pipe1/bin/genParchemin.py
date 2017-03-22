#!/usr/bin/env python3
# -*- encoding: UTF-8 -*-

import random
import sys
from subprocess import getoutput

prenoms = [ 'Abdallah', 'Abdel', 'Adelaide', 'Adrien', 'Agnes', 'Alaric',
           'Ali', 'Ali', 'Alienor', 'Alix', 'Alphonse', 'Alphonse', 'Alwin',
           'Amaury', 'Amedee', 'Amin', 'Amina', 'Anastase', 'Anastase',
           'Anastasie', 'Anastasie', 'Ariane', 'Arnaud', 'Arnaut', 'Arthur',
           'Arthur', 'Astrid', 'Aubin', 'Aude', 'Aude', 'Audoin', 'Augustin',
           'Aure', 'Avit', 'Avit', 'Aymar', 'Bathilde', 'Bathilde', 'Baudoin',
           'Baudry', 'Beatrice', 'Beatrice', 'Benedicte', 'Benedicte',
           'Benoit', 'Berenger', 'Bernard', 'Bernard', 'Berthe', 'Berthe',
           'Bertille', 'Bertille', 'Bertrand', 'Bertrand', 'Bilal', 'Blanche',
           'Blanche', 'Boniface', 'Boniface', 'Brice', 'Brunhild', 'Cassius',
           'Catherine', 'Catherine', 'Charles', 'Charles', 'Childebert',
           'Clodomir', 'Clotaire', 'Clotaire', 'Clotilde', 'Clotilde', 'Cloud',
           'Cloud', 'Clovis', 'Colin', 'Colomban', 'Colombe', 'Colombe',
           'Constance', 'Constance', 'Constantin', 'Crepin', 'Cyrielle',
           'Dagobert', 'Didier', 'Djafar', 'Domitille', 'Edouard', 'Edouard',
           'Edwin', 'Elisabeth', 'Elizabeth', 'Eloi', 'Eloi', 'Eloise',
           'Elvira', 'Emeline', 'Emeline', 'Emma', 'Engueran', 'Enguerrand',
           'Eric', 'Ermeline', 'Etienne', 'Etienne', 'Eudes', 'Eudes',
           'Eulalie', 'Eulalie', 'Evrard', 'Fatima', 'Fatima', 'Ferdinand',
           'Fernand', 'Fernande', 'Fiacre', 'Fiacre', 'Firmin', 'Firmin',
           'Flavien', 'Flavien', 'Florentin', 'Florentin', 'Foulques',
           'Frederic', 'Frederic', 'Fulbert', 'Garcia', 'Gaspard', 'Gaston',
           'Gaston', 'Gaultier', 'Gauthier', 'Gautier', 'Gauvin', 'Genevieve',
           'Geoffroy', 'Geoffroy', 'Gerald', 'Germain', 'Germain', 'Gertrude',
           'Gertrude', 'Gilbert', 'Gilbert', 'Gildas', 'Gildas', 'Gisele',
           'Goery', 'Gontran', 'Gontran', 'Gregoire', 'Gregoire', 'Guenievre',
           'Guillaume', 'Guillaume', 'Guy', 'Gysele', 'Hadi', 'Hafsa',
           'Halima', 'Haroun', 'Hassan', 'Heloïse', 'Hermance', 'Hermine',
           'Hildegarde', 'Hisham', 'Hubert', 'Hubert', 'Hugues', 'Hugues',
           'Hussein', 'Ida', 'Idriss', 'Irene', 'Isaac', 'Isabel', 'Isabelle',
           'Iseult', 'Isidore', 'Jean', 'Jeanne', 'Jeanne', 'Jehanne',
           'Jimena', 'Joséphine', 'Julien', 'Justin', 'Justine', 'Justinien',
           'Khadidja', 'Lancelot', 'Louis', 'Louis', 'Louise', 'Lubin',
           'Mahaut', 'Malvina', 'Mansour', 'Marcus', 'Margaux', 'Margaux',
           'Margot', 'Margot', 'Marguerite', 'Maria', 'Maria', 'Mathilde',
           'Mathilde', 'Maurice', 'Maurice', 'Maurin', 'Melusine', 'Merlin',
           'Morgane', 'Musa', 'Nestor', 'Norbert', 'Ode', 'Ode', 'Odeline',
           'Odile', 'Odile', 'Odilon', 'Ogier', 'Olivier', 'Omar', 'Omer',
           'Omer', 'Oswald', 'Pacome', 'Pacome', 'Paul', 'Paulin', 'Paulin',
           'Penda', 'Pepin', 'Pepin', 'Perceval', 'Petrus', 'Philibert',
           'Philibert', 'Philippe', 'Philippe', 'Pierre', 'Pierre', 'Pierrick',
           'Radegonde', 'Raoul', 'Raoul', 'Raymond', 'Remi', 'Renaud',
           'Richard', 'Robert', 'Robert', 'Robin', 'Robin', 'Roger', 'Roland',
           'Roland', 'Romain', 'Romaric', 'Samson', 'Sawda', 'Sebastien',
           'Sigismond', 'Stanislas', 'Sylvia', 'Tancrede', 'Tanguy', 'Tarik',
           'Tariq', 'Tassilo', 'Theodore', 'Thibaud', 'Thibert', 'Thierry',
           'Thierry', 'Tiphaine', 'Tiphaine', 'Tristan', 'Ulric', 'Ulrich',
           'Urbain', 'Ursula', 'Ursule', 'Venance', 'Venance', 'Veneranda',
           'Victoire', 'Vincent', 'Vincent', 'Virgile', 'Waldo', 'Wilfrid',
           'Wilfried', 'William', 'Yazid', 'Zacharia', 'Zacharie']

noms = ['fils de Martin', 'Langlois', 'Anglais', 'Duchesne', 'du Chêne',
        'Marchand', 'Boulanger', 'le Chauve', 'Courtois', 'Ageorges',
        'Aubernard', 'Alamartine', 'le fils à Georges', 'le fils au Bernard',
        'Fromentin', 'Rabier', 'Coulomb', 'Coulon', 'Cabrera', 'Poudevigne',
        'Messonnier', 'Métivier', 'Pelletier', 'Larsonneur', 'Legros',
        'Lenain', 'Sarrazin', 'Chauvin', 'Roux']

objets = ['une pelle', 'un pic', 'une besace', 'une pomme', 'une poule', 'un cheval',
          'une vache', 'une chèvre', 'un chacal', 'un sac de blé', 'un rubis',
          "un savon", "une balle de cuir", "une couverture", "un caillou brillant",
          'une opale', 'un bâton de marche', 'une besace', 'un tabouret', 'une épingle',
          'une ceinture', 'un heaume']

def gen(nbLignes, nbDuRoi, probaPaye ):
    detteDuDuc = 0
    nbImpayes = 0
    l = []
    for i in range(random.randint( int(nbLignes*0.9), int(nbLignes*1.1))):
        nom = random.choice(prenoms) + ' ' + random.choice(noms)
        objet = random.choice(objets)
        prix = random.randint(2,5)

        x = random.randint(0,9)
        if random.random() <= probaPaye:
            finale = ' -- PAYÉ.'
            paye = True
        else:
            finale = '.'
            paye = False
            nbImpayes += 1

        if i == 0 or random.randint(1,n) <= nbDuRoi:
            nom = "Le Duc"
            if not paye :
                detteDuDuc += prix
        l.append("{} m'a acheté {} pour {} piécettes{}".format(nom, objet, prix, finale))
    print('\n'.join(l))
    getoutput("echo -n {} | sha1sum | cut -c 1-40 > $GASH_TMP/detteDuDuc".format(detteDuDuc))
    getoutput("echo -n {} | sha1sum | cut -c 1-40 > $GASH_TMP/nbImpayes".format(nbImpayes))

if __name__ == '__main__':
    n = int(sys.argv[1]) if len(sys.argv) >= 2 else 100
    nbRoi = int(sys.argv[2]) if len(sys.argv) >= 3 else 10
    pp = float(sys.argv[3]) if len(sys.argv) >= 4 else 0.2
    gen(n,nbRoi,pp)

