#!/bin/bash

url="192.168.8.12"
port="8080"
file="data.json"
directory="/tmp"
JQ="/usr/local/bin/jq"

identificados=0

cadena=""
logger -i "Inicio twiiter"


cd /tmp/
wget http://$url:$port/$file
data=`cat $directory"/"$file`
logger -i "json "$data

sin=`echo $data | $JQ 'length'`
logger -i "Variable sin "$sin

anteriores=`cat $directory"/vuelos"`
logger -i "vuelos anteriores "$anteriores
for i in $( echo $data | $JQ '.[].flight' | sed 's/"//' | sed 's/"//')
	do
		logger -i "Vuelo "$i
		if [ "$i" != "" ];
 		   then
			#echo $i
			z=$z" "$i
			identificados=$(($identificados+1))
		  fi;
		#contador=$(($contador+1))
		#echo $i" "$contador
	done
	logger -i "Fin de For"
logger -i $z" Segunda parte"

if [ "$z" != "" ] && [ "$z" != "$anteriores" ];
then
	logger -i "cadena de texto"
	if [ $identificados -eq 1 ];
		then
	   cadena=$cadena" El vuelo "$z
	fi;

	if [ $identificados -gt 1 ];
                then
           cadena=$cadena" Los vuelos "$z
        fi;
#        echo $sin" "$identificados
	#sin=$(($sin-$indentificados))
	let sin=$sin-$identificados
#	echo "Resultado "$sin

	if [ $sin -eq 1 ];
                then
           cadena=$cadena" y 1 vuelo más "
        fi;

        if [ $sin -gt 1 ];
                then
           cadena=$cadena" y $sin vuelos más "
        fi;
	cadena=$cadena" sobrevuela(n) #CostaRica. http://rpi-radar.no-ip.info"
	ttytter -status="$cadena"
	#echo $cadena
	logger -i $cadena
	echo $z > $directory"/vuelos"
else
	echo "Sin datos"
	logger -i "Sin datos"
fi;
rm -Rf data.json*
