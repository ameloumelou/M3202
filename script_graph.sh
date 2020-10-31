#! /bin/bash

rm graph.xdot # Supprime l'ancien fichier .xdot

echo "digraph G {" >> graph.xdot # Initialise le fichier .xdot en envoyant "digraph G {"
for fichier in $@ # Initialise la boucle qui va analyser chaque fichier
do
echo "fichier" $@
nbligne=`wc -l $fichier | awk '{print $1}'` # Compte le nombre de ligne du fichier
echo $nbligne
	for ((i=1; i<=$nbligne; i++)) # Initialise la boucle qui va analyser chaque ligne du fichier
	do
		if [ "$(echo $i)" == "$nbligne" ] # Si le nombre de ligne est égal au numéro de la ligne actuelle le programme est à la fin du fichier
		then
		cat $fichier | sed -n "$i"p | sed 's/^/"/' | sed 's/$/"/' >> graph.xdot # Le programme rajoute des guillemets au début et à la fin de la ligne puis l'envoie
	fi                                                                        # dans le fichier .xdot

		if [ "$(echo $i)" != "$nbligne" ] # Si le nombre de ligne n'est pas égal au numéro de la ligne actuelle le programme n'est pas à la fin du fichier
		then
		cat $fichier | sed -n "$i"p | sed 's/^/"/' | sed 's/$/"->/' >> graph.xdot # Le programme rajoute un guillemet au debut de la ligne et rajoute un guillemet plus une flèche
	fi                                                                          # à la fin de la ligne puis envoie la ligne dans le fichier .xdot
	done
done

echo ";}" >> graph.xdot # Termine le fichier .xdot en envoyant ";}"
xdot graph.xdot # Lance xdot 
