all: docs package

docs: R/*.R
	R -e 'devtools::document()'

package: docs R/*.R DESCRIPTION
	R -e 'devtools::build()'
