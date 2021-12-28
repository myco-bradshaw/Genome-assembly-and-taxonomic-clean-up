#!/bin/bash

####==========================================================================
#--------------------------Filter for Basiomycete sequences-------------------
####==========================================================================

# to run in spades assemblies directory
#for dir in */; do echo ${dir}; cd ${dir}; pwd; /home/abradshaw/scripts_alex/working/bamfilter/BAMFILTER.FUNGI.NOHIT.COVERAGE.95.SEQS.sh ; cd ..; pwd; done

#Reads the name of the directory and assigns it the variable "result"
result=${PWD##*/}
printf '%s\n' "${PWD##*/}"
echo "your file name is:" $result

#this will search the table output from the ‘view’ command for contigs that hit Basidiomycota or no-hit
#(assuming these are probably from the target organism but aren’t represented in NCBI),
#extract the ID of those contigs, and print that to a file;
#N.B. the space in between the quotes in the cut command is a tab (achieved by Ctrl+V then tab)


grep -E -- 'Fungi|no-hit' ./Blobtools_charts/*.blobDB.table.txt | cut -f1 > $result.Fungi.nohit.seqids.txt


#This will search the taxonomy filterd table for coverage and create a seqid hits file that removes the lowest 5% coverage contigs.
cat $result.Fungi.nohit.seqids.txt | grep -v \# | cut -d'	' -f1 > ./Blobtools_charts/coverage.headers.txt

cat ./Blobtools_charts/coverage.headers.txt | sort -t_ -k5 -V -r > ./Blobtools_charts/coverage.headers.sorted.txt

echo $(($(cat ./Blobtools_charts/coverage.headers.sorted.txt | wc -l) - $(cat ./Blobtools_charts/coverage.headers.sorted.txt | wc -l)*1/20)) > ./Blobtools_charts/coverage.headers.sorted.95%.txt


perc=$(head ./Blobtools_charts/coverage.headers.sorted.95%.txt) && echo "$perc" | head -n$perc ./Blobtools_charts/coverage.headers.sorted.txt > $result.coverage.headers.sorted.95%.node.ids.txt

#this takes the seqIDs from the file generated above and extracts all paired end reads where at least one of the pair
#maps to them; see this for an explanation of the files that are generated from this command: https://blobtools.readme.io/docs/bamfilter

blobtools bamfilter -b *.sorted.bam -i $result.coverage.headers.sorted.95%.node.ids.txt -f fq --out FUNGI.NOHIT.95.SEQS

gzip -f *.ExIn.fq
gzip -f *.InIn.fq
gzip -f *.UnUn.fq

exit 0
