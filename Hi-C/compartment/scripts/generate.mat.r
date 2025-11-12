#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# run in the matrix folder : Rscript --vanilla generate.chr.matrix.component.r cell_type bin 
#parameter 1: cell type
#parameter 2: bin
#output: matrix for heatmap; heatmap.png; matrix.component
#library(gplots)
options(bitmapType = "cairo")
cell_type=args[1]
bin=args[2]
genome=args[3]


#bin_path_name="/mnt/NFS/homeGene/JinLab/ssz20/zshanshan/heatmap_for_cis/bin"

if(bin=='500k' && genome=='hg19'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
	bin_path_name="/mnt/NFS/homeGene/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"
	bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),".500k.name",sep='')

}

if(bin=='250k' && genome=='hg19'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
	bin_path_name="/mnt/NFS/homeGene/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"
	bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')

}
if(bin=='500k' && genome=='mm10'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
	bin_path="/mnt/NFS/genetics01/JinLab/xww/low.resolution/bin_path/mm10"
	bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')

}

############generate matrix###########################

#col_matrix=matrix(0,4,3)
#colnames(col_matrix)=c("250k","500k","1M")
#rownames(col_matrix)=c("hiNPC","ips","Neuron","UNC_adult")
#col_matrix[1,]=c(220,880,3600)
#col_matrix[2,]=c(220,880,3600)
#col_matrix[3,]=c(350,1400,5600)
#col_matrix[4,]=c(650,2600,10400)
#col_matrix[5,]=c(400,1600,6400)
#scale=col_matrix[cell_type,bin]

#############step 1: generate n*n matrix for every bin############
inputname=paste(chr_lis,"matrix",sep='.')
output=paste(chr_lis,'.matrix.heatmap',sep='')
for(i in 1:length(inputname)){
	if(file.exists(inputname[i])){
		data=read.table(inputname[i],sep='\t',fill=TRUE,row.names=NULL)

		rowname=read.table(bin_name[i],sep='\t')
		rowname=as.character(unique(rowname[,1]))
		rowname=paste(rep(chr_lis[i],length(rowname)),rowname,sep='_')
		m=matrix(0,length(rowname),length(rowname))
		colnames(m)=rowname
		rownames(m)=rowname
		data[,1]=as.character(data[,1])
		data[,2]=as.character(data[,2])
		data[,3]=as.numeric(as.character(data[,3]))
		for(ind in 1:nrow(data)){
        		m[data[ind,1],data[ind,2]]=data[ind,3]
        #	
        	}

		diag(m)=0
		m=write.table(m,output[i],sep='\t',quote=F)
	#	diag(m)=0
	#	m_raw=m
###############step 2: remove 0 bin################################
}
}
############END############################################
