all: 

github:
	./knit github
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md -o madsen-classification-ct_github.md

md:
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md -o madsen-classification-ct.md

odt:
	./knit docx
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md --reference-odt=reference.odt -o madsen-classification-ct.odt


docx:
	./knit docx
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md --reference-docx=reference.docx -o madsen-classification-ct.docx


pdf:
	./knit pdf
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md --template=madsen-classification-ct-xelatex-template.tex --latex-engine=xelatex -o madsen-classification-ct.tex --natbib --number-sections
	latexmk -pdf madsen-classification-ct
	open -a /Applications/Skim.app madsen-classification-ct.pdf


epub:
	./knit epub
	pandoc -s -S --biblio madsen-classification-ct.bib madsen-classification-ct.md -o madsen-classification-ct.epub

bib:
	bibtool -s -d -x citations.aux ~/research/biblio/ct-proposal.bib > madsen-classification-ct.bib


clean:
	latexmk -CA
	rm -rf *.log *.bbl *.blg *.out *.md *.pdf *.docx madsen-classification-ct.tex *.epub
