#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# run in the matrix folder : Rscript --vanilla generate.chr.matrix.component.r cell_type bin 
#parameter 1: cell type
#parameter 2: bin
#output: matrix for heatmap; heatmap.png; matrix.component
library(gplots)
cell_type=args[1]
bin=args[2]
genome=args[3]
path=args[4]

#bin_path_name="/mnt/NFS/homeGene/JinLab/ssz20/zshanshan/heatmap_for_cis/bin"

if(bin=='500k' && genome=='hg19'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
	bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"
	bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),".500k.name",sep='')

}

if(bin=='250k' && genome=='hg19'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
	bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"
	bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')

}
if(bin=='500k' && genome=='mm10'){
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
	bin_path="/mnt/rds/genetics01/JinLab/xww/low.resolution/bin_path/mm10"
	bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
}
if(bin=='250k' && genome=='mm10'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
        bin_path="/mnt/NFS/genetics01/JinLab/xww/low.resolution/bin_path/mm10"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')

}
if(bin=='40k' && genome=='mm10'){
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
inputname=paste(path,paste(chr_lis,"matrix",sep='.'),sep='/')

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
	#	m=read.table(outputname_one[i],sep='\t',header=T)
		diag(m)=0
		m_raw=m
###############step 2: remove 0 bin################################
xmean<-apply(m,1,mean)
zero_bin=which(xmean==0)
mc=m[-zero_bin,-zero_bin]
###############step 3: correct submatrix####################
mm=mc
mm_background=mm
temp_list=c()
for(g in 2:(ncol(mm)-1)){
        xrow=1
        xcol=g
        for(h in g:ncol(mm)){
                temp_list=c(temp_list,mm[xrow,xcol])
                xrow=xrow+1
                xcol=h+1
        }
        mean_value=mean(temp_list)
        xrow=1
        xcol=g
        for(h in g:ncol(mm)){
                mm[xrow,xcol]=mm[xrow,xcol]/mean_value
                mm_background[xrow,xcol]=mean_value
		mm_background[xcol,xrow]=mm_background[xrow,xcol]
                mm[xcol,xrow]=mm[xrow,xcol]
		 xrow=xrow+1
                xcol=h+1
        }
        temp_list=c()
}

        mm[nrow(mm),1]=1
        mm[1,ncol(mm)]=1
	mm_background[nrow(mm),1]=1
        mm_background[1,ncol(mm)]=1
	temp_rownames=rownames(mm)
	temp_colnames=colnames(mm)
	mm[which(is.na(mm))]=0
	#rownames(mm)=temp_rownames
	#colnames(mm)=temp_colnames
	
sub_binname=colnames(mm_background)
m_new=matrix(0,nrow(m_raw),ncol(m_raw))
colnames(m_new)=colnames(m_raw)
rownames(m_new)=rownames(m_raw)
for(row in 1:(nrow(mm_background)-1)){
        for(col in (row+1):ncol(mm_background)){
                a=sub_binname[row]
                b=sub_binname[col]
                m_new[a,b]=mm_background[row,col]
                m_new[b,a]=m_new[a,b]
        }
}

for(rr in 1:nrow(mm_background)){
        a=sub_binname[rr]
        m_new[a,a]=mm_background[rr,rr]
}
mm_background=m_new
mm_ratio=m_new





mc=mm

sub_binname=colnames(mc)
m_new=matrix(0,nrow(m_raw),ncol(m_raw))
colnames(m_new)=colnames(m_raw)
rownames(m_new)=rownames(m_raw)
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
mm_ratio=m_new
write.table(mm_ratio,paste(chr_lis[i],'.ratio',sep=''),sep='\t',quote=F)
}
#############submatrix correlation###################
############END############################################
