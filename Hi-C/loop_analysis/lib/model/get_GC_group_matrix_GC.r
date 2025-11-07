data <- read.table("avg_cis_count.by.GC_group.over_2Mb", col.names=c("g1", "g2", "count", "avg"))
attach(data)
total_avg <- sum(count*avg)/sum(as.numeric(count))
data$correct <- avg / total_avg
detach()
attach(data)


matrix <- correct
dim(matrix) <- c(20,20)

n <- 100
up_ladder <- seq(0,1,length.out=n)
down_ladder <- seq(1,0,length.out=n)
up_red <- rgb(1, down_ladder, down_ladder)
up_green <- rgb(down_ladder, 1, down_ladder)
up_blue <- rgb(down_ladder, down_ladder, 1)
up_yellow <- rgb(1, 1, down_ladder)
down_red <- rgb(1, up_ladder, up_ladder)
down_green <- rgb(up_ladder, 1, up_ladder)
down_blue <- rgb(up_ladder, up_ladder, 1)
down_yellow <- rgb(1, 1, up_ladder)

pdf("heatmap.enrich.by.GC_group.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()
