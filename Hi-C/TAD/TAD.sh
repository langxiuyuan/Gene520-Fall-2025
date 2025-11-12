#!/bin/bash


ref=/mnt/vstor/courses/gene520/Hi-C/ref/TAD_ref
lib=./src
software=./software

cis=human_Beta_cells_end_loop.cis.rmbl
expt=human_Beta_cells_end_loop

$lib/1.frag.to.bin.merge.from.loop_V2.pl /mnt/vstor/courses/gene520/Hi-C/ref/TAD_ref/hg19.2digest.anchor.2.bin.40k $cis > $cis.2.40kb

for i in {1..22} X Y;do 
grep chr$i\_ $cis.2.40kb >chr$i.bin_loop 
$lib/generate_data_matrix_denoised.pl $ref/chr$i.40kb_bin chr$i.bin_loop grid; 
mv matrix.obs chr$i.matrix; 
cut -f1-3 $ref/chr$i.40kb_bin | paste - chr$i.matrix >chr$i.matrixfile;
$software/DI_from_matrix.pl chr$i.matrixfile 40000 2000000 /mnt/vstor/courses/gene520/Hi-C/ref/BowtieIndex/genome.fa.fai >chr$i.DI; 
done

# cat chr*.DI > $expt.DI

for i in {1..22} X Y;do cat ./chr$i.DI | sed 's/chr//g' >> $expt.DI; done
sed -i 's/X/23/g' $expt.DI
sed -i 's/Y/24/g' $expt.DI
sort -k 1,1n -k2,2n -k 3,3n $expt.DI > $expt.sorted.DI

# HMM (matlab on exon)
nice matlab -nodisplay -nosplash -nodesktop < HMM_calls.m > dumpfile &
# nice /usr/local/matlab/R2016b/bin/matlab -nodisplay -nosplash -nodesktop < HMM_calls_50M.m > dumpfile &
# nice /usr/local/matlab/R2016b/bin/matlab -nodisplay -nosplash -nodesktop < HMM_calls_100M.m > dumpfile &
# nice /usr/local/matlab/R2016b/bin/matlab -nodisplay -nosplash -nodesktop < HMM_calls_200M.m > dumpfile &


# $software/perl_scripts/file_ends_cleaner.pl $expt.sorted_out.DI $expt.DI | $software/perl_scripts/converter_7col.pl > $expt.hmm_7colfile &

$software/file_ends_cleaner.pl $expt.sorted_out.DI $expt.sorted.DI | $software/converter_7col.pl > $expt.hmm_7colfile &
sed -i 's/chr24/chrY/g; s/chr23/chrX/g' $expt.hmm_7colfile

for i in {1..22} X Y;do
        grep -w chr$i $expt.hmm_7colfile >chr$i.hmm_7colfile;
        $software/hmm_probablity_correcter.pl chr$i.hmm_7colfile 2 0.99 20000 | $software/hmm-state_caller.pl failfile_chr$i chr$i | $software/hmm-state_domains.pl >chr$i.finaldomaincalls;
done &

# for i in {1..22} X Y;do cat ./chr$i.finaldomaincalls >> ${expt}all.domain.bed; done

for i in {1..22} X Y; do
    awk 'NF==3 {last=$0} NF<3 {next} {print last} {last=$0} END {if (NF==3) print last}' ./chr$i.finaldomaincalls >> ${expt}.all.domain.bed
done


