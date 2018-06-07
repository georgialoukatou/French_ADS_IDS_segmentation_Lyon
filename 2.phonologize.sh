#!/bin/sh
# Wrapper to take a single cleaned up transcript and phonologize it
# Alex Cristia alecristia@gmail.com 2015-10-26
# Modified by Laia Fibla laia.fibla.reixachs@gmail.com 2016-09-28 adapted to arg spanish
# Modified by Georgia Loukatou georgialoukatou@gmail.com 2017-04-02 adapted to chintang, japanese, french, russian 


#########VARIABLES
#Variables to modify
LANGUAGE="french" #language options:.. -- NOTICE, IN SMALL CAPS


PATH_TO_SCRIPTS="$1"
#"/Users/bootphonproject/Desktop/segmentation/scripts/"
#path to the phonologization folder 

RES_FOLDER="$2"
#"/Users/bootphonproject/Desktop/segmentation/results/japanese"
#this is where we will put the processed versions of the transcripts
# NOTICE THE / AT THE END OF THE NAME

NAME="$3"
LC_ALL=C

for ORTHO in ${RES_FOLDER}/${NAME}.txt; do
	KEYNAME=$(basename "$ORTHO" .txt)

	#########
	if [ "$LANGUAGE" = "french" ]
	   then
	  echo "recognized $LANGUAGE"
	sed 's/ $//g'   < "$ORTHO"  | 
	  sed 's/ $//g' | #
	  sed 's/^$//g' | #
	  sed 's/jjj/j/g' | #
	  sed 's/jj/j/g' |
	  sed 's/milimɛtʁ/mm/g'|
	  sed 's/ɛmɛmaʃ/mm/g' |
	  sed 's/akote/a ;eword kote/g' |	 
          sed 's/paʁsək/paʁskə/g' |
	  sed 's/tutfasU/tut ;eword fasU ;eword/g' |
	  sed 's/k1stsEk1l/k1stsEk ;eword 1l/g' |
	  sed 's/te ;eword as/t ;eword as/g' |
	  sed 's/kɛlkɛʃoz/kɛlkɛ ;eword ʃoz/g'| 
          sed 's/ɛ̃/0/g' |
	  sed 's/ɛ̃/0/g' |
	  sed 's/ɛː/7/g' | 
	  sed 's/ɛ/1/g' |
	  sed 's/ʁ/R/g' |
	  sed 's/ə/E/g' |
	  sed 's/ʒ/Z/g' |
	  sed 's/ɑ̃/A/g' |
	  sed 's/œ̃/O/g'|
	  sed 's/ɔ̃/U/g' |
	  sed 's/ø/3/g' |
	  sed 's/ɐ/B/g' |
	  sed 's/ɹ/T/g' |
	  sed 's/ɔ/4/g' |
	  sed 's/ʃ/S/g' |
	  sed 's/ɡ/g/g' |	 
 	  sed 's/œ/5/g' |
	  sed 's/ɲ/N/g' |
	  sed 's/ð/D/g'  |
	  sed 's/ɪ/I/g' |
	  sed 's/iː/6/g' |
	  sed 's/-//g' |
	  sed 's/uː/8/g' |
	  sed 's/ʌ/9/g' |
	  sed 's/aː/2/g'  |
	  sed 's/jː/J/g' |
	  sed 's/yː/Y/g' |
 	  sed 's/ʊ/X/g' |
	  sed 's/vvv/v/g' |
	  sed 's/wa/W/g' |
	  ##sed 's/bj/B/g' | #do not use commented rules
	  ##sed 's/tj/T/g' |
	  ##sed 's/vj/V/g' | 
	  ##sed 's/dj/F/g' |
	  ##sed 's/Sj/C/g' |
	  ##sed 's/Rj/Q/g' |
	  ##sed 's/kj/K/g' |
	  ##sed 's/mj/M/g' |
	  ##sed 's/pj/P/g' |
	 ## sed 's/sj/H/g' |
	   sed 's/;eword //g' > ${RES_FOLDER}/intoperl.txt |

	  echo "syllabify-corpus.pl"
	  perl $PATH_TO_SCRIPTS/new-syllabify-corpus.pl french ${RES_FOLDER}/intoperl.txt ${RES_FOLDER}/outofperl.txt $PATH_TO_SCRIPTS


	fi

		echo "removing blank lines"
	#	LANG=C LC_CTYPE=C LC_ALL=C
		sed 's/^\///g'  ${RES_FOLDER}/outofperl.txt |
		sed '/^ $/d'  |
		sed '/^[ ]*$/d'  |
		sed 's/^ //g'  |
		sed 's/?//g' |
		sed 's/!//g' |
		sed 's/।//g' |
		sed 's/\n//g' |
		sed 's/\.//g' |
 		sed 's/\,//g' |
		sed 's/^//g' |
		sed 's/=//g' |
		sed 's/(//g' |
		sed 's/)//g' |
		sed 's/\^//g' |
		sed 's/-/ /g' |
		#sed 's///g' |
		#sed 's/™//g' |
		#sed 's/…//g' |
		sed 's/_//g' |
		sed 's/://g' |
		sed 's/  / /g' |
		sed 's/^\///g'  | #there aren't really any of these, this is just a cautionary measure
		sed 's/ / ;eword /g' |
		sed 's/\// ;esyll /g' |
		sed 's/  / /g' |
		sed 's/\(.\)/\1 /g'  |    
		sed 's/ ; e w o r d/ ;eword/g' | #the below should be removed after some checking, theoretically they don't apply anymore (older versions) 
		sed 's/ ; e s y l l/ ;esyll/g'|
		sed 's/  / /g' |
		sed 's/;eword  ;esyll/;esyll  ;eword/g' |               
 		sed 's/;eword ;esyll/;esyll ;eword/g' |
		sed 's/  / /g' |
                sed 's/ː//g' |
		sed 's/;eword$/;esyll ;eword/g' |
		sed 's/;eword $/;esyll ;eword/g' |	
                sed 's/;eword ;esyll ;eword/;esyll ;eword/g' |
                sed 's/;eword ;esyll ;eword/;esyll ;eword/g'|
                sed 's/;eword ;esyll ;eword/;esyll ;eword/g'|
		sed 's/^ ;esyll ;eword//g'| 
		sed 's/^ //g'|
		sed 's/;eword ;esyll/;esyll ;eword/g' > ${RES_FOLDER}/${KEYNAME}-tags.txt
		

		#mv ${RES_FOLDER}/tmp.txt ${RES_FOLDER}/${KEYNAME}-tags.txt
		

	#echo "creating gold versions"
	
		sed 's/;esyll//g'  < ${RES_FOLDER}/${KEYNAME}-tags.txt |
		tr -d ' ' |
		sed 's/;eword/ /g' > ${RES_FOLDER}/${KEYNAME}-gold.txt

done


echo "end"



echo "end"

#pcregrep --color='auto' -n '[^\x00-\x7F]' $PROCESSED_FILE2 #check if any problematic characters...

