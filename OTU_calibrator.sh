#This script runs all other scripts that will (eventually) output a percent similarity cutoff that best defines species based on known individuals
#There are defaults and inputs

#DEFAULTS, MAKE SURE YOU EDIT!!!!!
#percent similarity cutoffs to be used in qiimeLoop.sh
simLow=80
simHigh=100

#the largest and smallest acceptable sequence lengths
lenLow=100
lenHigh=4000

#positional inputs
#first input is fasta file
#second input is file that contains all the species names of interest
#save inputs for readability
fasta=$1
if [[ $2 != speciesNames  ]];then
cat $2 > speciesNames
fi

#get fasta file name
file=`awk 'END{print FILENAME}' $1 | awk 'BEGIN{FS="."} {print $1}'`

#unwrap fasta and reformated headers, save to new file
bash fastaCorrect.sh $1 > ${file}_unwrapped.fa

echo "s1"

#keep sequences within specified length
bash getLongSeqs.sh ${file}_unwrapped.fa $lenLow $lenHigh > ${file}_length.fa
echo "s2"

#keep only sequences that have one of the uder specified species names in the header 
bash keepSpecies.sh ${file}_length.fa > ${file}_species.fa
echo "s3"
#qiime time
#make otu table for each similarity cutoff
bash qiimeLoop.sh ${file}_species.fa $simLow $simHigh

echo "s4"

#Make over and under clustered files
bash countSpecies.sh ${file}_species.fa $simLow $simHigh

echo "s5"

bash speciesClustering.sh ${file}_species.fa $simLow $simHigh

echo "s6"

Rscript OTU_calibration.R ${file}_species_Overclustered.csv ${file}_species_Underclustered.csv

