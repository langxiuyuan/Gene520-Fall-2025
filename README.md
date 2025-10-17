# Gene520-Fall-2025


# 💻 Scripts

This repository contains a curated collection of scripts and utility tools that I have used throughout my research. These scripts are primarily geared toward data processing tasks related to Hi-C, RNA-seq, and ChIP-seq.



# Linux Commands 

|Command| Description | Options| Examples |
| --------------- | ----------------- | --------------- | ----------------- |
|`ls` | List files and directories  | `-l`: Long format listing <br> `-h`:Human-readable file sizes <br> `-a`:Include hidden files | `ls -lh` displays files and directories with detailed information in a human-readable format |
|`cd`| Change directory   | | cd /path/to/directory changes the current directory to the specified path. |
|`pwd`|Print current working directory | | `pwd` displays the current working directory. |
|`mkdir`| Create a new directory | | `mkdir Gene520` creates a new directory named "Gene520". |
|`rm`| Remove files and directories.	 | `-r`: Remove directories recursively <br> `-f`: Force removal without confirmation.|`rm file.txt`  deletes the file named "file.txt".<br> `rm -r my_directory` deletes the directory "my_directory" and its contents. <br> `rm -f file.txt` forcefully deletes the file "file.txt" without confirmation. |
|`cp` | Copy files and directories| `-r`: Copy directories recursively. |`cp -r directory destination`  copies the directory "directory" and its contents to the specified destination. <br> `cp file.txt destination`  copies the file "file.txt" to the specified destination. | 
|`mv` | Move/rename files and directories.|  |`mv file.txt new_name.txt` renames the file "file.txt" to "new_name.txt". <br> `mv file.txt directory` moves the file "file.txt" to the specified directory. | 	
|`cat`| View the contents of a file.	 |	| `cat file.txt`  displays the contents of the file "file.txt". |
|`grep`| used to search for specific patterns or regular expressions in text files or streams and display matching lines.| | `grep "hello" file.txt` search "hello" in file.txt| 
|`wc`| word count |`-l`: count only the number of lines | `wc -l file.txt`: Count how many lines are in file.txt | 
|`head`| Display the first few lines of a file.	| `-n`: Specify the number of lines to display. | `head file.txt` shows the first 10 lines of the file "file.txt". <br> `head -n 5 file.txt`  displays the first 5 lines of the file "file.txt". | 
|`tail`| Display the last few lines of a file. |`-n`: Specify the number of lines to display.| `tail file.txt` shows the last 10 lines of the file "file.txt". <br> `tail -n 5 file.txt` displays the last 5 lines of the file "file.txt".| 
|`less`| display the contents of a file in a terminal | `-N`:View a file with line numbers | `less -N file.txt` View a file with line numbers | 
|`\|`|pass the output of one command as the input to another command.| | `cat file.txt \| grep apple \| wc -l ` prints the entire file and grep "apple" filters and only shows lines containing the word apple, and then count number of lines that contain “apple”. <br> `head -n 10000 file.txt \| tail -n 1`: head grabs the first 10,000 lines, and tail picks the last one from them. | 


|`sort`|

|`cut -f `|

|`awk`|










|`less` | View current changes  |
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

