##File name: makeAmpliciationLookup.R
##Creation date: Aug 31, 2015
##Last modified: Thu Oct 01, 2015  08:00AM
##Created by: scott
##Summary: Generate the lookup table in /data

amplificationLookup<-ampCountR::generateAmplificationTable(300,300)
save(amplificationLookup,file='data/amplificationLookup.RData')
tools::resaveRdaFiles('data/amplificationLookup.RData')
