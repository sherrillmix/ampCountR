VERSION:=$(shell grep Version: DESCRIPTION|sed 's/Version: //')
NAME:=$(shell grep Package: DESCRIPTION|sed 's/Package: //')
PACKAGEFILE:=../$(NAME)_$(VERSION).tar.gz

all: $(PACKAGEFILE) README.md

.PHONY: all install localInstall

install:
	R -e 'devtools::install_github("sherrillmix/$(NAME)")'

localInstall:
	R -e 'devtools::install()'

plots: generatePlots.R
	Rscript generatePlots.R

man: R/*.R
	R -e 'devtools::document()'
	touch man

inst/doc: vignettes/*.Rnw
	make localInstall
	R -e 'devtools::build_vignettes()'
	touch inst/doc

data: data-raw/makeAmpliciationLookup.R
	Rscript data-raw/makeAmpliciationLookup.R
	touch data

$(PACKAGEFILE): man R/*.R DESCRIPTION tests/testthat/tests.R inst/doc data
	sed -i "s/^Date:.*$$/Date: `date +%Y-%m-%d`/" DESCRIPTION
	R -e 'devtools::check();devtools::build()'
