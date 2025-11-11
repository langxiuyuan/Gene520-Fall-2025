#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
name=args[1]
bin=args[2]
genome=args[3]
pwd=args[4]
figfolder=args[5]

if(genome=="mm10"){
        bin_path_name="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/mm10"
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
	bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
}

if(genome=="mm9"){
        bin_path_name="/mnt/jinstore/JinLab01/ssz20/zshanshan/heatmap_for_cis/mESC_name/mm9"
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY")
}

if(bin=='500k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if(bin=='250k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        bin_path_name="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
}

if(bin=='200k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        bin_path_name="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
}

if(bin=='100k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,paste(chr_lis,'.bin',sep=''),sep='/')
	chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
}

if(bin=='40k' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
        bin_path_name="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
}


if(bin=='1M' && genome=='hg19'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg19"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}

if( genome=='hg38'){
        chr_lis=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
#       bin_path_name="/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/hg19_name"

        bin_path="/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/hg38"
        bin_name=paste(bin_path,bin,paste(chr_lis,'.bin',sep=''),sep='/')
}


#bin_name=paste(paste(bin_path_name,bin,chr_lis,sep='/'),"bin",sep='.')
library(gplots)

#####################generate component#########################################
if(genome=="mm10" || genome=="mm9"){
component_lis=matrix(0,14,21)
rownames(component_lis)=c("treated","untreated","mMacrophage_ips_p3","mMEF_ips_p20","mMEF_ips_p3","mNSC_ips_p20","mNSC_ips_p3","mPreB_ips_p20","mPreB_ips_p3","MEF_scNoHS","MEF_scHS3hr","MEF_shNoHS","MEF_shHS3h","mESC_DPNII_recover")
colnames(component_lis)=chr_lis
#mESC
component_lis[1,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#mMacro_p20_ips
component_lis[2,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#Macro_p3_ips
component_lis[3,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_p20_ips
component_lis[4,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_p3_ips
component_lis[5,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#mNSC_p20
component_lis[6,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#mNSC_p3
component_lis[7,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#mPreb_p20
component_lis[8,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#mPreb_p3
component_lis[9,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_scNoHS
component_lis[10,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_scHS3hr
component_lis[11,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_shNoHS
component_lis[12,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#MEF_shHS3h
component_lis[13,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
component_lis[14,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#component_lis[2,]=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1)}
}
if(genome=="hg19" || genome=="hg38"){
component_lis=matrix(0,4,24)
rownames(component_lis)=c('H1','ips','NPC','neuron')
colnames(component_lis)=chr_lis
component_lis[1,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
component_lis[2,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
component_lis[3,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
component_lis[4,]=c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)
#component_lis[5,]=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
#component_lis[6,]=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
#component_lis[7,]=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)

}

##############################################################
#file_path="/mnt/rds/genetics01/JinLab/xww/low.resolution/cell.type"   
#cell_path=paste(file_path,cell_type,bin,sep='/')
#chr_lis="chr19"
file_name=paste(chr_lis,paste("bin.",bin,".chip.freq.score",sep=''),sep='.')
#inputfile=paste(cell_path,file_name,sep='/')
inputfile=paste(pwd,file_name,sep='/')
input_heatmap=paste(paste(chr_lis,rep("correlation.matrix"),sep='.'),sep='/')
outputfile=paste(pwd,paste(file_name,"PC3_A.B.label",sep='.'),sep='/')
#output_heatmap=paste(input_heatmap,"one.component","png",sep='.')
#row_path_name=paste(bin_path_name, paste(bin,"bin.name",sep='.'),sep='/')
#row_path_name=bin_path_name
library(gplots)
for(i in 1:length(inputfile)){
        if(file.exists(inputfile[i])){
        	binname=read.table(bin_name[i],sep='\t')
        	binname=as.character(unique(binname[,1]))
        	binname=paste(rep(chr_lis[i],length(binname)),binname,sep='_')
		data=read.table(inputfile[i],sep='\t')
		id_total=binname
		id_compo=as.character(data[,1])
		removed_id=setdiff(id_total,id_compo)
		temp_m=matrix(0,length(removed_id),ncol(data))
		temp_m[,1]=removed_id
		data=as.matrix(data)
		data=rbind(data,temp_m)
#####################DRAW the one component heatmap######################################################
		png(paste(pwd,figfolder,paste(input_heatmap[i],"select_thrid_compo","png",sep='.'),sep='/'))
		# nf <- layout(matrix(c(1,2,3),3,1,byrow=TRUE), widths=c(7,7,7), heights=c(2,1,7), TRUE)
		nf <- layout(matrix(c(1,2),2,1,byrow=TRUE), widths=c(7,7), heights=c(2,7), TRUE) # without the second track	
		#layout.show(nf)
		compo_ind=component_lis[1,i]
		compo=as.numeric(compo_ind)+2
		x=as.numeric(data[,compo])
			label=rep(0,nrow(data))
			label[which(is.na(data[,compo]))]<-'NA'
			a=which(as.numeric(as.character(data[,compo]))>0) #positive value
			b=which(as.numeric(as.character(data[,compo]))<0) #negative value
			c=which(as.numeric(as.character(data[,compo]))==0)
			pp=0
			qq=0
			if(length(b)!=0){
				pp=mean(as.numeric(na.omit(data[b,2]))) #neagtive corresponds to H3K4me3 counts
			}
			if(length(a)!=0){
				qq=mean(as.numeric(na.omit(data[a,2]))) #positive corresponds to H3K4me3 counts
			}
			
			if(pp > qq){
				label[b]=rep("A",length(b))
				label[a]=rep("B",length(a))
				symbol_index=-1
			}
			if(pp< qq){
				label[b]=rep("B",length(b))
				label[a]=rep("A",length(a))
				symbol_index=1
			}
			label[c]=rep("C",length(c))
		###############sort by bin number##############
			new_data=data.frame(data,label)### height ID counts compo1 compo2 compo3 label 
			X=c()
			for(o in 1:nrow(new_data)){
				xs=unlist(strsplit(as.character(new_data[o,1]),"n"))[2]
				X=c(X,xs)
			}
			nn=data.frame(data[,1],label,as.numeric(data[,compo])*symbol_index)
			write.table(nn,outputfile[i],sep='\t',quote=FALSE,row.names=FALSE,col.names=FALSE)
			X=as.numeric(X)
			new_data=data.frame(new_data,X) #add bin_number to new_data
			new_data=new_data[order(as.numeric(new_data[,7])),]
			colnames(new_data)=c("bin_ID","chip_counts","compo1","compo2","compo3","Label","bin_number")
			compart_list=as.character(as.vector(new_data$Label))
                        compart_list[which(compart_list=="A")]=rep(-1,length(which(compart_list=="A")))
                        compart_list[which(compart_list=="B")]=rep(1,length(which(compart_list=="B")))
                        compart_list[which(compart_list=="C")]=rep(0,length(which(compart_list=="C")))
                        compart_list[which(compart_list=="0")]=rep(0,length(which(compart_list=="0")))
#			png(paste(chr_lis[i],'bar.png',sep='.'),width=10*500,height=1*500,res=500)
			par(mar=c(0,0,0,0))
			x=as.numeric(as.character(new_data[,compo]))*symbol_index

			barplot(x, ylim=c(-0.05,0.05), col=ifelse(x>0,"black","grey"),border=NA,space=0,xlim=c(1,length(x)),xaxs="i",yaxs="i",xaxt='n',yaxt='n')
#			dev.off()
#			png(paste(chr_lis[i],'hist.png',sep='.'),width=10*500,height=1*500,res=500)
#			par(mar=c(0,0,0,0))
			# image(matrix(as.numeric(compart_list),length(compart_list),1),xaxt="n",yaxt="n",col=c("seagreen","lightgrey","red"),breaks=c(-2,-0.9,0.9,2)) # comment this when do not show the second track 
#			dev.off()

		heatmap=read.table(input_heatmap[i],sep='\t',header=T)
		heatmap=as.matrix(heatmap)
		full_correlation_m=heatmap
		n=200
		col_one=colorpanel(99,"blue","white")
                middle="lightgrey"
                col_two=colorpanel(99,"white","red")
                new_col=c(col_one,middle,col_two)
               	colbreaks=unique(c(min(full_correlation_m),seq(-0.2,-0.0001,length=99),seq(0.0001,quantile(full_correlation_m,probs=0.9),length=99),max(full_correlation_m)))
#		colbreaks=unique(c(min(full_correlation_m),seq(-0.2,-0.0001,length=99),seq(-0.00001,quantile(full_correlation_m,probs=0.98),length=99),max(full_correlation_m)))
#                image(full_correlation_m,col=new_col,zlim=c(1, 50),breaks=colbreaks,xaxt="n",yaxt="n")

#                dev.off()
#		png(paste(input_heatmap[i],"single","png",sep='.'),width=5*500,height=5*500,res=500)
#		par(mar=c(0,0,0,0))
		image(full_correlation_m,col=new_col,zlim=c(1, 50),breaks=colbreaks,xaxt="n",yaxt="n")
		box(lty='solid',lwd=2)
		dev.off()

		
	}
}

