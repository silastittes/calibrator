#get how many unique species names appear in each otu group.
#File containing species names should be "speciesNames" formatted "Genus_species"
#2nd and 3rd inputs are sim cutoffs
file=`awk 'END{print FILENAME}' $1 | awk 'BEGIN{FS="."} {print $1}'`
> ${file}_Overclustered.csv
echo "sim,otu,count" >> ${file}_Overclustered.csv

#loop through all otus directories
for ((i=$2; i<=$3; i++));do 

denovos=`awk '{print $1}' otus_${i}/${file}_${i}_otus.txt` 
deArray=($denovos)
deLength=${#deArray[@]}


for((j=0;j<$deLength;j++));do
	grep -G ${deArray[$j]}$'\t' otus_${i}/${file}_${i}_otus.txt > temp
	numCluster=`grep -oFf speciesNames temp | sort | uniq | wc -l`
		if [ $numCluster -ne 0  ];then
		echo -e "${i},${deArray[$j]},$numCluster" >> ${file}_Overclustered.csv
		fi
	rm temp
	
done
done

