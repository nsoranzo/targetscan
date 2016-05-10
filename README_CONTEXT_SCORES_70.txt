INTRODUCTION

The Perl script targetscan_70_context_scores.pl calculates context++ scores for a set of miRNA targets predicted by targetscan_70.pl
and further processed by targetscan_70_BL_PCT.pl.  Both of these steps must precede context++ score calculation.
The TargetScan 7.0 context++ score code produces essentially the same output as displayed at TargetScanHuman Release 7.0 at TargetScan.org.  

The script takes several input files
	* with names specified in one's command:
		1) a miRNA file: a tab-delimited text file of mature miRNA information.  This is different from the file required by targetscan_70.pl.
			(sample file: "test/input/miR_for_context_scores.sample.txt")
		2) a UTR file: a tab-delimited multiple sequence alignment of the 3' UTRs of genes from the desired species
			which is the same as the input file for targetscan_70.pl.
			(sample file: "test/input/UTR_Sequences_sample.txt")
		3) a predicted targets file with BLSs and PCTs: output from targetscan_70_BL_PCT.pl.
			(sample file: "test/output/targetscan_70_output.BL_PCT.txt")
		4) ORF lengths file (for ORFs matching 3' UTRs in UTR_file): contains the length of each ORF corresponding to aligned 3' UTRs
			This needs to be created before running this script.
			(sample file: "test/output/ORF_Sequences_sample.lengths.txt")
		5) ORF 8mer counts file: contains the number of 8mer sites in ORFs of file (4)
			This needs to be created before running this script.
			(sample file: "test/output/ORF_8mer_counts_sample.txt")
		6) UTR profiles file: contains AIRs for each region of each 3' UTR
		    (sample file: "test/input/All_cell_lines.AIRs.txt")
	* with names hard-coded in the analysis script
		7) "TA_SPS_by_seed_region.txt": contains TA and SPS parameters for each seed region
		8) "Agarwal_2015_parameters.txt": with model parameters to calculate context++ score contributions

In this directory we provide samples of all of the above files.


OTHER DEPENDENCIES

1) The script requires another application to be pre-installed):
	RNAplfold (from the ViennaRNA Package 2 -- http://www.tbi.univie.ac.at/RNA/documentation.html)
	If it is not, the script will run, but the site accessibility contribution will be ignored (set to 0).

	We have included RNAplfold output files in "RNAplfold_in_out" for the sample 3' UTRs.

2) Since context++ scores depend on the ORF sequence that matches each 3' UTR, we need to create and analyze an ORF file.
	ORF sequences corresponding to each 3' UTR file can be obtained from TargetScan (http://www.targetscan.org/vert_70/vert_70_data_download/ORF_Sequences.txt.zip)
	The ORF file should have the same format as the 3' UTR file (3 tab-delimited fields: sequence ID, species ID, sequence).
	The ORF sequences can be aligned (with gaps) or not, but the alignment is ignored; gaps are removed.
	Run this command on the ORF file (to get the ORF lengths and count 8mer sites)
		./targetscan_count_8mers.pl test/input/miR_Family_info_sample.txt test/input/ORF_Sequences_sample.txt > ORF_8mer_counts_sample.txt
	After this command, the ORF lengths will be in a file inside the same directory of the ORF file, e.g. test/input/ORF_Sequences_sample.lengths.txt .
	Both output files are needed to run targetscan_70_context_scores.pl
	Note that we have included sample input and output files for this step.


FILE FORMATS

The format of the input files is important for the script to work correctly. 

miRNA mature sequence file (ex: test/input/miR_for_context_scores.sample.txt) -- each line consists of 4 tab separated entries:
1) miRNA family ID: Name of the miRNA family
2) Species ID of this miRNA family (which should match species IDs in the UTR and predicted targets input files)
3) MiRBase ID: name of a mature miRNA sequence
4) Mature sequence: sequence of mature miRNA

"miR Family" file -- To generate a file in this format from the complete data (miR_Family_Info.txt from the table 
on the Data Download page), run this command:
cut -f1,3,4,5 miR_Family_Info.txt > miR_for_context_scores.txt

Each line of the UTR alignment file (ex: test/input/UTR_Sequences_sample.txt) consists of 3 tab separated entries
1) Gene symbol or transcript ID
2) Species ID (which should match species IDs in miRNA input file) 
3) Sequence 

To generate a file in this format from the complete "UTR Sequences" file (UTR_Sequences.txt from the table 
on the Data Download page), run this command:
cut -f1,4,5 UTR_Sequences.txt > UTR_Sequences_sample.txt

ORF lengths and ORF 8mer counts files can be created with the command under (2) in "OTHER DEPENDENCIES".

"UTR profiles" file (ex: "test/input/All_cell_lines.AIRs.txt") -- contains sample data for the sample 3' UTRs.
The complete file (used by Agarwal et al.) is included in the "3P-seq tag info" zip archive
on http://www.targetscan.org/cgi-bin/targetscan/data_download.cgi?db=vert_70
Only the first 4 columns are needed.

Two files have names that are hard-coded in the script:
	"TA_SPS_by_seed_region.txt"
	"Agarwal_2015_parameters.txt"

Each line of the predicted targets file (ex: test/output/targetscan_70_output.BL_PCT.txt) consists of 13 tab separated entries
(although not all fields are required)
1)  GeneID - name/ID of gene (from UTR input file)
2)  miRNA family_ID - name/ID of miRNA family (from miRNA input file)
3)  species ID - name/ID of species (from UTR input file)
4)  MSA start - starting position of site in aligned UTR (counting gaps) 
5)  MSA end - ending position of site in aligned UTR (counting gaps) 
6)  UTR start - starting position of site in UTR (not counting gaps) 
7)  UTR end - ending position of site in UTR (not counting gaps) 
8)  Group ID - ID (number) of site(s) (same gene, same miRNA) that overlap 
9)  Site type - type of site in this species (1a [7mer-1a; type 1], m8 [7mer-m8; type 2], or 8mer [type 3])
10) miRNA in this species - if "x", then this miRNA has been annotated in this species
11) Group type - type of this group of sites; if 'Site_type' in a 'Group_ID' is heterogeneous, "weakest" type of the group is used
12) Branch length score - measure of site conservation 
13) Pct - value for broadly conserved miRNA families; others will appear as NA
14) Conserved?: x = conserved


EXECUTION

The script can be executed in 3 different ways:
1) Running the script without any arguments (./targetscan_70_context_scores.pl) will print out a help screen.
2) Running the script with the '-h' flag (./targetscan_70_context_scores.pl -h) will print out a formats of input files.
3) Running the script with input filenames and output file will perform the analysis. Ex:
	./targetscan_70_context_scores.pl test/input/miR_for_context_scores.sample.txt test/input/UTR_Sequences_sample.txt test/output/targetscan_70_output.BL_PCT.txt test/output/ORF_Sequences_sample.lengths.txt test/output/ORF_8mer_counts_sample.txt test/input/All_cell_lines.AIRs.txt Targets.BL_PCT.context_scores.txt

OUTPUT FILE

In the test/output/ folder there is a sample output file called "Targets.BL_PCT.context_scores.txt".
The output file also contain several tab separated entries per line.

The sample output file has a headers that names each column:
1)  Gene ID - name/ID of gene (from UTR input file)
2)  Species ID - name/ID of species (from UTR input file)
3)  Mirbase ID - name of a mature miRNA sequence
4)  Site Type - type of site in this species (1a [7mer-1a; type 1], m8 [7mer-m8; type 2], or 8mer [type 3])
5)  UTR start - starting position of site in UTR (not counting gaps) 
6)  UTR end - ending position of site in UTR (not counting gaps) 
7)  Site type contribution        |
8)  3' pairing contribution		  |
9)  local AU contribution		  |
10) Min_dist contribution		  |
11) sRNA1A contribution			  |
12) sRNA1C contribution			  |
13)	sRNA1G contribution			  |
14) sRNA8A contribution			  |
15) sRNA8C contribution			  |
16) sRNA8G contribution			  |  See Agarwal at el. for descriptions of the contributions
17) site8A contribution			  |
18) site8C contribution			  |
19) site8G contribution			  |
20) 3'UTR length contribution	  |
21) SA contribution				  |
22) ORF length contribution		  |
23) ORF 8mer contribution		  |
24) Offset 6mer contribution	  |
25) TA contribution				  |
26) SPS contribution			  |
27) PCT contribution			  |
28) context++ score - the sum of the contribution of the above features
29) context++ score percentile - percentage of sites for this miRNA with a less favorable context++ score
30) AIR - Affected isoform ratio; fraction of transcripts with this stop site containing this site
31) weighted context++ score - the sum of the contribution of the above features, taking the AIR into account
32) weighted context++ score percentile - percentage of sites for this miRNA with a less favorable weighted context++ score
33) UTR region - subsequence of UTR used to show predicted consequential pairing
34) UTR-miRNA pairing - predicted consequential pairing of target region and miRNA; complementary bases indicated by bars
35) mature miRNA sequence - mature sequence of this Mirbase ID
36) miRNA family - name/ID of miRNA family
37) Group # - ID (number) of site(s) (same gene, same miRNA) that overlap 

Note that a less verbose output (without the individual contributions) can be created by editing the script and changing the line
$PRINT_CS_CONTRIBUTIONS = 1;      to      $PRINT_CS_CONTRIBUTIONS = 0;


NOTES

This script was designed on a Linux platform. While running this script on Windows or Mac platforms, make sure to call the native perl binary. 
This can be done explicitly by executing it as 'perl targetscan_70_context_scores.pl' or changing the first line of the script to point to the native binary.
All input files should have Unix end-of-line characters.

UPDATE (March 25, 2016): The script targetscan_70_context_scores.pl was updated to correct errors in the calculations of the ORF 8mer and offset 6mer contributions.
Note that these errors were not present in the code used to calculate context++ scores for TargetScan.org.


QUESTIONS/SUGGESTIONS:

Please direct all correpondence to wibr-bioinformatics@wi.mit.edu

