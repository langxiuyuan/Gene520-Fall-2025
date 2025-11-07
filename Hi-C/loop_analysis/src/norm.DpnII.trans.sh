#!/bin/bash



lib=/mnt/rds/genetics01/JinLab/xww/for_xiaoxiao/HiCorr/src
ref=/mnt/rds/genetics01/JinLab/xww/for_xiaoxiao/HiCorr/references

name=$1
genome=$2

anchorbed=$ref/${genome}_DpnII_anchors_avg.bed

#$lib/frag.2.anchor.py $ref/${genome}_DpnII_frag_2_anchor $anchorbed frag_loop.$name.trans > end_loop.trans&
#$lib/fragdata_to_anchordata.pl frag_loop.$name.trans $ref/${genome}_DpnII_frag_2_anchor > end_loop.trans &
#wait

cat end_loop.trans | $lib/remove.blacklist.py $ref/${genome}_5kb_anchors_blacklist > end_loop.rmbl.trans &

wait

$lib/get_trans.avg_by_len.pl end_loop.rmbl.trans $ref/${genome}_anchor_length.groups $anchorbed $ref/${genome}.trans.possible.pairs > trans.stat &

wait

$lib/get_corr_factor_by_len.py trans.stat > len.factor &

wait

$lib/correct.trans.reads.by.corr.pl end_loop.rmbl.trans $anchorbed $ref/${genome}_anchor_length.groups len.factor > trans.corr.by.all &

wait

$lib/sum_anchor_reads.py trans.corr.by.all > anchors.sum &

wait

