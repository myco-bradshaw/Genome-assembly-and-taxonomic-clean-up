#!/bin/bash

####==========================================================================
#### Genome Assembly [Spades] & Adapter Trimming [FASTP]
####==========================================================================

#To run, run this script in the directory of your raw reads
#for file in ./*_R1_001.fastq.gz; do /path/to/this/script.sh $file; done
#for file in ./*_R1_001.fastq.gz; do /home/abradshaw/scripts_alex/working/spades_genome_assembly/FASTP_SPADES_all_Kmer_fixed.sh $file; done

#to use parallel
#for file in *_R1_001.fastq.gz; do echo "/home/abradshaw/scripts_alex/working/spades_genome_assembly/FASTP_SPADES_all_Kmer_fixed.sh" $file >> spades.commands.txt; done
#parallel --tmpdir /home/abradshaw/tmp_spades --jobs 4 --compress --bar <  spades.commands.txt
####==========================================================================
#---------------------------DETERMINE FILE NAMES------------------------------
####==========================================================================
#change filename=${fullname%%_*} to match the naming format of your files

fullname=$(basename $1)
filename1=${fullname%_001.fastq.gz}
filename=${fullname%%_R*}

echo ${fullname}
echo ${filename1}

echo "your file name is:"
echo ${filename}


####==========================================================================
#--------------------------------ADAPTER REMOVAL-------------------------------
####==========================================================================
#use this if you would like to use adapter removal rather than fastP for adapter triming

#AdapterRemoval --threads 72 --file1 ./${filename}_pass_1.fastq.gz --file2 ./${filename}_pass_1.fastq.gz --qualitymax 45 --basename ${filename} --trimns --trimqualities --gzip


####==========================================================================
#---------------------------MAKE ANALYSIS DIRECTORIES--------------------------
####==========================================================================

[ -d Spades_assemblies_all_kmer ] || mkdir Spades_assemblies_all_kmer
[ -d trimmed ] || mkdir trimmed

####==========================================================================
#-------------------------------SPADES_ASSEMBLY-------------------------------
####==========================================================================


#This step automatically looks at the files within your directory and trims reads if they exist or moves directly to assmbly if reads are already trimmed


if  [ -f ./trimmed/${filename}_trimmed.1.fastq.gz ]
then
        echo "trimmed reads exist"
        python /home/abradshaw/miniconda3/bin/spades.py --pe1-1 ./trimmed/${filename}_trimmed.1.fastq.gz \
        --pe1-2 ./trimmed/${filename}_trimmed.2.fastq.gz \
        -t 36 --careful -m 750 \
        -k 21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127 \
        -o ./Spades_assemblies_all_kmer/${filename}
else
        echo "trimmed reads don't exist"
       /home/bdentinger/fastp -i ${filename}_R1*.fastq.gz -I ${filename}_R2*.fastq.gz -o ./trimmed/${filename}_trimmed.1.fastq.gz -O \
         ./trimmed/${filename}_trimmed.2.fastq.gz --detect_adapter_for_pe --thread 16
       python /home/abradshaw/miniconda3/bin/spades.py --pe1-1 ./trimmed/${filename}_trimmed.1.fastq.gz \
        --pe1-2 ./trimmed/${filename}_trimmed.2.fastq.gz \
        -t 36 --careful -m 750 \
        -k 21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127 \
        -o ./Spades_assemblies_all_kmer/${filename}
fi

#use if files have .fq instead of .fastq file extensions
#if  [ -f ./trimmed/${filename}_trimmed.1.fq.gz ]
#then                                                                                                                                                                                        echo "trimmed reads exist"
#        python /home/abradshaw/SPAdes-3.14.0-dev/bin/spades.py --pe1-1 ./trimmed/${filename}_trimmed.1.fq.gz \
#        --pe1-2 ./trimmed/${filename}_trimmed.2.fq.gz \
#        -t 36 --careful -m 750 \
#        -k 77,85,99,111,127 \
#        -o ./Spades_assemblies_all_kmer/${filename}
#else
#        echo "trimmed reads don't exist"
#       /home/bdentinger/fastp -i ${filename}_R1_001.fq.gz -I ${filename}_R2_001.fq.gz -o ./trimmed/${filename}_trimmed.1.fq.gz -O \
#         ./trimmed/${filename}_trimmed.2.fq.gz --detect_adapter_for_pe --thread 16
#       python /home/abradshaw/SPAdes-3.14.0-dev/bin/spades.py --pe1-1 ./trimmed/${filename}_trimmed.1.fq.gz \
#        --pe1-2 ./trimmed/${filename}_trimmed.2.fq.gz \
#        -t 36 --careful \
#        -k 21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127 \
#        -o ./Spades_assemblies_all_kmer/${filename}
#fi
echo \
"---------DONE----------"


exit 0
