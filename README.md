# ampCounter
Some R functions to count the expected amplifications for genomic regions given a set of primer binding locations for a [multiple displacement amplification](http://en.wikipedia.org/wiki/Multiple_displacement_amplification) reaction. To install directly from github, use the [<code>devtools</code>](https://github.com/hadley/devtools) library and run:
```
devtools::install_github('sherrillmix/ampCounter')
```

The main functions are:
* <code>countAmplifications(x,y)</code> to count the number of amplifications predicted for a region with <code>x</code> upstream and <code>y</code> downstream primers (within range and correctly oriented). For example:

        countAmplifications(10,20)

* <code>enumerateAmplifications()</code> to list the expected amplification products. For example:
    
        enumerateAmplifications(forwardPrimerLocations,reversePrimerLocations,vocal=TRUE)
    
    A simple example of 3 forward primers and 3 reverse primers is:
    
        forwards<-c(10,20,30)
        reverses<-c(50,60,70)
        frags<-enumerateAmplifications(forwards,reverses,expectedLength=120)
        plotFrags(frags)
        abline(v=forwards,lty=2,col='#FF000033')
        abline(v=reverses,lty=2,col='#0000FF33')
    
    This generates predicted fragments of:
    ![Predicted fragments from 3 forward, 3 reverse primers](example3x3primers.png)

    This function is bit slow since it uses recursion without dynamic programming but <code>countAmplifications()</code> should easily handle any large sets.

A longer example (also accessible from <code>example(ampCounter)</code>:
```R
devtools::install_github('sherrillmix/ampCounter')
library(ampCounter)
forwards<-ampCounter:::generateRandomPrimers(100000,1000)
reverses<-ampCounter:::generateRandomPrimers(100000,1000)
amps<-predictAmplifications(forwards,reverses,maxLength=10000)
par(mar=c(3.5,3.5,.2,.2))
plot(1,1,type='n',xlim=c(1,100000),ylim=c(1,max(amps)),
     xlab='Position',ylab='Amplifications',log='y')
segments(amps$start,amps$amplification,amps$end,amps$amplification)
segments(amps$end[-nrow(amps)],amps$amplification[-nrow(amps)],amps$start[-1],amps$amplification[-1])
abline(v=forwards,col='#FF000044',lty=2)
abline(v=reverses,col='#0000FF44',lty=2)
```
This generates an example predicted fold enrichments of:
![Example of fold enrichment predictions](predictedEnrichmentExample.png)

