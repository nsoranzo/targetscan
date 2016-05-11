#!/bin/sh
TT_DIR=$(dirname "$(readlink -f "$0")")
TT_TR_DIR=$TT_DIR/test/run
TT_TI_DIR=$TT_DIR/test/input
rm -rf "$TT_TR_DIR"
mkdir "$TT_TR_DIR"
cd "$TT_TR_DIR"
"$TT_DIR/targetscan_70.pl" "$TT_TI_DIR/miR_Family_info_sample.txt" "$TT_TI_DIR/UTR_Sequences_sample.txt" targetscan_70_output.txt
"$TT_DIR/targetscan_70_BL_bins.pl" "$TT_TI_DIR/UTR_Sequences_sample.txt" > UTRs_median_BLs_bins.txt
"$TT_DIR/targetscan_70_BL_PCT.pl" "$TT_TI_DIR/miR_Family_info_sample.txt" targetscan_70_output.txt UTRs_median_BLs_bins.txt > targetscan_70_output.BL_PCT.txt
ln -s "$TT_TI_DIR/ORF_Sequences_sample.txt"
"$TT_DIR/targetscan_count_8mers.pl" "$TT_TI_DIR/miR_Family_info_sample.txt" ORF_Sequences_sample.txt > ORF_8mer_counts_sample.txt
rm -f ORF_Sequences_sample.txt
"$TT_DIR/targetscan_70_context_scores.pl" "$TT_TI_DIR/miR_for_context_scores.sample.txt" "$TT_TI_DIR/UTR_Sequences_sample.txt" targetscan_70_output.BL_PCT.txt ORF_Sequences_sample.lengths.txt ORF_8mer_counts_sample.txt "$TT_TI_DIR/All_cell_lines.AIRs.txt" Targets.BL_PCT.context_scores.txt
diff -qr -x RNAplfold_in_out . "$TT_DIR/test/output/"
