# Genome-assembly-and-taxonomic-clean-up
#main assembler is Spades https://github.com/ablab/spades


#this repository includes scripts used for looking at sequence quality, genome assemby, creating assembly stats, as well as taxonomic assignment, vizualization, and clean up of contminants

#general pipeline, sequencing stats(fastQC/MultiQC), Spades (initial assembly)-> mapping and indexing of trimmed reads to assembled genome (Bowtie2 and samtools) -> taxonomic assignment of contigs (blastn) -> vizualization (Blobtools2) -> removal of specific contaminates and low coverage contigs (Bamfilter) -> Reassembly of filtered reads (Spades) -> extraction of sequences of intrest (pathracer/exonerate).
