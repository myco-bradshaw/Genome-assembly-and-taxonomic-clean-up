#!/bin/bash

####==========================================================================
#---------------------------MAKE ANALYSIS DIRECTORIES--------------------------
####==========================================================================

#to use parallel
#for dir in */; do echo "cd ${dir}; /home/abradshaw/scripts_alex/working/FUNGI.95.COVERAGE.ALL.KMER.REASSEMBLY.FROM.BAMFILTER.sh" \
#>> ./parallel_commands/spades.bamfilter.commands.txt; done
#parallel --tmpdir /home/abradshaw/tmp_spades --jobs 4 --compress --bar <  ./parallel_commands/spades.bamfilter.commands.txt

#for dir in *; do echo ${dir}; cd ${dir}; pwd; ~/scripts_alex/working/FUNGI.95.COVERAGE.ALL.KMER.REASSEMBLY.FROM.BAMFILTER.sh; cd ..; pwd; done

#change filename=${fullname%%_*} to match the naming format of your files

#fullname=$(basename $1)
#filename1=${fullname%BASIDIO.ONLY.SEQS.?*}
#filename=${fullname%%BASIDIO.ONLY.SEQS.*}

#echo ${fullname}
#echo ${filename1}

#echo "your file name is:"
#echo ${filename}


#Reads the name of the directory and assigns it the variable "result"
result=${PWD##*/}
printf '%s\n' "${PWD##*/}"


[ -d $result-FUNGI_95_all_kmer_Spades_assembly] || mkdir $result-FUNGI_95_all_kmer_Spades_assembly



####==========================================================================
#----------------------------------ASSEMBLY------------------------------------
####==========================================================================


python /home/abradshaw/miniconda3/bin/spades.py --pe1-12 ./FUNGI.NOHIT.95.SEQS.$result.sorted.bam.InIn.fq.gz \
-t 42 --careful -m 750 \
-k 21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127 \
-o ./$result-FUNGI_95_all_kmer_Spades_assembly

exit 0
