##File name: example.R
##Creation date: Jun 16, 2015
##Last modified: Tue Jun 16, 2015  11:00AM
##Created by: scott
##Summary: An example coverage prediction on random primers

source('ampCounter.R')

#1Mb genome with primers spaced around every ~5kb (i.e. every 10kb in + or -)
forwards<-generateRandomPrimers(1e6,10000)
#+.5 to make sure we don't get any overlaps with forwards
reverses<-generateRandomPrimers(1e6,10000)+.5
message('Calculating positive strand fragments')
frags<-countAmplifications(forwards,reverses,vocal=TRUE)
message('Calculating negative strand fragments')
revFrags<-countAmplifications(forwards,reverses,vocal=TRUE,strand='-')
revFrags$name<-sprintf('-%s',revFrags$name)
pdf('predictedFragments.pdf',height=100,width=100)
	plotFrags(rbind(frags,revFrags),forwards,reverses,label=FALSE)
	abline(v=forwards,lty=2,col='#FF000033')
	abline(v=reverses,lty=2,col='#0000FF33')
dev.off()

message('Calculating cover')
#+2 for original + and - strand
cover<-countCover(c(frags$start,revFrags$start),c(frags$end,revFrags$end),vocal=TRUE)+2 
#started with two copies so fold enrichment is divide by 2
cover<-cover/2
pdf('predictedCover.pdf',width=10)
	par(mar=c(3.7,3.7,.2,.2))
	plot((1:length(cover)),cover,type='l',ylab='Predicted fold enrichment',xlab='Genome position (100kb)',log='y',las=1,xaxt='n',mgp=c(2.7,1,0))
	prettyX<-pretty(c(1,length(cover)/1e5))
	axis(1,prettyX*1e5,prettyX)
	abline(v=forwards,lty=2,col='#FF000033')
	abline(v=reverses,lty=2,col='#0000FF33')
dev.off()

