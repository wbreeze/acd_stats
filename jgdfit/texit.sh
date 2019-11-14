mkdir -p texout
latex -interaction=nonstopmode -draftmode -output-directory=texout main.tex
latex -interaction=nonstopmode -output-format=pdf -output-directory=texout main.tex
mv texout/main.pdf .
