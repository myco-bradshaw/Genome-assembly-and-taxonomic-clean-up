#!/bin/bash

####=========================================================================================
#### Taxonomic assignment of contigs [Megablast], Mapping and indexing [bowtie2], [samtools] 
####==========================================================================================

#to create a parrallel command to run mapping on 5 genome directories at a time
#mkdir parallel_commands
#for dir in */;
#do
#echo "cd ${dir}; pwd; /home/abradshaw/scripts_alex/working/mapping.megablastDB.sh" >> parallel_commands/commands.mapping.txt
#done
#parallel --jobs 4 --compress -tmp /home/abradshaw/tmp --bar < parallel_commands/commands.mapping.txt

#or

#to run loop across all spade assemblies in a single directory, run in the Spades_assemblies directory
#to run loop
#for dir in */; do echo ${dir}; cd ${dir}; pwd; /home/abradshaw/scripts_alex/working/mapping.megablastDB.sh; cd ..; pwd; done

####==========================================================================
#-------------------------GENERAL CONFIG VARIABLES-----------------------------
####==========================================================================


## Num of processors. Or, uncomment the line below and enter manually.

NUMPROC=`grep "^processor" /proc/cpuinfo | tail -n 1 | awk '{print $3}'`
#NUMPROC=16
## Location of local installation of nt blast database
## (not needed if using blast remotely, which is slower).
## The NCBI nt databases can be downloaded from
## ftp://ftp.ncbi.nlm.nih.gov/blast/db/ using the following command:

#wget "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.*.tar.gz"
#for a in nt.*.tar.gz; do tar xzf $a; done

BLASTDB=/home/bdentinger/blobology/nt

## Location of NCBI tar gunzipped directory downloaded from
## ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz

## Default: current directory
TAXDUMP=/home/bdentinger/blobology/taxdump

#provides name for curent directory and sets variable to $result
#this allows you to assign the directory name as a variable for file names, extreamly useful for loops
result=${PWD##*/}
printf '%s\n' "${PWD##*/}"


####==========================================================================
#-----------------------provide assembly fasta file---------------------------
####==========================================================================

## If providing own assembly fasta file
ASSEMBLY=*contigs.fasta

####==========================================================================
#------------find best blast hits of a random sample of contigs----------------
####==========================================================================

echo \
"blastn querry for contig file"

blastn \
-query $ASSEMBLY \
-db $BLASTDB/nt \
-evalue 1e-10 \
-num_threads $NUMPROC \
-max_target_seqs 10 \
-max_hsps 1 \
-outfmt '6 qseqid staxids bitscore std' \
-out $result.nt.1e-10.megablast.out




####==========================================================================
#-----------------map reads back to assembly using bowtie2---------------------
####==========================================================================
echo \
"mapping and indexing reads with [bowtie2] and [samtools]"

bowtie2-build $ASSEMBLY $ASSEMBLY

#change this to the path of your trimmed reads
for LIBNAME in /home/abradshaw/19307R/Fastq/Alex/trimmed/${result}_trimmed
do
    echo $LIBNAME
    bowtie2 -x $ASSEMBLY -p $NUMPROC --reorder \
        -1 <(zcat ${LIBNAME}.1.fastq.gz) -2 <(zcat ${LIBNAME}.2.fastq.gz) -S $result.sam && \
samtools view -S -b  $result.sam > $result.bowtie2.bam && \
samtools sort -o $result.sorted.bam $result.bowtie2.bam && \
samtools index $result.sorted.bam
done

exit 0

