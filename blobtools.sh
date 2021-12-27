#!/bin/bash

####==========================================================================
#----------------------------------Blobtools qc-------------------------------
####==========================================================================
#to run in spades assemblies directory:
#for dir in */; do echo ${dir}; cd ${dir}; pwd; /home/abradshaw/scripts_alex/working/blobtools/blobtools.sh ; cd ..; pwd; done

#NOTE: I edited the blobtools script directly so include "Kingdom" as a taxonomic variable, making this script custom. 
#each command will work individually, however the kingdom setting will error out if not called from my personal conda installation
#Reads the name of the directory and assigns it the variable "result"
result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

echo \
"TAGC content chart [blob tools]"

[ -d Blobtools_charts ] || mkdir Blobtools_charts

/home/abradshaw/miniconda3/bin/blobtools create \
-i ./*contigs.fasta \
-b $result.sorted.bam \
-t $result.nt.1e-??.megablast.out \
-x bestsumorder \
-o ./Blobtools_charts/$result && \

/home/abradshaw/miniconda3/bin/blobtools view \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r all \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r superkingdom \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r phylum \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r order \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r family \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r genus \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r species \
-o ./Blobtools_charts/ && \

/home/abradshaw/miniconda3/bin/blobtools plot \
-i ./Blobtools_charts/*.blobDB.json \
-x bestsumorder \
-r kingdom \
-o ./Blobtools_charts/

echo \
"blobtools files placed in Blobtools_charts"

echo \
"---------DONE----------"

exit 0
