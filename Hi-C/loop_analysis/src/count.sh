#!/bin/bash

lib=/mnt/NFS/genetics01/JinLab/xww/HiCorr/src
ref=/mnt/NFS/genetics01/JinLab/xww/for_xiaoxiao/HiCorr/references
name=$1
genome=$2

#echo done call fragpairs

for file in `ls $name.loop.*`;do
	$lib/frag.2.anchor.py $ref/${genome}_DpnII_frag_2_anchor $ref/${genome}_DpnII_anchors_avg.bed $file > temp.$file
done

wait
echo done call anchors
#~/degradation/src/merge_sorted_frag_loop.pl `ls temp.*.samestrand` > frag_loop.$name.samestrand &

#for file in `ls temp.*`;do

cat temp.*.inward |  awk '{if($4>1000)print $0}' > anchor_loop.inward &
cat temp.*.outward | awk '{if($4>5000)print $0}' > anchor_loop.outward &
mv temp.*.samestrand anchor_loop.samestrand &
cat temp.*.trans | cut -f1-3 > anchor_loop.trans

echo done filter
wait

#$lib/merge_sorted_anchor_loop.pl anchor_loop.samestrand anchor_loop.inward anchor_loop.outward > anchor_loop.$name &
#wait
