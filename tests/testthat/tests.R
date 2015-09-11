library(ampCounter)
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
	expect_that(countAmplifications(1000,1000), equals(Inf)) #not really a desired outcome but not worth dealing with arbitrary precision
	expect_that(countAmplifications(1001,1001), throws_error()) #not really a desired outcome but have to cut somewhere
})

test_that("Test enumerateAmplifications",{
	expect_that(nrow(enumerateAmplifications(c(),c())), is_null())
	expect_that(nrow(enumerateAmplifications(c(),1:9)), is_null())
	expect_that(nrow(enumerateAmplifications(1,10)), equals(1))
	expect_that(nrow(enumerateAmplifications(1:20,c())), equals(20))
	expect_that(nrow(enumerateAmplifications(1:3,4:6)), equals(19))
	expect_that(enumerateAmplifications(23,c())$start, equals(23))
})

test_that("Test predictAmplificationsSingleStrand",{
	expect_that(max(predictAmplificationsSingleStrand(1:3,4:6)$amplification), equals(19))
	expect_that(nrow(predictAmplificationsSingleStrand(1:3,4:6,10)), equals(8))
	expect_that(nrow(predictAmplificationsSingleStrand(1,c())), equals(1))
	expect_that(nrow(predictAmplificationsSingleStrand(c(),1)), equals(1))
	expect_that(nrow(predictAmplificationsSingleStrand(1:100,c())), equals(199))
	expect_that(max(predictAmplificationsSingleStrand(c(),1:100)$amplification), equals(0))
	expect_that(max(predictAmplificationsSingleStrand(1,c())$amplification), equals(1))
})

test_that("Test predictAmplifications",{
	expect_that(max(predictAmplifications(1:3,4:6)$amplification), equals(38))
	expect_that(nrow(predictAmplifications(1:3,4:6,10)), equals(8))
	expect_that(nrow(predictAmplifications(1,c())), equals(1))
	expect_that(nrow(predictAmplifications(c(),1)), equals(1))
	expect_that(nrow(predictAmplifications(1:100,c())), equals(199))
	expect_that(nrow(predictAmplifications(c(),1e6+1:100,1000)), equals(199))
	expect_that(max(predictAmplifications(c(),1)$amplification), equals(1))
	expect_that(max(predictAmplifications(1,c())$amplification), equals(1))
	expect_that(max(predictAmplifications(c(),1:100)$amplification), equals(100))
	expect_that(max(predictAmplifications(1:100,c())$amplification), equals(100))
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
