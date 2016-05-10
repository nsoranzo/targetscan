INTRODUCTION

The Perl script targetscan_70.pl identifies miRNA targets and then determines whether a given target is conserved or not across a given set of species. 
The TargetScan 7.0 prediction code produces essentially the same output as the previous version (targetscan_60.pl)
except in the way that a group of heterogeneous aligned sites (combinations of at least two of the three site types) is classified,
TargetScan 7.0 defines a "group type" in these cases to be a combination of site types, which allows subgrouping by species that share the same site type. 

The script takes two input files
	1) A tab-delimited file that lists the miRNA seed sequences and the species in which they are present.
	2) A tab-delimited multiple sequence alignment of the 3' UTRs of genes from the desired species. 

In this directory we are providing samples of both the above files and the script uses them by default.

The sample files are: UTR_sequences_sample.txt and miR_Family_info_sample.txt
If you wish to generate these files from the complete data available for download, 
	run the commands shown below to convert them to the correct format:


FILE FORMATS

The format of the input files is important for the script to work correctly. 

Each line of the miRNA seed sequence file consists of 3 tab separated entries
1) Name of the miRNA family
2) The 7 nucleotide long seed region sequence.
3) List (semicolon-delimited) of Species IDs of this miRNA family (which should match species IDs in UTR input file)

Each line of the alignment file consists of 3 tab separated entries
1) Gene symbol or transcript ID
2) Species/taxonomy ID (which should match species IDs in miRNA input file) 
3) Sequence: all uppercase except for regions that overlap an ORF (which will be flagged as such and ignored for subsequent PCT calculation)

If you wish to generate this files from the complete data available by download, 
	run these commands to convert it to the correct format (and without a header):
sed '1,1d' UTR_Sequences.txt | cut -f1,4,5 > UTR_sequences_all.txt


EXECUTION

The script can be executed in 3 different ways:
1) Running the script without any arguments (./targetscan_70.pl) will print out a help screen.
1) Running the script without the '-h' flag (./targetscan_70.pl -h) will print out a formats of input files.
2) Running the script with input filenames and output file will perform the analysis. Ex:
	./targetscan_70.pl miR_Family_info_sample.txt UTR_Sequences_sample.txt targetscan_70_output.txt

OUTPUT FILES

In this folder is a sample output file called "targetscan_70_output.txt".
The output file contains several tab separated entries per line:

	The sample output file has a headers that names each column
	GeneID - name/ID of gene (from UTR input file)
	miRNA_family_ID - name/ID of miRNA family (from miRNA input file)
	species_ID - name/ID of species (from UTR input file)
	MSA_start - starting position of site in aligned UTR (counting gaps) 
	MSA_end - ending position of site in aligned UTR (counting gaps) 
	UTR_start - starting position of site in UTR (not counting gaps) 
	UTR_end - ending position of site in UTR (not counting gaps) 
	Group_ID - ID (number) of site(s) (same gene, same miRNA) that overlap 
	Site_type - type of site in this species (m8 [7mer-m8], 1a [7mer-1A], or m8:1a [8mer])
	miRNA in this species - if "x", then this miRNA has been annotated in this species
	Group_type - type of this group of sites; if 'Site_type' in a 'Group_ID' is heterogeneous, "weakest" type of the group is used
	Species_in_this_group - list of species names/IDs in which this site is found
	Species_in_this_group_with_this_site_type - for hetergeneous groups only
	ORF_overlap - If site in the UTR sequence is lowercase (indicating ORF overlap), this will be set to 1.  Typical UTR sites have a value of 0.

NOTES

This script was designed on a Linux platform. While running this script on Windows or Mac platforms, make sure to call the native perl binary. 


QUESTIONS/SUGGESTIONS:

Please direct all correspondence to wibr-bioinformatics@wi.mit.edu

