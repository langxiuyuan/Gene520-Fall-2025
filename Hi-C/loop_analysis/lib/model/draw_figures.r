anchor <- read.table("anchors_2kb.bed", col.names=c("chr","beg","end","id"))
frag <- read.table("hg18.HindIII.frag.bed", col.names=c("chr","beg","end","id","size"))
anchor$size <- anchor$end - anchor$beg +1
anchor <- anchor$size
frag <- frag$size

pdf("anchor_size_distribution.pdf", width=5, height=5)
hist(frag[frag < 20000], breaks = seq(0,20000,500), freq=FALSE, main="Size distribution of anchors")
lines(density(anchor[anchor < 20000], bw = 500), col="red")
legend("topright", c("No. of frags = 836,653","median frag size = 2,276", "No. of anchors = 334,250", "median anchor size = 7,380"), text.col=c("black","black","red","red"))
dev.off()

