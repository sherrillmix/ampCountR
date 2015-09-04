all: docs package plots

install:
	R -e 'devtools::install_github("sherrillmix/ampCounter")'

plots: generatePlots.R
	Rscript generatePlots.R

docs: R/*.R
	R -e 'devtools::document()'

package: docs R/*.R DESCRIPTION
	R -e 'devtools::check();devtools::build()'
