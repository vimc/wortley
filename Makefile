RSCRIPT = Rscript --no-init-file

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

roxygen:
	@mkdir -p man
	${RSCRIPT} -e "library(methods); devtools::document()"

install:
	R CMD INSTALL .

build:
	R CMD build .

check:
	_R_CHECK_CRAN_INCOMING_=FALSE make check_all

check_all:
	${RSCRIPT} -e "rcmdcheck::rcmdcheck(args = c('--as-cran', '--no-manual'))"

vignettes/%.Rmd: vignettes/src/%.R
	${RSCRIPT} -e 'library(sowsear); sowsear("$<", output="$@")'

## This will eventually swap out for devtools::build_vignettes(), but
## in current version it's not working when offline.  For now I'll
## just do the copy manually.
vignettes: vignettes/montagu.Rmd
	${RSCRIPT} -e 'tools::buildVignettes(dir = ".")'
	mkdir -p inst/doc
	cp vignettes/*.html vignettes/*.Rmd inst/doc

.PHONY: test roxygen install build check check_all vignettes