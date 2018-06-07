#!/bin/bash

#- passing some parameters if working on oberon
#$-S /bin/bash        # the shell used
#$-N big_wrap  # gives the name of the job
#$-pe openmpi_ib 1   # nb of cores required (this is purely declarative)
#$-j yes   # join stdout and stderr in the same file
#$-q cpu   # name of the queue (cpu, gpu, all)
#$-cwd     # puts the logs in the current directory

#- some messages to the user
/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
echo QUEUE=$QUEUE
echo NSLOTS=$NSLOTS
/bin/echo Starting on: `date`

#- some back magic
. /etc/profile.d/modules.sh

#pipeline for lena project_segmentation on transcriptions

#Adapt the following variables, being careful to provide absolute paths

PATH_TO_SCRIPTS="/scratch2/gloukatou/lena/scripts"	#path to the scripts folder
PATH_TO_TRANSCRIPTS="/scratch2/gloukatou/lena/transcripts/corpora" #path to the .cha files
ROOT="/scratch2/gloukatou/lena" # root folder

mkdir -p $RES_FOLDER	#create the folder that will contain all output files
RES_FOLDER="/scratch2/gloukatou/lena/results"   #path to the processed versions of the transcripts

#load wordseg package 
module load festival espeak; module load python-anaconda; source activate wordseg

#for CHILD in ${PATH_TO_TRANSCRIPTS}/*
#do
# echo "name of the child : $CHILD" 
#	for VERSION in ${CHILD}/*.cha 
#	 do
#	  echo "part of $CHILD corpus : $VERSION"
#	    IncludedParts=`tr '\015' '\n' < $VERSION  |
#		grep "@ID"  |    #take only @ID lines of the file
#		awk -F "|" '{ print $3, $8 }'|  #let through only 3-letter code and role
#	       	grep -v 'Child\|CHI\|Sister\|Brother\|Cousin\|Boy\|Girl\|Unidentified\|Sibling\|Target\|Non_Hum\|Play'|  #remove all the children and non-human participants to leave only adults
#	       	awk '{ print $1 }' | #print out the first item, which is the 3 letter code for those adults
#		tr "\n" "%" | # put them all in the same line
#	 	sed "s/^/*/g" | #add an asterisk at the beginning
#	 	sed "s/%/\\\\\|*/g" |  #add a pipe between every two
#		sed "s/\\\\\|.$//" >  ${VERSION}-temp.txt #` #remove the pipe* next to the end of line & close the text call > > ${VERSION}-temp.txt ####file with only the utterances from adults

#		bash ${PATH_TO_SCRIPTS}/cha2sel_withinputParticipants.sh  ${VERSION} ${VERSION}-ortho.txt $IncludedParts
		
##		#ATTENTION TO ORDER
##		#Cleaning the corpus
#		sed 's/[,_.!]//g' < ${VERSION}-ortho.txt |
#		sed '/^\s*$/d' | #remove empty lines
#		grep -v '^*CHI' | #remove target child utterances
#		grep -v 'OCH' |	#remove other child utterances
#           	grep -v 'CH' |	#remove any child utterances
#		grep -v 'xxx ' | #remove lines with untranscribed words
#		grep -v 'XXX ' | 
#		grep -v 'xxx' |
#		grep -v 'XXX' |
#		grep -v 'xx ' |
#		tr '[:upper:]' '[:lower:]' | # small letters
#		sed 's/^[bcdfghjklmnpqrstvwxz]$//g' | # remove one-consonant-long utterances
#		sed 's/(//g' | 
#		sed 's/)//g' |
#		sed 's/[0-9]\{2,\}//g' | #remove final numbers
#		sed 's/  / /g' |
#		sed 's/  / /g' |
#		sed 's/\[//g' |
#               sed 's/\]//g'|
#               sed 's/\+//g'|
#               sed 's/\?//g'|		
#		sed 's/\[//g' |
#		sed 's/\]//g'|
#		sed 's/\+//g'|
#		sed 's/\?//g'|
#		sed 's/\///g' | 
#		sed 's/_/ /g' |
#		sed 's/^ +//g' |
#		sed 's/  / /g' |
#		sed '/^\s$/d'|
#		sed '/^$/d'|
#		sed '/^    $/d' |
#		sed '/^ $/d' |
#		grep -v '^$'| # remove empty lines
#		sed 's/ ducoup / du coup /g' |  ### from here on correct inconsistencies, so that phonemizer gives same results
#		sed "s/ questce / qu'\''est ce /g" |
#		sed 's/ enfait / en fait /g' |
#		sed 's/ cellelà / celle là /g' |
#		sed 's/ quandmême / quand même /g' |
#		sed "s/ sasseoit / s'\''asseoit / g" |
#		sed 's/ yavait / y avait /g' |
#		sed 's/ parcontre / par contre /g'|
#		sed 's/ audébut / au début /g' |
#		sed 's/ yaller / y aller /g' |
#		sed 's/ toutlemonde / tout le monde /g'|
#		sed 's/ toutàl / tout à l /g'|
#		sed "s/ cétait / c'\''était /g"|
#		sed 's/ estce / est ce /g' |
#		sed 's/estce /est ce /g' |
#		sed 's/ toutefaçon / toute façon /g'|#
#		sed 's/ estcequelle / est ce qu elle /g' |
#		sed 's/ cellelà / celle là /g' |
#		sed 's/ tessaie / t'\''essaie /g'|
#		sed 's/ ilteplait / il te plait /g' |
#		sed "s/ ten / t'\''en /g"|
#		sed 's/ jaimerais / j'\''aimerais /g' |
#		sed 's/ maisn / maison /g'|
#		sed "s/ sil / s'\''il /g" |
#		sed "s/ cest / c'\''est /g"|
#		sed 's/ ya / y a /g' |
#		sed 's/ tele / te le /g'|
#		sed 's/ yest / y est /g'|
#		sed "s/ quil / qu'\''il /g"|
#		sed 's/ quest / qu'\''est /g'|
#		sed 's/ estcelui / est ce lui /g' |
#		sed "s/ tas / t'\''as /g"|
#		sed "s/ timagine / t'\''imagines /g"|
#		sed 's/ estce / est ce /g'|
#		sed 's/ questce / qu'\''est ce /g'|
#		sed 's/ queje / que je /g'|
#		sed 's/ pasvu / pas vu /g'|
#		sed 's/ ilen / il en /g'|
#		sed 's/ toutletemps / tout le temps /g'|
#		sed 's/ parterre / par terre /g'|
#		sed 's/ çellelà / çelle là /g'|
#		sed "s/ lavait / l'\''avait /g"|
#		sed "s/ jadore / j'\''adore /g"|
#		sed 's/ çayest / ça y est /g'|
#		sed 's/ quiya / qui y a /g'|
#		sed 's/ ouelle / ou elle /g'| 
#		sed "s/ s'\''ilteplaît / s'\''il te plaît /g" |
#		sed 's/ estce /est ce /g' |
#		sed "s/ dautre / d'\''autre /g" |
#		sed 's/ ouioui / oui oui /g' |
#		sed "s/ c était / c'\''était /g"|
#		sed 's/ parceque / parce que /g'|
#		sed 's/ là-bas / là bas /g'|
#		sed "s/ jai / j'\''ai /g"|
#		sed "s/ cest / c'\''est /g"|
#		sed "s/ quau / qu'\''au /g"|
#		sed 's/ acote / à côté /g' |
#		sed 's/ quelquechose / quelque chose /g'|
#		sed "s/ toutduncoup / tout d'\''un coup /g"|
#		sed 's/ enbas / en bas /g' |
#		sed 's/ lepont / le pont /g'|
#		sed 's/ par ce que / parce que /g' |
#		sed "s/ t'\''aime / t'\''aimes /g" |
#		sed "s/ t en / t'\''en /g" |
#		sed 's/ elleest / elle est /g'|
#		sed "s/quest /qu'\''est /g"|
#		sed "s/ qu est / qu'\''est /g"| 
#		sed '/[a-z]$/d'| # remove not annotated lines 
#		sed 's/^......//g'|
#		sed 's/..$//g' | 
#		sed 's/^\s//g' |
#		sed "s/'''/'/g"|
#		grep -v '^\s$' > ${VERSION}-clean_ortho.txt
#		grep '3' < ${VERSION}-clean_ortho.txt > ${VERSION}-clean_ortho-ADS.txt # important step, saves Adult Directed in separate file
#		grep '1' < ${VERSION}-clean_ortho.txt > ${VERSION}-clean_ortho-CDS.txt # (Target) Child Directed
#		
#done

#cat ${CHILD}/*-clean_ortho-ADS.txt >> ${CHILD}/clean_ortho-ADS-all.txt # merge Adult Directed files for each child
#cat ${CHILD}/*-clean_ortho-CDS.txt >> ${CHILD}/clean_ortho-CDS-all.txt # 

#sed -i 's/[0-3]//g' ${CHILD}/clean_ortho-ADS-all.txt 	#remove final details
#sed -i 's/[0-3]//g' ${CHILD}/clean_ortho-CDS-all.txt  

#mkdir ${CHILD}/results # create results folder
#mkdir ${CHILD}/results/ADS
#mkdir ${CHILD}/results/CDS

##phonemize
#phonemize -l fr-fr -p " " -w " ;eword "  ${CHILD}/clean_ortho-CDS-all.txt -o  ${CHILD}/results/CDS/clean_ortho-all-phon.txt --strip
#phonemize -l fr-fr -p " " -w " ;eword "  ${CHILD}/clean_ortho-ADS-all.txt -o  ${CHILD}/results/ADS/clean_ortho-all-phon.txt --strip


PATH_TO_TRANSCRIPTS2="/scratch2/gloukatou/lena/transcripts"
#mkdir "${PATH_TO_TRANSCRIPTS2}/results"
#mkdir "${PATH_TO_TRANSCRIPTS2}/results/ADS"
#mkdir "${PATH_TO_TRANSCRIPTS2}/results/CDS"


#merge all children
#cat ${PATH_TO_TRANSCRIPTS}/*/results/CDS/clean_ortho-all-phon.txt >> ${PATH_TO_TRANSCRIPTS2}/results/CDS/clean_ortho-all-phon.txt
#cat ${PATH_TO_TRANSCRIPTS}/*/results/ADS/clean_ortho-all-phon.txt >> ${PATH_TO_TRANSCRIPTS2}/results/ADS/clean_ortho-all-phon.txt


## run script to collect onsets #DO NOT RERUN, onset list is ready (see final_french_onsets.txt)
##python ${PATH_TO_SCRIPTS}/syllabify_french_extract_onsets.py ${VERSION}/ADS_phon.txt ${VERSION}-french_onsets.txt
##cat ${VERSION}-french_onsets.txt >> ${RES_FOLDER}/french_onsets.txt
##sort -u < ${RES_FOLDER}/french_onsets.txt > ${RES_FOLDER}/final_french_onsets.txt


#for CORPUS in ${PATH_TO_TRANSCRIPTS2}/results/CDS  # or ADS - TO DO: add in the script
#do

#phonologize
#bash ${PATH_TO_SCRIPTS}/2.phonologize.sh  ${PATH_TO_SCRIPTS} ${CORPUS} "clean_ortho-all-phon" # generates tags file

#THISTAG="${CORPUS}/clean_ortho-all-phon-tags.txt"
#echo "${THISTAG}"


#cat $THISTAG | wordseg-prep -u syllable --gold /${CORPUS}/gold.txt > /${CORPUS}/prepared_syll.txt # generate gold file and prepared_syll file (syllables as basic units) to use as input for TP model

#cat ${CORPUS}/prepared_syll.txt | wordseg-tp -t relative -p forward > ${CORPUS}/segmented.ftp_rel.txt # tp algo
#cat ${CORPUS}/segmented.ftp_rel.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.ftp_rel.txt
#cat ${CORPUS}/prepared_syll.txt | wordseg-tp -t absolute -p forward > ${CORPUS}/segmented.ftp_abs.txt
#cat ${CORPUS}/segmented.ftp_abs.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.ftp_abs.txt
#cat ${CORPUS}/prepared_syll.txt | wordseg-tp -t relative -p backward > ${CORPUS}/segmented.btp_rel.txt
#cat ${CORPUS}/segmented.btp_rel.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.btp_rel.txt
#cat ${CORPUS}/prepared_syll.txt | wordseg-tp -t absolute -p backward > ${CORPUS}/segmented.btp_abs.txt
#cat ${CORPUS}/segmented.btp_abs.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.btp_abs.txt

#cat $THISTAG | wordseg-prep --gold /${CORPUS}/gold.txt > /${CORPUS}/prepared.txt #prepared file (phonemes as basic units)


#size=$(wc -l <"${CORPUS}/prepared.txt") #dibs model
#echo "$size"

#head -"${size}" $THISTAG > ${CORPUS}/train.txt
#head -200  $THISTAG > ${CORPUS}/train200.txt # no need for that anymore

#wordseg-dibs -t phrasal -o ${CORPUS}/segmented.dibs.txt ${CORPUS}/prepared.txt  ${CORPUS}/train.txt
#wordseg-eval -o ${CORPUS}/eval.dibs.txt ${CORPUS}/segmented.dibs.txt ${CORPUS}/gold.txt

#wordseg-dibs -t phrasal -o ${CORPUS}/segmented.dibs200.txt ${CORPUS}/prepared.txt  ${CORPUS}/train200.txt # do not use
#wordseg-eval -o ${CORPUS}/eval.dibs200.txt ${CORPUS}/segmented.dibs200.txt ${CORPUS}/gold.txt # do not use

#module load python-anaconda  # AG runs on anaconda, if not errors

#wordseg-ag ${CORPUS}/prepared.txt ${PATH_TO_SCRIPTS}/Colloc0_fr.lt Colloc0 -n 2000 -vv > ${CORPUS}/segmented.ag.txt
#cat ${CORPUS}/segmented.ag.txt | wordseg-eval ${CORPUS}/gold.txt  > ${CORPUS}/eval.ag.txt


###### theoretically, we could also run PUDDLE, but not added yet. To add!



#baselines
#cat ${CORPUS}/prepared_syll.txt | wordseg-baseline -P 1 > ${CORPUS}/segmented.baselinesyll1.txt
#cat ${CORPUS}/segmented.baselinesyll1.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.baselinesyll1.txt

#cat ${CORPUS}/prepared_syll.txt | wordseg-baseline -P 0 > ${CORPUS}/segmented.baselinesyll0.txt
#cat ${CORPUS}/segmented.baselinesyll0.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.baselinesyll0.txt

#cat ${CORPUS}/prepared_syll.txt | wordseg-baseline -P 0.5 > ${CORPUS}/segmented.baselinesyll0.5.txt
#cat ${CORPUS}/segmented.baselinesyll0.5.txt | wordseg-eval ${CORPUS}/gold.txt > ${CORPUS}/eval.baselinesyll0.5.txt

#statistics
#wordseg-stats ${CORPUS}/stat_corpus.txt -o  ${CORPUS}/descript_statssamesize.txt 
#wordseg-stats ${CORPUS}/stat_corpus.txt -o  ${CORPUS}/descript_statsothersize.txt

#done

