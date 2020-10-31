#!/bin/bash

rm $1ip.txt #supprime l'ancien fichier si cette ip à déjà été recherché
for ((ttl=1; ttl<=30; ttl++)) #initialise la boucle qui va incrémenter le TTL
do

option=("-I" "-T" "-T -p80" "-T -p25" "-T -p22" "-T -p443" "-T -p53" "-U" "-U -p80" "-U -p25" "-U -p22" "-U -p443") #Création du tableau des différentes options

echo "TTL= " $ttl
	for option in "${option[@]}" #initialisation de la boucle qui va faire tourner le tableau options
	do
		echo -e "\tOption= " $option
		ip=`traceroute -q1 $option -f$ttl -m$ttl $1 | cut -d"(" -f2 | cut -d")" -f1 | sed '1d' | sed -e "s/*/nul($1)/g"` #commande traceroute qui recherche l'IP de chaque routeur
		# as=`traceroute -q1 $option -f$ttl -m$ttl -A $1 | cut -d"[" -f2 | cut -d"]" -f1 | sed '1d' | sed -e "s/*/nul($1)/g"`
		echo $ip
		# echo $as

		if [[ $res != *nul* ]] # Permet de stopper la boucle si on trouve une IP pour le routeur sinon on continue la boucle jusqu'à la fin des options
		then
			echo -e "\tFin "
			break
		fi
	done

	echo $ip >> $1ip.txt # Lorsque la boucle faisant défiler lesoption est finit on envoie ce qu'on à trouver (addresse IP ou pas) dans le fichier du nom de l'IP

	if [ "$res" = "$1" ] # Permet de stopper la boucle incrémentant le TTL si la dernière IP trouvé est égale à l'IP de départ
	then
		echo $1 atteint
		break
	fi
done
