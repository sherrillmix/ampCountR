library(ampCountR)

set.seed(12345)

genomeSize<-1e5
maxLength<-10000 #maximum amplification length expected from polymerase
primerFrequency<-2500 #primer binding site average 1 per 2500 bases

forwards<-ampCountR:::generateRandomPrimers(genomeSize,primerFrequency)
reverses<-ampCountR:::generateRandomPrimers(genomeSize,primerFrequency)
amps<-predictAmplifications(forwards,reverses,maxLength=maxLength)
amps<-amps[amps$start<=genomeSize,]
amps[amps$end>genomeSize,'end']<-genomeSize
png('predictedEnrichmentExample.png',width=1600,height=800,res=200)
	par(mar=c(3,4,.2,.2))
	plot(1,1,type='n',xlim=c(1,genomeSize),ylim=c(.5,max(amps$amplification)*1.3),
		  xlab='',ylab='Amplifications',log='y',las=1,xaxt='n',yaxt='n',yaxs='i',mgp=c(2.75,.5,0))
	title(xlab='Position (kb)',mgp=c(2,.5,0))
	prettyX<-pretty(c(1:1e5)/1e3)
	axis(1,prettyX*1e3,prettyX)
	prettyY<-unique(round(pretty(c(1,log10(amps$amplification)))))
	axis(2,10^prettyY,10^prettyY,las=1)
	segments(amps$start,amps$amplification,amps$end,amps$amplification)
	segments(amps$end[-nrow(amps)],amps$amplification[-nrow(amps)],amps$start[-1],amps$amplification[-1])
	rect(forwards,1,forwards+maxLength-1,2,col='#FF000011',border=NA)
	rect(reverses,1,forwards-maxLength+1,.5,col='#0000FF11',border=NA)
	abline(v=reverses,col='#0000FF22',lty=2)
	abline(v=reverses-maxLength+1,col='#0000FF22',lty=3)
	abline(v=forwards,col='#FF000022',lty=2)
	abline(v=forwards+maxLength-1,col='#FF000022',lty=3)
	text(genomeSize/2,1.41,'Forward primer density')
	text(genomeSize/2,.707,'Reverse primer density')
dev.off()


