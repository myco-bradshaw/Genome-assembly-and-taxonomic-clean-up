#!/bin/bash

####==========================================================================
#### STEP 1 - Quality Control [FastQC & MultiQC]
####==========================================================================

#run in the directory with all fastQ reads with commoand ~/path/to/this/script/
#/home/abradshaw/scripts_alex/working/FASTQC_MULTIQC_LOOP.sh

mkdir FASTQCresults

output=./FASTQCresults/

for file in ./*.fastq.gz
do
fastqc -f fastq -o ${output} ${file}
done

output=./FASTQCresults/

for file in ./*.fq.gz
do
fastqc -f fastq -o ${output} ${file}
done

####==========================================================================
#--------------------------------MULTIQC-------------------------------
####==========================================================================

#run multiQC

cd FASTQCresults/
mkdir MULTIQCresults
output=./MULTIQCresults/
multiqc ./ -o MULTIQCresults/

exit 0
