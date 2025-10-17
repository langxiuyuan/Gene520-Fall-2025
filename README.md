# Gene520-Fall-2025


# Bioinfo-toolkit

# 💻 Scripts

This repository contains a curated collection of scripts and utility tools that I have used throughout my research. These scripts are primarily geared toward data processing tasks related to Hi-C, RNA-seq, and ChIP-seq.



# Shell Commands 

|Command| Description |
| --------------- | ----------------- |
|`git status` | View current changes  |
|`git add <file>`   | Add specific file |
|`git add .` | Add all changes  |
|`git commit -m "<message>"`    | Commit with a message   |
|`git push` | push files to repository  |

# Conda environment

|Command| Description |
| --------------- | ----------------- |
|`conda info --env`| Check available conda environments|
|`conda activate -n Corigami_ChIP`| Create conda environment |




# HPC Command Line

|Command| Description |
| --------------- | ----------------- |
|`srun --time=3:00:00 --mem=4gb --pty /bin/bash` | Pull a computational node  |
| `srun --partition=gpu --gres=gpu:1 --nodelist=dgxt001 --cpus-per-task=6 --mem=96gb --time=1-16:00:00 --pty bash`| Pull a gpu node |
| `srun --partition=gpu --gres=gpu:0 --nodelist=dgxt001 --cpus-per-task=15 --mem=128gb --time=6:00:00 --pty bash `| Request cpus on gpu node|
| `sq -p smp `| see the usage of partition |
| `sq -A fxj45` | see the jobs in group |
|`module load Miniconda3/22.11.1-1`   | Load miniconda |
|`module spider conda` | Find available conda version |
|`rsync -avh --no-times /data xxl1432@hpctransfer1:/scratch/pbsjobs/xxl1432/` | Rsync the data from hiview10 to hpc  |
|`rsync -avh --no-times xxl1432@hpctransfer1.case.edu:/scratch/pbsjobs/xxl1432/ /home/xxl1432/`    | Rsync the data from hpc to hiview10   |
|`find . -exec touch  {} \;` |  Recursively update the timestamps of every folder and file, but not for hidden files |

