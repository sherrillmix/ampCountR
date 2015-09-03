% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ampCounter.R
\name{countAmplifications}
\alias{countAmplifications}
\title{Calculate expected multiple strand displacement amplification using lookup table}
\usage{
countAmplifications(nForwards, nReverses)
}
\arguments{
\item{nForwards}{Calculate the expected amplifcations for a region with nForwards primers 5' on the correct strand and within range}

\item{nReverses}{Calculate the expected amplifcations for a region with nReverses primers 3' on the correct strand and within range}
}
\value{
The number of expected amplifications
}
\description{
Uses the amplificationLookup table stored in the package data to predict amplification based on the number of forward and reverse primers spanning a region. To keep the lookup table small, I limited this to 1000 forward and reverse primers but it could be extended easily.
}
\examples{
countAmplifications(20,20)
countAmplifications(0,20)
countAmplifications(20,0)
}
\concept{
multiple strand displacement amplification fragment prediction dynamic programming
}
