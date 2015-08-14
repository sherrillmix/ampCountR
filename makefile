all: docs 

docs: 
	R -e 'devtools::document()'
