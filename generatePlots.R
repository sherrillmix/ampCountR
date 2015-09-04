##File name: generatePlots.R
##Creation date: Sep 04, 2015
##Last modified: Fri Sep 04, 2015  09:00AM
##Created by: scott
##Summary: Generate plots for display in readme
library(ampCounter)

forwards<-ampCounter:::generateRandomPrimers(100000,2500)
reverses<-ampCounter:::generateRandomPrimers(100000,2500)
amps<-predictAmplifications(forwards,reverses,maxLength=10000)
amps<-amps[amps$start<100000,]
amps[amps$end>100000,'end']<-100000
png('predictedEnrichmentExample.png',width=1600,height=800,res=200)
	par(mar=c(3,4,.2,.2))
	plot(1,1,type='n',xlim=c(1,100000),ylim=c(.5,max(amps$amplification)*1.3),
		  xlab='',ylab='Amplifications',log='y',las=1,xaxt='n',yaxt='n',yaxs='i',mgp=c(2.75,.5,0))
	title(xlab='Position (kb)',mgp=c(2,.5,0))
	prettyX<-pretty(c(1:1e5)/1e3)
	axis(1,prettyX*1e3,prettyX)
	prettyY<-unique(round(pretty(c(1,log10(amps$amplification)))))
	axis(2,10^prettyY,10^prettyY,las=1)
	segments(amps$start,amps$amplification,amps$end,amps$amplification)
	segments(amps$end[-nrow(amps)],amps$amplification[-nrow(amps)],amps$start[-1],amps$amplification[-1])
	rect(forwards,1,forwards+10000-1,2,col='#FF000011',border=NA)
	rect(reverses,1,forwards-10000+1,.5,col='#0000FF11',border=NA)
	abline(v=reverses,col='#0000FF22',lty=2)
	abline(v=reverses-10000+1,col='#0000FF22',lty=3)
	abline(v=forwards,col='#FF000022',lty=2)
	abline(v=forwards+10000-1,col='#FF000022',lty=3)
	text(50000,1.41,'Forward primer density')
	text(50000,.707,'Reverse primer density')
dev.off()


forwards<-c(10,20,30)
reverses<-c(35,45,55)
frags<-enumerateAmplifications(forwards,reverses,expectedLength=50)
png('example3x3primers.png',width=1000,height=1000,res=250)
	par(mar=c(2.9,2.8,.2,.2),mgp=c(1.9,.75,0),las=1)
	plotFrags(frags)
	abline(v=forwards,lty=2,col='#FF000033')
	abline(v=reverses,lty=2,col='#0000FF33')
dev.off()


