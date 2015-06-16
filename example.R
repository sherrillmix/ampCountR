##File name: example.R
##Creation date: Jun 16, 2015
##Last modified: Tue Jun 16, 2015  11:00AM
##Created by: scott
##Summary: An example coverage prediction on random primers

source('ampCounter.R')

forwards<-generateRandomPrimers(1e6,10000)
reverses<-generateRandomPrimers(1e6,10000)+.5 #+.5 to make sure we don't get any overlaps with forwards
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
cover<-countCover(c(frags$start,revFrags$start),c(frags$end,revFrags$end),vocal=TRUE)+2 #+2 for original + and - strand
pdf('predictedCover.pdf',width=10)
	plot(cover$pos,cover$cover,type='l',ylab='Predicted coverage',xlab='Genome position')
	abline(v=forwards,lty=2,col='#FF000033')
	abline(v=reverses,lty=2,col='#0000FF33')
dev.off()

