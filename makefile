all: docs package plots

install:
	R -e 'devtools::install_github("sherrillmix/ampCountR")'

plots: generatePlots.R
	Rscript generatePlots.R

docs: R/*.R
	R -e 'devtools::document()'
	touch man

inst/doc: vignettes/*.Rnw
	R -e 'devtools::build_vignettes()'
	touch inst/doc

package: docs R/*.R DESCRIPTION
	R -e 'devtools::check();devtools::build()'
