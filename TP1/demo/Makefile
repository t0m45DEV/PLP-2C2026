.PHONY = all clean

LATEX = pdflatex
TEX = demo.tex
PDF = ejercicio-11.pdf

all: $(PDF)

$(PDF) : $(TEX)
	$(LATEX) $<

clean:
	@rm -f *.log *.pdf *.aux *.vrb
