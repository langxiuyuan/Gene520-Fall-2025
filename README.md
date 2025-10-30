# Gene520-Fall-2025

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
|`ln`|Create a symbolic link (symlink) to a file or directory | `-s`: symbolic link | `ln -s /path/to/original.txt ./`: in the current order, creates a symlink pointing to original.txt | 
|`unlink`| Remove a single file or symbolic link (cannot remove directories) | |unlink symlink.txt: removes the file or symbolic link named symlink.txt |  
|`cat`| View the contents of a file.	 |	| `cat file.txt`  displays the contents of the file "file.txt". |
|`grep`| used to search for specific patterns or regular expressions in text files or streams and display matching lines.| `^`: match to the beginning of the line | `grep "hello" file.txt` search "hello" in file.txt <br> `grep ^@ file.txt`: Match lines that start with @| 
|`wc`| word count |`-l`: count only the number of lines | `wc -l file.txt`: Count how many lines are in file.txt | 
|`head`| Display the first few lines of a file.	| `-n`: Specify the number of lines to display. | `head file.txt` shows the first 10 lines of the file "file.txt". <br> `head -n 5 file.txt`  displays the first 5 lines of the file "file.txt". | 
|`tail`| Display the last few lines of a file. |`-n`: Specify the number of lines to display.| `tail file.txt` shows the last 10 lines of the file "file.txt". <br> `tail -n 5 file.txt` displays the last 5 lines of the file "file.txt".| 
|`less`| display the contents of a file in a terminal | `-N`:View a file with line numbers | `less -N file.txt` View a file with line numbers | 
|`\|`|pass the output of one command as the input to another command.| | `cat file.txt \| grep apple \| wc -l ` prints the entire file and grep "apple" filters and only shows lines containing the word apple, and then count number of lines that contain “apple”. <br> `head -n 10000 file.txt \| tail -n 1`: head grabs the first 10,000 lines, and tail picks the last one from them. | 
|`sort`|sort lines of txt files| `-k`: Specify sort key <br> `-n`: Numeric sort <br> `-V`: Version sort (comparing v1.2 vs v1.10) | `sort -k 2,2n file.txt` Sort by second column as numbers. <br> `sort -k 2,2V file.txt`: Sort by first column using version comparison. | 
|`cut`|Extract specific columns or sections from each line of a file | `-f`: select fields (columns)| `cut -f1,3 file.txt` extracts column 1 and 3 from a tab-delimited file|
|`awk`|A powerful text-processing tool that scans input line by line, splits into columns, and performs actions such as filtering, printing, and calculations | `$1, $2`: access specific fields <br> `$0`: access the entire line <br>  | `awk '{print $1}'` file.txt : prints first column <br>  `awk '$3==5 {print $0}'` file.txt : prints entire line where third column equals 5 | 
 







# HPC Commands

|Command| Description |
| --------------- | ----------------- |
|`srun --time=3:00:00 --mem=4gb --pty /bin/bash` | Pull a computational node  |
| `srun --partition=gpu --gres=gpu:1 --nodelist=dgxt001 --cpus-per-task=6 --mem=96gb --time=1-16:00:00 --pty bash`| Pull a gpu node |
|`module load Miniconda3/22.11.1-1`   | Load miniconda |
|`module spider conda` | Find available conda version |


