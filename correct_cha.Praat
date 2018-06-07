folder$="/Users/alejandrinacristia/habilis_backup/PROJECTS/2-inprogress/ANR_French/Data_LYON_LENA_/Ggust/"
coder$="ac"
Create Strings as file list... txts 'folder$'*.cha.txt
ntxt=Get number of strings

for j to ntxt
	select Strings txts
	t$=Get string... 'j'
	t$=t$-".cha.txt"
	if !fileReadable("'folder$''t$'.TextGrid")
		Read Table from tab-separated file... 'folder$''t$'.cha.txt
		Rename... 't$'
		Read from file... 'folder$'media/'t$'.wav
		Create Table with column names: "tiers", 0, "tiername tiernumber"
		Read Strings from raw text file... 'folder$''t$'.cha.ppnt
		Rename... 't$'
		ntalkers=Get number of strings
		all$=""
		for k to ntalkers
			select Strings 't$'
			ppnt$=Get string... 'k'
			all$= all$  + ppnt$ + " "
			select Table tiers
			Append row
			Set string value: 'k', "tiername", "'ppnt$'"
			Set numeric value: 'k', "tiernumber", 'k'
		endfor
	
		select Sound 't$'
		do ("To TextGrid...", "'all$'", "")

		select Table 't$'
		nrows=Get number of rows
print 'nrows'
		for k to nrows
			select Table 't$'
			tier$=Get value... 'k' p
			phrase$=Get value... 'k' phrase
			on=Get value... 'k' on
			off=Get value... 'k' off

			select Table tiers
			labnum=Search column: "tiername", "'tier$'"
			tiernum=Get value... 'labnum' tiernumber

#pause 'k' 'on' 'off' 'phrase$' 
			select TextGrid 't$'
			nowarn nocheck Insert boundary: 'tiernum', 'on'/1000
			nowarn nocheck Insert boundary: 'tiernum', 'off'/1000
			intnum=Get interval at time: 'tiernum', (('on'+'off')/2)/1000
			Set interval text: 'tiernum', 'intnum', "'phrase$'"
		endfor

		select TextGrid 't$'
		plus Sound 't$'
		View & Edit
		editor TextGrid 't$'
		Add interval tier... 3 addressee
			pause please correct all intervals
		endeditor

		select TextGrid 't$'
		Save as text file... 'folder$''t$'.TextGrid
		select all
		minus Strings txts
		Remove
	endif
endfor
clearinfo
print all done

