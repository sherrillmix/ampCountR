##File name: makeAmpliciationLookup.R
##Creation date: Aug 31, 2015
##Last modified: Mon Aug 31, 2015  11:00AM
##Created by: scott
##Summary: Generate the lookup table in /data

amplificationLookup<-generateAmplificationTable(1000,1000)
save(amplificationLookup,file='data/amplificationLookup.RData')
