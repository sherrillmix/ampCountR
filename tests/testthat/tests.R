library(ampCounter)
context("DNA basics")
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
