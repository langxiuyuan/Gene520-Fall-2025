#!/bin/bash


lib=/mnt/rds/genetics01/JinLab/xww/degradation/src
ref=/mnt/rds/genetics01/JinLab/xww/HiCorr/references
name=$1
genome=$2


for file in `ls rep1.loop.* | grep -v trans`;do
        cat $file | $lib/summary_sorted_frag_loop.pl $ref/${genome}.DPNII.frag.bed  > temp.$file
#	mv temp.$file $file
        #./resort_by_frag_id.pl human_mouse_mix.HindIII.frag.bed $file
done &

wait

for file in `ls rep1.loop.trans`;do
	$lib/summary_sorted_trans_frag_loop.pl $file > temp.$file
done &

wait
cat temp*.samestrand > frag_loop.$name.samestrand &
cat temp*.inward | awk '{if($4>1000)print $0}' > frag_loop.$name.inward &
cat temp*.outward | awk '{if($4>5000)print $0}' > frag_loop.$name.outward &
cat temp*.trans | cut -f1-3 > frag_loop.$name.trans &
wait

$lib/merge_sorted_frag_loop.pl frag_loop.$name.samestrand frag_loop.$name.inward frag_loop.$name.outward >frag_loop.$name &

wait
echo Done!
#echo $name cis `awk '{sum+=$3}END{print sum}' frag_loop.$name` >>filtered.count
