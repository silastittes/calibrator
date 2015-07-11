#first input is fasta, count how many lines a species level name appears on in a otu.txt file
#get infile name for searching otu tables
#2nd and 3rd inputs are sim cutoffs
file=`awk 'END{print FILENAME}' $1 | awk 'BEGIN{FS="."} {print $1}'`
> ${file}_Underclustered.csv


speciesArray=(`cat speciesNames | sort | uniq`)
speciesLength=${#speciesArray[@]}

echo "sim,species,count" >> ${file}_Underclustered.csv
for (( j=$2; j<=$3; j++ ));do

	sim=`echo "otus_${j}/${file}_${j}_otus.txt"`
	echo "sim is $sim"
	count=()	
	for ((i=0; i<$speciesLength; i++));do
		currentSpecies=${speciesArray[$i]}
		appear=`grep -c $currentSpecies $sim`
		#search for species in the second input file 
		count+=($appear)
		echo -e "$j,$currentSpecies,${count[$i]}" >> ${file}_Underclustered.csv
	done
done

