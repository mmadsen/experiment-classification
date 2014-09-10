.PHONY : clean

pdf:
	./knit pdf
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md --template=elsarticle-template.tex --latex-engine=xelatex -o madsen2015-classification.tex --natbib --number-sections --listings
	latexmk -pdf madsen2015-classification
	open -a /Applications/Skim.app madsen2015-classification.pdf


github:
	./knit github
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md -o madsen2015-classification_github.md

md:
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md -o madsen2015-classification.md

odt:
	./knit docx
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md --reference-odt=reference.odt -o madsen2015-classification.odt


docx:
	./knit docx
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md --reference-docx=reference.docx -o madsen2015-classification.docx



epub:
	./knit epub
	pandoc -s -S --biblio madsen2015-classification.bib madsen2015-classification.md -o madsen2015-classification.epub


clean:
	latexmk -CA
	rm -rf *.log *.bbl *.blg *.out *.md *.pdf *.docx madsen2015-classification.tex *.epub
