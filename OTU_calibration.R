#toward making a general otu calibrator

#accept input from commandline args[1] = script, args[2] = Overclus args[3] = Underclust

#setwd("/home/qiime/Desktop/Bartonella/TEST/") #comment out once happy#Oclust <- read.csv("bartonella_genbank_species_Overclustered.csv")
#Uclust <- read.csv("bartonella_genbank_species_Underclustered.csv")


args <- commandArgs(TRUE) #uncomment once happy
Oclust <- read.csv(as.character(args[1]))
OsimMin <- min(Oclust$sim)
OsimMax <- max(Oclust$sim)


Uclust <- read.csv(as.character(args[2]))
UsimMin <- min(Uclust$sim)
UsimMax <- max(Uclust$sim)

#save color vector to create a legend
colvec <- NULL
pdf(file="test_Uclust.pdf")
par(mfrow=c(1,1))
par(mar=c(5,4,4,2))
plot(Uclust$sim, Uclust$count, ylab="", xaxt="n",xlab="Percent Similarity", type='n', bty='n', xlim=c(UsimMin, UsimMax), main="", bty="n")
axis(side=1, at=seq(UsimMin, UsimMax))
mtext(text=expression(paste("OTU groups per ", species[i])), side=2, line=2.5)

Uclust100 <- subset(Uclust, sim == 100)
names.sorted <- as.character(Uclust100[ with(Uclust100, order(-count)),2])
for(i in names.sorted  ){
  r <- round(runif(1, 0, 255),0)
  g <- round(runif(1, 0, 255),0)
  b <- round(runif(1, 0, 255),0)
  colvec <- c(colvec, rgb(red=r,green=g,blue=b, maxColorValue=255))
  newdata <- subset(Uclust, species == i)
  #with jitter
  lines(newdata$sim, jitter(newdata$count), pch=19,lwd=2,col=rgb(red=r,green=g,blue=b, maxColorValue=255), type='b')
  #points(newdata$similarity, newdata$count, col=rgb(red=r,green=g,blue=b, maxColorValue=255))
  
  #without jitter
  #lines(newdata$similarity, newdata$count, col=rgb(red=r,green=g,blue=b, maxColorValue=255))
}

legend("topleft", names.sorted, pch=19, col=colvec)
dev.off()


grouper <- Oclust$count[which(Oclust$sim == OsimMin)]
maxer <- max(Oclust$count)*1.1

pdf(file="test_Oclust.pdf")
plot(rep(OsimMin, length(grouper)), xaxt="n",pch=19,grouper, xlim=c(OsimMin, OsimMax), ylim=c(0,maxer), type='n', bty='n', xlab="Percent Similarity", ylab=expression(paste("Number of species per ",OTU[i])), main="") 
axis(side=1, at=seq(OsimMin, OsimMax))
for(i in OsimMin:OsimMax){
  r <- round(runif(1, 0, 255),0)
  g <- round(runif(1, 0, 255),0)
  b <- round(runif(1, 0, 255),0)
  group <- Oclust$count[which(Oclust$sim == i)]
  #lines(rep(i, length(group)), group,  type='b', pch=19) 
  lines(seq(i-0.25,i+0.25, length.out=length(group)), group, pch=19,type='p', col=rgb(red=r,green=g,blue=b, maxColorValue=255), lwd=2) 
}
dev.off()

store1 <- rep(NA, length(UsimMin:UsimMax))
s <- 1
for(g in UsimMin:UsimMax){
    store1[s] <- sum(subset(Uclust, sim == g)[,3])/length(subset(Uclust, sim == g)[,3])
    s <- s+1
  }

store <- rep(NA, length(UsimMin:UsimMax))
s <- 1
for(g in OsimMin:OsimMax){
  store[s] <- sum(subset(Oclust, sim == g)[,3])/length(subset(Oclust, sim == g)[,3])
  s <- s+1
  }

UGmin <- (UsimMin:UsimMax)[which(store1 == min(store1))]
OGmin <- (OsimMin:OsimMax)[which(store == min(store))]
Gmins <- c(UGmin, OGmin)
#Find way to only search for minima between these two limits!!!!

pdf(file="test_bothClust.pdf")
par(mar=c(5,4,4,5))
plot(OsimMin:OsimMax,store, xaxt="n", type="b", col='red', pch=19, xlab="Percent Similarity", ylab="", main="")
axis(side=1, at=seq(OsimMin, OsimMax))

lines(UsimMin:UsimMax,store1, type="b", col='blue', pch=19)

#par(new=T)
#plot(80:100,store1, type="b", col='blue', pch=19, xlab="Percent Similarity", ylab="Umm ...")
axis(4)
mtext(text="Average degree of under clustering", line=2.5, side=4, las=3, col="blue")
mtext(text="Average degree of over clustering", line=2.5, side=2, las=3, col="red")
dev.off()

pdf(file="test_summateClust.pdf")
par(mar=c(5,5,4,5))
plot(OsimMin:OsimMax,log((store1-store+0.00002)^2), xaxt="n",type='b', pch=19, xlab="Percent Simlarity", ylab=expression(paste("log ","(","(",y[1], " - ", y[2],")"^2, ")")))
axis(side=1, at=seq(OsimMin, OsimMax))
dev.off()


formula = (store1 - store)^2 + store1 + store

#lows <- which( ((store1-store)^2) == min((store1-store)^2) )

lows = which(formula == min(formula))

pdf(file="test_formulaClust.pdf")
par(mar=c(5,5,4,2))
plot(OsimMin:OsimMax,log(formula), xaxt="n",type='b', pch=19, col="grey50", xlab="Percent Simlarity", ylab=expression(paste( "ln( (", o[i] - u[i], ")"^2, " + ", o[i], " + ", u[i], ")" )))

points( (OsimMin:OsimMax)[c(lows)], log(formula[lows]), pch=19)

#points(91, 0.71, pch=19, col = "red")
axis(side=1, at=seq(OsimMin, OsimMax))
dev.off()


sink("bestSpeciesSim.txt")
cat("m value(s):\n")
cat(log(formula[lows]))
cat("\n")
cat("best OTU similarity cutoff for sequence(s) and group(s)\n")
cat((OsimMin:OsimMax)[c(lows)])
sink()
