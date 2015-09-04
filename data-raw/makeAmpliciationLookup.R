##File name: makeAmpliciationLookup.R
##Creation date: Aug 31, 2015
##Last modified: Thu Sep 03, 2015  03:00PM
##Created by: scott
##Summary: Generate the lookup table in /data

amplificationLookup<-generateAmplificationTable(1000,1000)
save(amplificationLookup,file='data/amplificationLookup.RData')
tools::resaveRdaFiles('data/amplificationLookup.RData')
