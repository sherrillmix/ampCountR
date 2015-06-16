##File name: ampCounter.R
##Creation date: Jun 15, 2015
##Last modified: Tue Jun 16, 2015  11:00AM
##Created by: scott
##Summary: Count amplification fold expected for multiple strand displacement


countAmplifications<-function(forwards,reverses,strand='+',fragmentStart=1,fragmentEnd=Inf,baseName='',expectedLength=50000,vocal=FALSE){
	if(any(diff(forwards)<1)||any(diff(reverses)<1))stop(simpleError('Expects sorted primer positions')) #could handle ahead of time
	if(strand=='+'){
		thisStarts<-forwards[forwards>=fragmentStart&forwards<=fragmentEnd] #ignores primer length for now
		if(length(thisStarts)==0)return(NULL)
		thisEnds<-thisStarts+expectedLength
		thisEnds[thisEnds>=fragmentEnd]<-fragmentEnd
		isTerminal<-diff(c(-Inf,thisStarts))>expectedLength
	}else{
		thisEnds<-reverses[reverses>=fragmentStart&reverses<=fragmentEnd] #ignores primer length for now
		if(length(thisEnds)==0)return(NULL)
		thisStarts<-thisEnds-expectedLength
		thisStarts[thisStarts<=fragmentStart]<-fragmentStart
		isTerminal<-diff(c(thisEnds,Inf))> expectedLength
	}
	nFrags<-length(thisStarts)
	nDigits<-ceiling(log10(nFrags+1))
	sprintfPattern<-sprintf('%%s%s%%0%dd',ifelse(baseName=='','','_'),nDigits)
	out<-data.frame(
		'start'=thisStarts,
		'end'=thisEnds,
		'strand'=strand,
		'name'=sprintf(sprintfPattern,baseName,1:nFrags),
		stringsAsFactors=FALSE
	)
	if(any(!isTerminal)){
		daughters<-do.call(rbind,mapply(function(start,end,name){
				if(vocal)cat('.')
				countAmplifications( forwards, reverses, strand=ifelse(strand=='+','-','+'), start, end, expectedLength=expectedLength, baseName=name)
		},
		out[!isTerminal,'start'],out[!isTerminal,'end'],out[!isTerminal,'name'],SIMPLIFY=FALSE))
		out<-rbind(out,daughters)
	}
	return(out)
}

plotFrags<-function(frags,forwards,reverses,label=TRUE){
	frags<-frags[order(frags$name,decreasing=TRUE),]
	nFrags<-nrow(frags)
	plot(1,1,type='n',xlim=range(frags[,c('start','end')]),ylim=c(1,nFrags)+c(-.5,.5),xlab='Genome position (nt)',ylab='Fragment',yaxs='i')
	arrows(ifelse(frags$strand=='+',frags$start,frags$end),1:nFrags,ifelse(frags$strand=='+',frags$end,frags$start),1:nFrags,length=.02)
	if(label)text(apply(frags[,c('start','end')],1,mean),1:nFrags,frags$name,col='#00000077',adj=c(0.5,0),cex=.6)
}

generateRandomPrimers<-function(genomeSize,frequency){
	nPrimers<-round(genomeSize/frequency)
	out<-unique(sort(ceiling(runif(nPrimers,1,genomeSize))))
	return(out)
}

#inefficient check coverage
#starts:starts of coverage ranges
#ends:ends of coverage ranges
countCover<-function(starts,ends,vocal=FALSE){
	cover<-rep(0,max(ends))	 #bad for big empty genome
	mapply(function(start,end){
		if(vocal)if(runif(1)<.01)cat('.')
		cover[start:end]<<-cover[start:end]+1
	},starts,ends) #global abuse
	return(cover)
}

