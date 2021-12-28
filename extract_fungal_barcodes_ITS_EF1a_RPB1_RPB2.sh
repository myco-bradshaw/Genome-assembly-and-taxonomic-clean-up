#!/bin/bash
#to run in directory of assemblies
#for dir in */; do echo ${dir}; cd ${dir}; pwd; /home/abradshaw/scripts_alex/working/ALL.PATHRACER.BARCODES.fiexed.sh; cd ..; done

#provides name for curent directory and sets variable to $result
#this allows you to assign the directory name as a variable for file names, extreamly useful for loops
result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

#Use pathracer with hidden markov model derived from all fungal ITS from AFTOL
echo \
"ITS 5.8s analysis"
echo "================================================================================================================================================================="

echo \
"Pathracer for fungal ITS 5.8"
/home/abradshaw/SPAdes-3.15.0-pathracer-2020-12-20-dev/bin/pathracer /home/abradshaw/HMM/Fungi.5.8S.hmm *_scaffolds.gfa --output ./pathracer_ITS_5.8s

#give headers human usable names
sed -i "s/>/>$result|/g" ./pathracer_ITS_5.8s/*edges.fa


#Run ITSx to cleanup and make output manageable
echo \
"Running ITSx on ITS pathracer edge sequences"
ITSx -i ./pathracer_ITS_5.8s/*edges.fa -t F --cpu 12 -o ./pathracer_ITS_5.8s/$result


#Use pathracer to genreate edges, and exonerate to extract barcode from edge sequences
#currently works for EF1a, RPB1, RPB2

echo \
"EF1-a analysis"
echo "=================================================================================================================================================================="

#pathracer for ef1a exons conserved
/home/abradshaw/SPAdes-3.15.0-pathracer-2020-12-20-dev/bin/pathracer /home/abradshaw/HMM/agaricomycotina_exon_conserved_Ef1a.hmm *_scaffolds.gfa --output pathracer_ef1a

#run exonerate to get clean sequences
/home/abradshaw/ExtractHomologs2.ef1a.sh


echo \
"RPB-2 analysis"
echo "==================================================================================================================================================================="

#pathracer for RPB2 nucleotides
/home/abradshaw/SPAdes-3.15.0-pathracer-2020-12-20-dev/bin/pathracer  /home/abradshaw/HMM/agaricomycotina_exon_conserved_RPB2.hmm *_scaffolds.gfa --output ./pathracer_RPB2_exon_conserved


#run exonerate to get clean sequences
/home/abradshaw/ExtractHomologs2.RPB2.sh


echo \
"RPB-1 analysis"
echo "===================================================================================================================================================================="

#pathracer for RPB1 amino acids
/home/abradshaw/SPAdes-3.15.0-pathracer-2020-12-20-dev/bin/pathracer  /home/abradshaw/HMM/RPB1-fasta-trimmed.selection.aa.hmm *_scaffolds.gfa --output pathracer_RPB1

#run exonerate for clean sequences
/home/abradshaw/ExtractHomologs2.RPB1.sh


#use these commands to concatenate all barcodes from each directory into a single file for analysis
#echo \
#"Creating fasta file with results in parent directory"
#echo "======================================================================================================================================================================="

#mkdir concatenated_barcodes

#echo "Combining ITS results"
#cat -- */pathracer_ITS_5.8s/*.full.fasta > concatenated_barcodes/all.ITSx.full.fasta
#cat -- */pathracer_ITS_5.8s/*.ITS1.fasta > concatenated_barcodes/all.ITSx.ITS1.fasta
#cat -- */pathracer_ITS_5.8s/*.ITS2.fasta > concatenated_barcodes/all.ITSx.ITS2.fasta

#echo "RPB1"
#cat -- */exonerate_results/*_exonerate/*RPB1 > concatenated_barcodes/all.RPB1.fasta

#echo "RPB2"
#cat -- */exonerate_results/*_exonerate/*RPB2 > concatenated_barcodes/all.RPB2.fasta

#echo "EF1a"
#cat -- */exonerate_results/*_exonerate/*EF1A > concatenated_barcodes/all.EF1a.fasta



exit 0
