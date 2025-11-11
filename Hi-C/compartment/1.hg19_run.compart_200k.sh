#!/usr/bin/bash

#  nohup sh 3.hg19_run.compart_200k.sh pseudo_5_15_250k 250k GATC_CATG data_5_15 &

name=human_Beta_cells_500k  ## e.g. ODC_500k
res=500k   ## e.g. 500k, 200k
enzyme=2digest ## e.g. DpnII
celltype=human_Beta_cells ## ODC, CA1

lib=./scripts

if [[ $enzyme == 2digest ]]; then
	# ref=/mnt/rds/genetics01/JinLab/xww/stag2KO/low_resolution/ref
	ref=/mnt/vstor/courses/gene520/Hi-C/ref/hg19_GATC_GANTC
	binref=$ref/anchor2bin/hg19.GATC_GANTC.anchor.2.bin.${res}

elif [[ $enzyme == GATC_CATG ]]; then 
	ref=/mnt/jinstore/JinLab03/xxl1432/lib/Compartment/hg19_ref_5kb/GATC_CATG
        binref=$ref/anchor2bin/hg19.GATC_CATG.anchor.2.bin.${res}

elif [[ $enzyme == DpnII ]]; then
	# ref=/mnt/jinstore/JinLab03/xxl1432/scloop/examples/pseudobulk_HiC/mouse_hip_5kb/ref_5kb
	ref=/mnt/jinstore/JinLab03/xxl1432/lib/Compartment/hg19_ref_5kb/DpnII/
	# binref=$ref/anchor2bin/DpnII/mm10.DPNII.anchor.2.bin.${res}
	binref=$ref/anchor2bin/DpnII/hg19.DPNII.anchor.2.bin.${res}

fi

mkdir ${celltype}_${res}


if [[ $res == 1M ]]; then
	$lib/1.frag.to.bin.merge.from.loop_V2.pl $binref ${celltype}_end_loop.cis.rmbl |python2  $lib/remove.blacklist.py $ref/blacklist/hg19.anchors.${res}.blacklist > ${celltype}_$res/$name.sparse.matrix.${res}.rmbl
else 
	$lib/1.frag.to.bin.merge.from.loop_V2.pl $binref ${celltype}_end_loop.cis.rmbl |python2  $lib/remove.blacklist.py $ref/blacklist/hg19.anchors.${res}b.blacklist > ${celltype}_$res/$name.sparse.matrix.${res}.rmbl 
fi


cd ${celltype}_$res

for i in {1..22} X Y;do
grep chr$i\_ $name.sparse.matrix.${res}.rmbl > chr$i.matrix;
done

##

Rscript $lib/3.generate.correlation.matrix.r $name $res hg19 ${PWD}


##

Rscript $lib/4.generate.chr.matrix_component.r $name $res hg19

wait
##

bash $lib/5.generate.score.file.improve.sh hg19 ${PWD} $res

wait

##

mkdir ${name}_fig

Rscript $lib/6.plot.one.component.improved.r $name $res hg19 ${PWD} ${name}_fig
# $lib/6.plot.component.two.improved.r $name $res hg19 ${PWD} ${name}_fig
# $lib/6.plot.component.three.improved.r $name $res hg19 ${PWD} ${name}_fig


cat chr*PC1_A.B.label  > $name.merged.PC1.label
wait
echo Done!
exit

