#script will filter fasta file, only keeping sequences that contain one the species names that have been specified by the user
#in the speciesNames file

#input is unwrapped fasta file, preferably one that has had been filtered by sequence length using getLongSeqs.sh

#make array of species names of interest and get length
spArray=(`cat speciesNames`)
spLength=${#spArray[@]}
#echo ${spArray[@]}

#loop over species names, search each species names to see if it appears in the input file
for(( i=0; i<$spLength; i++ ));do
	cSp=${spArray[$i]} 
	grep -A1 $cSp $1 | sed '/^--$/d'
done
