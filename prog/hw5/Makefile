doc = hw5.Rmd

render2pdf: $(doc)
	Rscript -e "if(! require(rmarkdown)) install.packages('rmarkdown');" \
	-e "rmarkdown::render('$(doc)', 'pdf_document')"

clean:
	rm -rf *_files *_cache .Rhistory *\#* .\#* *.tar.gz *~
