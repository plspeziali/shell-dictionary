#!/bin/bash

if [ -z "$1" ] && [ -z "$2" ]; then
	echo "SYNTAX ERROR: Write the word (DO NOT CAPITALIZE LETTERS) you want to see the translation of and the language (it, en) of the word you wrote (example: 'tavolo it' or 'table en'). Write -i for info."
	exit 1
fi
if [ $1 == "-i" ]; then
	echo "The WordReference of poor people - Made with love and tears by Paolo Speziali, 2017"
	exit 0
fi
case $2 in
	"it") lan1=1; lan2=2;;
	"en") lan1=2; lan2=1;;
	*) echo "Language not available (languages available: italian (it), english(en)"; exit 1;;
esac
cut -d ";" -f$lan2 dizionario.txt >temp
exec 0<temp
for word in `cut -d ";" -f$lan1 dizionario.txt`; do
	read trad
	if [ $word == $1 ]; then
		echo "The translation of $1 is $trad"
		rm -f temp
		exit 0
	fi
done
echo "Word not found"
for word in `cut -d ";" -f$lan1 dizionario.txt`; do
	length1=${#1}
	length2=${#word}
	i=1
	cont=0
	while [ $i -le $length1 ]; do
		j=1
		check=0
		while [ $j -le $length2 ] && [ $check -eq 0 ]; do
			echo $1>temp
			sub1=`cut -c $i temp`
			echo $word>temp
			sub2=`cut -c $j temp`
			if [ "$sub1" == "$sub2" ] ; then
				let "cont = $cont + 1"
				check=1
			fi
			let "j = $j +1"
		done
		let "i = $i +1"
	done
	perc=$((length1-3))
	if [ $cont -gt $perc ]; then
		echo "You might look for $word"
	fi
done
rm -f temp
