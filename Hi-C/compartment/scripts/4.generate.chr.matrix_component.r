#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# run in the matrix folder : Rscript --vanilla generate.chr.matrix.component.r cell_type bin 
#parameter 1: cell type
#parameter 2: bin
#output: matrix for heatmap; heatmap.png; matrix.component
cell_type=args[1]
bin=args[2]
genome=args[3]

# if(genome=="mm10"){
#         bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/mESC_name/mm10"
#         chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
# }

if(genome=="mm9"){
        bin_path_name="/mnt/jinstore/JinLab01/ssz20/zshanshan/heatmap_for_cis/mESC_name/mm9"
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
}


if(bin=='200k' && genome=='mm10'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/mm10/200k"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if(bin=='250k' && genome=='mm10'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/mm10/250k"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if(bin=='500k' && genome=='mm10'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/mm10/200k"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if(bin=='1M' && genome=='mm10'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/mm10/1M"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}


if(bin=='500k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        # bin_path="/mnt/rds/genetics01/JinLab/xww/low.resolution/bin_path/hg19"
	bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}


if(bin=='200k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        # bin_path="/mnt/rds/genetics01/JinLab/xww/Miami/hg19_100kb"
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')

}


if(bin=='100k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        # bin_path="/mnt/rds/genetics01/JinLab/xww/Miami/hg19_100kb"
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')

}

if(bin=='40k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        # bin_path="/mnt/rds/genetics01/JinLab/xww/Miami/hg19_100kb"
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')

}


if(bin=='250k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        # bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"
	bin_path_name="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')

}

if(bin=='1M' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        # bin_path="/mnt/rds/genetics01/JinLab/xww/low.resolution/bin_path/hg19"
	bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if(genome=='hg38'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        # bin_path="/mnt/rds/genetics01/JinLab/xww/low.resolution/bin_path/hg19"
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg38"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}


#bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
library(gplots)
#################
input_matrix=paste(chr_lis,"correlation.matrix",sep='.')
#outputname_one=paste(inputname,"heatmap",sep='.')
component_matrix=paste(chr_lis,"matrix.component",sep='.')
#outputname_three=paste(inputname,"heatmap.correlation",sep='.')
#outputname_four=paste(inputname,"distance.correlation",sep='.')
#row_path_name=paste(bin_path_name, paste(bin,"bin.name",sep='.'),sep='/')
#row_path_name=bin_path_name
for(i in 1:length(input_matrix)){
	if(file.exists(input_matrix[i])){
		data=read.table(input_matrix[i],sep='\t',header=T,row.names=1,stringsAsFactors=F,fill=T)
               
###############PCA and outplut#####################################
mc=as.matrix(data)
sub_binname=colnames(mc)
m_new=matrix(0,nrow(mc),ncol(mc))
colnames(m_new)=colnames(mc)
rownames(m_new)=rownames(mc)
for(row in 1:(nrow(mc)-1)){
	for(col in (row+1):ncol(mc)){
		a=sub_binname[row]
		b=sub_binname[col]
		m_new[a,b]=mc[row,col]
		m_new[b,a]=m_new[a,b]
	}
}

for(rr in 1:nrow(mc)){
	a=sub_binname[rr]
	m_new[a,a]=mc[rr,rr]	
}
	q=which(rowSums(mc)==0)
	if(length(q)!=0){
        	mc=mc[-q,]
		mc=mc[,-q]
	}
	if(nrow(mc)!=0){
		p=princomp(mc,cor=TRUE)
		x=loadings(p)
		comp=x[,1:3]# get first 3 component
		ID_name=rownames(x)
		result=data.frame(ID_name,comp)
#		write.table(m_new,file=outputname_three[i],sep='\t',quote=FALSE)
		write.table(result,file=component_matrix[i],sep='\t',quote=FALSE,col.names=FALSE,row.names=FALSE)
	}
	
}
}
###########END############################################
