#!/bin/bash

genome=hg19
enzyme=arima
cis=./processed_frag/frag_loop.human_Beta_cells.cis.filter  #frag.cis.filtered
trans=./processed_frag/frag_loop.human_Beta_cells.trans # frag.trans
expt=human_Beta_cells

lib=./src
ref=/mnt/pan/courses/gene520/Hi-C/ref/Arima_ref
anchorbed=$ref/${genome}_arima_anchors_avg.bed # anchor_5kb_bed
blacklist=$ref/${genome}_5kb_anchors_blacklist # 5kb blacklist
frag_2_anchor=/mnt/vstor/courses/gene520/Hi-C/ref/hg19_GATC_GANTC/frag.2.anchor


# Assign frag to anchor
cat $cis |  $lib/fragdata_to_anchordata.pl - $ref/${genome}_arima_frag_2_anchor | python3 $lib/get_dist.py $anchorbed | python3 $lib/remove.blacklist.py $ref/${genome}_5kb_anchors_blacklist > ${expt}_end_loop.cis.rmbl
cat $trans |  $lib/fragdata_to_anchordata.pl - $ref/${genome}_arima_frag_2_anchor | $lib/remove.blacklist.py $ref/${genome}_5kb_anchors_blacklist  > ${expt}_end_loop.rmbl.trans

# generate .hic file
$lib/merge_sorted_anchor_loop.pl ${expt}_end_loop.cis.rmbl ${expt}_end_loop.rmbl.trans > ${expt}.merged.raw.cis.trans
wait

cat ${expt}.merged.raw.cis.trans | python3 $lib/to_pre_python3.py $anchorbed | sort -k2,2d -k6,6d > ${expt}.merged.raw.pre
wait

java -jar /mnt/vstor/courses/gene520/Hi-C/software/juicer/CPU/common/juicer_tools.1.9.9_jcuda.0.8.jar pre -k KR ${expt}.merged.raw.pre ${expt}.hic hg19

