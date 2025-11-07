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

data.before <- read.table("avg_ratio.by.cis_GC_group.before_corr", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.before$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.before_corr.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

data.after <- read.table("avg_ratio.by.cis_GC_group.after_corr", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.after$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.after_corr.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

data.before <- read.table("avg_ratio.by.cis_GC_group.before_corr.below_1Mb", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.before$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.before_corr.below_1Mb.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

data.after <- read.table("avg_ratio.by.cis_GC_group.after_corr.below_1Mb", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.after$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.after_corr.below_1Mb.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

data.before <- read.table("avg_ratio.by.cis_GC_group.before_corr.over_1Mb", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.before$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.before_corr.over_1Mb.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

data.after <- read.table("avg_ratio.by.cis_GC_group.after_corr.over_1Mb", col.names=c("g1", "g2", "count", "avg"))
matrix <- data.after$avg
dim(matrix) <- c(20,20)
pdf("heatmap.enrich_ratio.by.cis_GC_group.after_corr.over_1Mb.pdf", width=3.5, height=4)
col <- c(down_blue, up_red)
breaks <- seq(-1, 1, length.out=2*n+1)
image(1:20, 1:20, log2(matrix), zlim=c(-1,1), col=col, breaks=breaks, xlab="", ylab="")
dev.off()

