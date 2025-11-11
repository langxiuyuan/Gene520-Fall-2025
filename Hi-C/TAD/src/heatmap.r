#!/usr/bin/env Rscript


args = commandArgs(trailingOnly=TRUE)

filename=args[1]
prefix=args[2]
index=3

data=read.table(filename,sep='\t',stringsAsFactors=F)

n <- 20
col <- rgb(1,(n-2):0/(n-1),(n-2):0/(n-1))
draw_heatmap <- function(matrix,name){
                if(max(matrix)<2){
                        breaks <- seq(1.001,max(matrix),(max(matrix)-1.001)/19)
                }else{
                        step <- (quantile(matrix, prob=0.98)-1)/18
                        up <- quantile(matrix, prob=0.98)+0.011
                        if(up<2){
                                up <- 2
                                step <- 0.999/18
                        }
                        breaks <- c(seq(1.001,up,step),max(matrix))
                }
        #png_name <- paste("~/test/",name,".png",sep="")
        png(paste('./',name,'.png',sep=''),width=5*300,height=5*300,res=300)
#	pdf(paste('./',name,'.pdf',sep=''),width=5,height=5)
#        par(mar=c(0,0.1,0,0.1))
	par(mar=c(0,0,0,0))
        image(matrix,zlim=c(1, 50), col=col, breaks=breaks,xaxt="n",yaxt="n",xlab="",ylab="")
        box(lty = 'solid', col = 'black',lwd=2)
        dev.off()
}

construct=function(loop,list,index){

	mat=data.frame(matrix(0,length(list),length(list)))
	rownames(mat)=colnames(mat)=list
	for(i in 1:nrow(loop)){
		mat[loop[i,1],loop[i,2]]=loop[i,index]
		mat[loop[i,2],loop[i,1]]=loop[i,index]}
return(mat)}

anchorlist=sort(unique(c(data[,1],data[,2])))
denoise_mat=construct(data,anchorlist,index)

#png(paste('~/test',paste(chr,beg,end,sep=':'),'.png',sep=''),width=4*4*300,height=4*300,res=300)
#prefix=paste(chr,':',beg,'-',end,'.',type,sep='')

draw_heatmap(as.matrix(denoise_mat),prefix)
#dev.off()

