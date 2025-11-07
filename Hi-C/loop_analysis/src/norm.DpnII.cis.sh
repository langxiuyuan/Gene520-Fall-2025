#!/bin/bash


lib=/mnt/rds/genetics01/JinLab/xww/HiCorr/src
ref=/mnt/rds/genetics01/JinLab/xww/HiCorr/references

name=$1
genome=$2
anchorbed=$ref/${genome}_DpnII_anchors_avg.bed

$lib/fragdata_to_anchordata.pl frag_loop.$name $ref/${genome}_DpnII_frag_2_anchor | python $lib/get_dist.py $anchorbed | $lib/remove.blacklist.py $ref/${genome}_5kb_anchors_blacklist > end_loop.cis.rmbl &

wait

cat end_loop.cis.rmbl | awk '{if($4<=2000000) print $0}' > end_loop.2M.rmbl &
cat end_loop.cis.rmbl | awk '{if($4>2000000) print $0}' > end_loop.gt.2M &

wait

$lib/merge_sorted_anchor_loop.pl $ref/${genome}_full_filtered_matrix end_loop.2M.rmbl > end_loop.full &
wait

$lib/get_group_statistics.pl end_loop.full $anchorbed $ref/${genome}_anchor_length.groups $ref/${genome}.dist.401.group > dist.len.stat &

wait

$lib/get_loop_lambda.pl end_loop.full $anchorbed $ref/${genome}_anchor_length.groups $ref/${genome}.dist.401.group dist.len.stat > end_loop.after.dist.len &
wait
exit
