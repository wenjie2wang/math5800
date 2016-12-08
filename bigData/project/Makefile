rmdFile := project_group01.Rmd
pdfFile := $(patsubst %.Rmd, %.pdf, $(rmdFile))
htmlFile := $(patsubst %.Rmd, %.html, $(rmdFile))
slidesFile := slides.Rmd
slidesOut := $(patsubst %.Rmd, %.pdf, $(slidesFile))


.PHONY: all
all: $(pdfFile) $(htmlFile) $(slidesOut)

.PHONY: pdf
pdf: $(pdfFile)

$(pdfFile): $(rmdFile)
	Rscript -e "if(! require(rmarkdown)) install.packages('rmarkdown');" \
	-e "rmarkdown::render('$(rmdFile)', 'pdf_document')"

.PHONY: html
html: $(htmlFile)

$(htmlFile): $(rmdFile)
# sed "s/\\\bm//g" $(rmdFile) >tmp.Rmd;\
# Rscript -e "rmarkdown::render('tmp.Rmd', 'html_document')" ;\
# rm tmp.Rmd;\
# mv tmp.html $(htmlFile)
	Rscript -e "rmarkdown::render('$(rmdFile)', 'html_document')"

.PHONY: slides
slides: $(slidesOut)

$(slidesOut): $(slidesFile)
	Rscript -e "rmarkdown::render('$(slidesFile)')"


.PHONY: clean
clean:
	rm -rf *_files *_cache .Rhistory *\#* .\#* *.tar.gz *~
