#!/bin/bash
#SBATCH --job-name=chipseq
#SBATCH --time=1:00:00 # 1 hour of "wall time"
#SBATCH -N 1 # 1 Node
#SBATCH -c 4 # 4 processor
#SBATCH --mem=16gb
#SBATCH --partition=markov_gpu
#SBATCH --mail-user=xww@case.edu

module load Perl/5.30.0-GCCcore-8.3.0
module load SAMtools/1.11-GCC-10.2.0
module load BEDTools/2.30.0-GCC-11.2.0

lib=/home/xww/file_code
bash $lib/chip_SE.sh mm10
