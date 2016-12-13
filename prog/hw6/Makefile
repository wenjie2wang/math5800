doc = hw6.Rmd
pdf = hw6.pdf

.PHONY: all
all: hw6.pdf

hw6.pdf: $(doc)
	Rscript -e "if(! require(rmarkdown)) install.packages('rmarkdown');" \
	-e "rmarkdown::render('$(doc)', 'pdf_document')"

clean:
	rm -rf *_files *_cache .Rhistory *\#* .\#* *.tar.gz *~
