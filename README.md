# Genome-assembly-and-taxonomic-clean-up
#main assembler is Spades https://github.com/ablab/spades


#this repository includes scripts used for looking at sequence quality, genome assemby, creating assembly stats, as well as taxonomic assignment, vizualization, and clean up of contminants

#general pipeline, sequencing stats(fastQC/MultiQC), Spades (initial assembly)-> mapping of trimmed reads to assembled genome (samtools) -> taxonomic assignment of reads (megaBLAST) -> vizualization (Blobtools2)
-> removal of contaminates (Bamfilter) -> Reassembly of filtered reads (Spades) -> extraction of sequences of intrest (pathracer/exonerate).

