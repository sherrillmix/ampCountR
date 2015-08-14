all: docs package

docs: ampCounter.R
	R -e 'devtools::document()'

package: docs ampCounter.R DESCRIPTION
	R -e 'devtools::build()'
