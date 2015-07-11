#filter infile by length
#first input is fasta
#second is min sequence length
#third is max sequence length

awk -v min=$2 -v max=$3 '$1 ~ /^>/ {print $0} $1 !~ /^>/ {if (length($0) >= min && length($0) <= max) print $0}' $1 | grep -B1 ^[ATGC] | sed '/^--$/d'
