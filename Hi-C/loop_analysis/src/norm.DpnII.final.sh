#!/bin/bash


lib=/mnt/rds/genetics01/JinLab/xww/for_xiaoxiao/HiCorr/src
ref=/mnt/rds/genetics01/JinLab/xww/for_xiaoxiao/HiCorr/references

name=$1
genome=$2

anchorbed=$ref/${genome}_DpnII_anchors_avg.bed

avg=`cat anchors.sum | awk '{s+=$2;n++}END{print s/n}'`

wait

cat anchors.sum | awk -v avg=$avg '{print $1,$2/avg}' OFS='\t'  > anchor.vis.list &

wait

$lib/add.vis.to.cis.2M.pl end_loop.after.dist.len anchor.vis.list > end_loop.after.vis &
wait

cat end_loop.after.vis | $lib/split_chromo.py $anchorbed &
wait
