#this script will run pick_otus.py on a fasta input file
#first input is fasta
#second input is low percent similary cutoff
#thir input is upper percent sim cutoff

#save lower and upper %sim cutoffs as variables
low=$2
high=$3

#get input file name
file=`awk 'END{print FILENAME}' $1 | awk 'BEGIN{FS="."} {print $1}'`

#loop qiime's pick_otus.py script to produce otu tables
for((i=$low;i<$high;i++));do
	pick_otus.py -i $1 -o otus_$i/ -s 0.$i
	mv otus_$i/*_otus.txt otus_$i/${file}_${i}_otus.txt
done

#the loop makes a mistake when running %sim 100 since input is decimal format
#correct by running high $sim cutoff out of the loop
if [ $high -eq 100 ];then
	pick_otus.py -i $1 -o otus_100/ -s 1
	mv otus_100/*otus.txt otus_100/${file}_100_otus.txt

else
	pick_otus.py -i $1 -o otus_$high/ -s 0.$high
        mv otus_$high/*_otus.txt otus_$high/${file}_${high}_otus.txt
fi
