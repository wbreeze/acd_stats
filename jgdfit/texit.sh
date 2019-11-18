mkdir -p texout
latex -interaction=nonstopmode -draftmode -output-directory=texout main.tex
cp references.bib texout
cd texout
bibtex main
cd ..
latex -interaction=nonstopmode -draftmode -output-directory=texout main.tex
latex -interaction=nonstopmode -output-format=pdf -output-directory=texout main.tex
mv texout/main.pdf jgdfit201911.pdf
