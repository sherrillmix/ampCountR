context("Amplification counting")
test_that("Test amplification table",{
	expect_that(amplificationLookup[1,1], equals(0))
	expect_that(amplificationLookup[1,2], equals(0))
	expect_that(sum(amplificationLookup[1,]), equals(0))
	expect_that(sum(amplificationLookup[2,]), equals(ncol(amplificationLookup)))
	expect_that(rownames(amplificationLookup)[1], equals('0'))
	expect_that(colnames(amplificationLookup)[1], equals('0'))
	expect_that(amplificationLookup['2','2'], equals(5))
	expect_that(amplificationLookup['3','3'], equals(19))
})

test_that("Test countAmplifications",{
	expect_that(countAmplifications(0,0), equals(0))
	expect_that(countAmplifications(0,9), equals(0))
	expect_that(countAmplifications(1,1), equals(1))
	expect_that(countAmplifications(20,0), equals(20))
	expect_that(countAmplifications(3,3), equals(19))
	expect_that(countAmplifications(2,2), equals(5))
	expect_that(countAmplifications(301,301), throws_error("limited to"))  #not really a desired outcome but have to cut somewhere
})

test_that("Test countAmplifications with non terminal start",{
	expect_that(countAmplifications(0,0,FALSE), equals(0))
	expect_that(countAmplifications(0,9,FALSE), equals(0))
	expect_that(countAmplifications(1,1,FALSE), equals(2))
	expect_that(countAmplifications(20,0,FALSE), equals(20))
	expect_that(countAmplifications(2,3,FALSE), equals(18))
	expect_that(countAmplifications(3,2,FALSE), equals(18))
	expect_that(countAmplifications(2,2,FALSE), equals(10))
	expect_that(countAmplifications(301,301,FALSE), throws_error("limited to"))  #not really a desired outcome but have to cut somewhere
})

test_that("Test countAmplifications counting one forward at a time",{
	expect_that(countAmplifications(0,0,FALSE,TRUE), equals(0))
	expect_that(countAmplifications(0,9,FALSE,TRUE), equals(0))
	expect_that(countAmplifications(1,1,FALSE,TRUE), equals(2))
	expect_that(countAmplifications(20,0,FALSE,TRUE), equals(1))
	expect_that(countAmplifications(2,2,FALSE,TRUE), equals(6))
	expect_that(countAmplifications(2,1,TRUE,TRUE), equals(1))
	expect_that(countAmplifications(2,1,FALSE,TRUE), equals(2))
	expect_that(countAmplifications(2,100,TRUE,TRUE), equals(1))
	expect_that(countAmplifications(100,10,TRUE,TRUE), equals(1))
	expect_that(countAmplifications(3,3,TRUE,TRUE)+countAmplifications(2,3,FALSE,TRUE)+countAmplifications(1,3,FALSE,TRUE), equals(countAmplifications(3,3)))
	expect_that(countAmplifications(10,3,TRUE,TRUE)+sum(sapply(9:1,countAmplifications,3,FALSE,TRUE)), equals(countAmplifications(10,3)))
	expect_that(countAmplifications(15,5,TRUE,TRUE)+sum(sapply(14:1,countAmplifications,5,FALSE,TRUE)), equals(countAmplifications(15,5)))
	expect_that(countAmplifications(301,301,FALSE,TRUE), throws_error("limited to"))  #not really a desired outcome but have to cut somewhere
})

test_that("Test enumerateAmplifications",{
	expect_that(nrow(enumerateAmplifications(c(),c())), is_null())
	expect_that(nrow(enumerateAmplifications(c(),1:9)), is_null())
	expect_that(nrow(enumerateAmplifications(1,10)), equals(1))
	expect_that(nrow(enumerateAmplifications(1:20,c())), equals(20))
	expect_that(nrow(enumerateAmplifications(1:3,4:6)), equals(19))
	expect_that(enumerateAmplifications(23,c())$start, equals(23))
	expect_that(sort(enumerateAmplifications(1:2,5)$previousLength), equals(c(0,0,4)))
	expect_that(sort(enumerateAmplifications(1:2,9:10)$previousLength), equals(c(0,0,8,9,16)))
})

test_that("Test predictAmplificationsSingleStrand",{
	expect_that(max(predictAmplificationsSingleStrand(1:3,4:6)$amplification), equals(19))
	expect_that(predictAmplificationsSingleStrand(3:1,6:4), equals(predictAmplificationsSingleStrand(1:3,4:6)))
	expect_that(predictAmplificationsSingleStrand(3:1,6:4), equals(predictAmplificationsSingleStrand(c(2,3,1),c(6,4,5))))
	expect_that(nrow(predictAmplificationsSingleStrand(1:3,4:6,10)), equals(8))
	expect_that(nrow(predictAmplificationsSingleStrand(1,c())), equals(1))
	expect_that(nrow(predictAmplificationsSingleStrand(c(),1)), equals(1))
	expect_that(nrow(predictAmplificationsSingleStrand(1:100,c())), equals(199))
	expect_that(max(predictAmplificationsSingleStrand(c(),1:100)$amplification), equals(0))
	expect_that(max(predictAmplificationsSingleStrand(1,c())$amplification), equals(1))
	expect_that(nrow(predictAmplificationsSingleStrand(1:3,4:6,3)), equals(6))
	expect_that(nrow(predictAmplificationsSingleStrand(1,3,3)), equals(1))
	expect_that(predictAmplificationsSingleStrand(1,3,3)$amplifications, equals(1))
	expect_that(predictAmplificationsSingleStrand(c(1,3),3,3)$amplifications, equals(c(1,3,1)))
	expect_that(predictAmplificationsSingleStrand(c(1,3),c(3,5),3)$amplifications, equals(c(1,5,1)))
	expect_that(predictAmplificationsSingleStrand(c(1,3),c(3,5),3)$start, equals(c(1,3,4)))
	expect_that(predictAmplificationsSingleStrand(c(1,3),c(3,5),3)$end, equals(c(2,3,5)))
	expect_that(predictAmplificationsSingleStrand(1:2,15,10)$amplifications, equals(c(1,2,2,1,0)))
	expect_that(predictAmplificationsSingleStrand(1:2,15,10)$amplifications, equals(c(1,2,2,1,0)))
	expect_that(predictAmplificationsSingleStrand(1:2,15:16,10)$amplifications, equals(c(1,2,2,2,1,0,0)))
})

test_that("Test predictAmplifications",{
	expect_that(max(predictAmplifications(1:3,4:6)$amplification), equals(38))
	expect_that(predictAmplifications(3:1,6:4), equals(predictAmplifications(1:3,4:6)))
	expect_that(predictAmplifications(3:1,6:4), equals(predictAmplifications(c(3,1,2),c(4,6,5))))
	expect_that(nrow(predictAmplifications(1:3,4:6,10)), equals(8))
	expect_that(nrow(predictAmplifications(1,c())), equals(1))
	expect_that(nrow(predictAmplifications(c(),1)), equals(1))
	expect_that(nrow(predictAmplifications(1:100,c())), equals(199))
	expect_that(nrow(predictAmplifications(c(),1e6+1:100,100)), equals(199))
	expect_that(max(predictAmplifications(c(),1)$amplification), equals(1))
	expect_that(max(predictAmplifications(1,c())$amplification), equals(1))
	expect_that(max(predictAmplifications(c(),1:100)$amplification), equals(100))
	expect_that(max(predictAmplifications(1:100,c())$amplification), equals(100))
	expect_that(max(predictAmplifications(1:500,c())$amplification), throws_error("limited to"))
	expect_that(max(predictAmplifications(c(),1:500)$amplification), throws_error("limited to"))
	expect_that(nrow(predictAmplifications(1:3,4:6,3)), equals(6))
	expect_that(nrow(predictAmplifications(1,3,3)), equals(1))
	expect_that(predictAmplifications(1,3,3)$amplifications, equals(2))
	expect_that(predictAmplifications(c(1,3),3,3)$amplifications, equals(c(2,4,1)))
	expect_that(predictAmplifications(c(1,3),c(3,5),3)$amplifications, equals(c(2,10,2)))
	expect_that(predictAmplifications(c(1,3),c(3,5),3)$start, equals(c(1,3,4)))
	expect_that(predictAmplifications(c(1,3),c(3,5),3)$end, equals(c(2,3,5)))
	expect_that(predictAmplifications(1:2,15,10)$amplifications, equals(c(1,2,3,2,1)))
	expect_that(predictAmplifications(1:2,15:16,10)$amplifications, equals(c(1,2,3,4,3,2,1)))
})

test_that("Test consistency",{
	expect_that(max(predictAmplifications(1:100,c())$amplification), equals(countAmplifications(100,0)))
	expect_that(max(predictAmplifications(1:5,7:11)$amplification), equals(2*countAmplifications(5,5)))
	expect_that(max(predictAmplifications(1:10,11:20)$amplification), equals(2*countAmplifications(10,10)))
	expect_that(nrow(enumerateAmplifications(1:5,7:11)), equals(countAmplifications(5,5)))
	expect_that(nrow(enumerateAmplifications(1:3,7:9)), equals(countAmplifications(3,3)))
	expect_that(nrow(enumerateAmplifications(1:3,c())), equals(countAmplifications(3,0)))
	expect_that(nrow(enumerateAmplifications(1,2:101)), equals(countAmplifications(1,100)))
})

test_that("Test generateAmplificationTable",{
	expect_that(generateAmplificationTable(20,20)[4,4], equals(19))
	expect_that(generateAmplificationTable(20,20)['3','3'], equals(19))
	expect_that(generateAmplificationTable(44,53)['2','2'], equals(5))
	expect_that(dim(generateAmplificationTable(100,100)), equals(c(101,101)))
	expect_that(dim(generateAmplificationTable(100,50)), equals(c(101,51)))
	expect_that(sum(generateAmplificationTable(100,50)[1,]), equals(0))
	expect_that(sum(generateAmplificationTable(100,50)['0',]), equals(0))
	expect_that(sum(generateAmplificationTable(100,50)['1',]), equals(51))
	expect_that(rownames(generateAmplificationTable(100,50)), equals(as.character(0:100)))
	expect_that(colnames(generateAmplificationTable(100,50)), equals(as.character(0:50)))
	expect_that(sum(is.na(generateAmplificationTable(100,50))), equals(0))
})

test_that("Test generateRandomPrimers",{
	expect_true(max(sapply(replicate(1000,ampcountr:::generateRandomPrimers(1000,20)),max))<=1000)
	expect_true(min(sapply(replicate(1000,ampcountr:::generateRandomPrimers(1000,20)),min))>=1)
	expect_true(abs(mean(sapply(replicate(1000,ampcountr:::generateRandomPrimers(1000,20)),length))-1000/20)<10) #not 100% guarantee but extremely rare
	expect_true(abs(mean(sapply(replicate(1000,ampcountr:::generateRandomPrimers(5000,20)),length))-5000/20)<20) #not 100% guarantee but extremely rare
	expect_true(min(sapply(replicate(1000,ampcountr:::generateRandomPrimers(5000,20)),length))>0) 
})


#kind of cheesy testing but I guess it should error if anything goes horribly wrong
test_that("Test plotFrags",{
  expect_true(is.null(plotFrags(enumerateAmplifications(c(10,20,30),c(40,50,60),maxLength=100))))
  expect_true(is.null(plotFrags(enumerateAmplifications(c(1),c(2)))))
  expect_true(is.null(plotFrags(enumerateAmplifications(c(1),c()))))
  expect_true(is.null(plotFrags(enumerateAmplifications(c(1),c()),label=FALSE)))
  expect_true(is.null(plotFrags(enumerateAmplifications(c(),c(1))))) #could throw an error here but if it's in a loop then better to give empty plot
  expect_true(is.null(plotFrags(NULL))) #equivalent to the above
  expect_true(is.null(plotFrags(enumerateAmplifications(c(1),c())[0,]))) #equivalent to the above
})
