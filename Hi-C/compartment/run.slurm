#!/bin/bash
#SBATCH --job-name=chipseq
#SBATCH --time=24:00:00 # 1 hour of "wall time"
#SBATCH -N 1 # 1 Node
#SBATCH -c 12 # 4 processor
#SBATCH --mem=96gb
#SBATCH --partition=markov_gpu
#SBATCH --mail-user=xxl1432@case.edu

module load Perl/5.30.0-GCCcore-8.3.0
module load SAMtools/1.11-GCC-10.2.0
module load BEDTools/2.30.0-GCC-11.2.0
module load Python/3.8.6-GCCcore-10.2.0


bash ./1.hg19_run.compart_200k.sh
