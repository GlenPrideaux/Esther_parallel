all: pdf

sources/43-ESGAeng-PrideauxUS.usfm: sources/43-ESGAeng-Prideaux.usfm
	python3 scripts/01-convert-spelling.py uk2us sources/43-ESGAeng-Prideaux.usfm sources/43-ESGAeng-PrideauxUS.usfm
sources/43-ESGAeng-PrideauxBE.usfm: sources/43-ESGAeng-Prideaux.usfm
	python3 scripts/01-convert-spelling.py us2uk sources/43-ESGAeng-Prideaux.usfm sources/43-ESGAeng-PrideauxBE.usfm

build/usfm/eng-web_usfm/43-ESGVeng-web.usfm: sources/43-ESGVeng-web.usfm
	mkdir -p build/usfm/eng-web_usfm
	cp sources/43-ESGVeng-web.usfm build/usfm/eng-web_usfm/
build/usfm/eng-webbe_usfm/43-ESGVeng-webbe.usfm: sources/43-ESGVeng-webbe.usfm
	mkdir -p build/usfm/eng-webbe_usfm
	cp sources/43-ESGVeng-webbe.usfm build/usfm/eng-webbe_usfm/
build/usfm/eng-Prideaux_usfm/43-ESGAeng-Prideaux.usfm: sources/43-ESGAeng-PrideauxUS.usfm
	mkdir -p build/usfm/eng-Prideaux_usfm/
	cp sources/43-ESGAeng-PrideauxUS.usfm build/usfm/eng-Prideaux_usfm/43-ESGAeng-Prideaux.usfm
build/usfm/eng-PrideauxBE_usfm/43-ESGAeng-PrideauxBE.usfm: sources/43-ESGAeng-PrideauxBE.usfm
	mkdir -p build/usfm/eng-PrideauxBE_usfm/
	cp sources/43-ESGAeng-PrideauxBE.usfm build/usfm/eng-PrideauxBE_usfm/

WEB_USFM_ZIP := sources/eng-web_usfm.zip
WEBBE_USFM_ZIP := sources/eng-webbe_usfm.zip

ZIP_FILES := \
	$(WEB_USFM_ZIP) \
	$(WEBBE_USFM_ZIP) 

$(WEB_USFM_ZIP):
	mkdir -p build
	curl -L -o $@ https://ebible.org/Scriptures/eng-web_usfm.zip
$(WEBBE_USFM_ZIP):
	mkdir -p build
	curl -L -o $@ https://ebible.org/Scriptures/eng-webbe_usfm.zip

WEB_USFMS := \
	build/usfm/eng-web_usfm/18-ESTeng-web.usfm \
	build/usfm/eng-web_usfm/18-ESTeng-webbe.usfm

$(WEB_USFMS): scripts/01_unpack_sources.py $(ZIP_FILES)
	python3 scripts/01_unpack_sources.py

USFM_FILES := \
	build/usfm/eng-web_usfm/43-ESGVeng-web.usfm \
	build/usfm/eng-webbe_usfm/43-ESGVeng-webbe.usfm \
	build/usfm/eng-web_usfm/18-ESTeng-web.usfm \
	build/usfm/eng-webbe_usfm/18-ESTeng-webbe.usfm \
	build/usfm/eng-Prideaux_usfm/43-ESGAeng-Prideaux.usfm \
	build/usfm/eng-PrideauxBE_usfm/43-ESGAeng-PrideauxBE.usfm
unpack: $(USFM_FILES)

JSON_FILES := \
	build/json/web_ESGV.json \
	build/json/webbe_ESGV.json \
	build/json/web_EST.json \
	build/json/webbe_EST.json \
	build/json/Prideaux_ESGA.json \
	build/json/PrideauxBE_ESGA.json

$(JSON_FILES): scripts/02_parse_usfm.py $(USFM_FILES)
	python3 scripts/02_parse_usfm.py

json: $(JSON_FILES)

CSV_FILES := build/esther_parallel.csv build/esther_parallel_be.csv

build/esther_parallel.csv: build/json/web_ESGV.json build/json/web_EST.json build/json/Prideaux_ESGA.json scripts/04_build_parallel_csv.py
	python3 scripts/04_build_parallel_csv.py

build/esther_parallel_be.csv: build/json/web_ESGV.json build/json/webbe_EST.json build/json/PrideauxBE_ESGA.json scripts/04_build_parallel_csv.py
	python3 scripts/04_build_parallel_csv.py -b

build/esther.csv build/esther_be.csv: build/json/Prideaux_ESGA.json build/json/PrideauxBE_ESGA.json scripts/04_build_at_csv.py
	python3 scripts/04_build_at_csv.py

csv: $(CSV_FILES)

tex/esther_parallel.tex: scripts/05_csv_to_tex.py build/esther_parallel.csv data/mapping.csv
	python3 scripts/05_csv_to_tex.py

tex/esther_parallel_be.tex: scripts/05_csv_to_tex.py build/esther_parallel_be.csv data/mapping.csv
	python3 scripts/05_csv_to_tex.py -b

tex/esther.tex tex/esther_be.tex: scripts/05_csv_to_at_tex.py build/esther_be.csv build/esther.csv data/mapping.csv
	python3 scripts/05_csv_to_at_tex.py

tex: tex/esther_parallel.tex tex/esther_parallel_be.tex 

TEX_FILES := \
	tex/esther_parallel.tex \
	tex/intro.tex \
	tex/preamble.tex \
	tex/title.tex \
	tex/copyright.tex \
	tex/esther_book.tex
tex/esther_book.pdf: $(TEX_FILES)
	cd tex && latexmk -xelatex -interaction=nonstopmode -halt-on-error esther_book.tex

esther_parallel_book.pdf: tex/esther_book.pdf
	cp tex/esther_book.pdf ./esther_parallel_book.pdf

TEX_FILES_BE := \
	tex/esther_parallel_be.tex \
	tex/intro.tex \
	tex/preamble.tex \
	tex/title.tex \
	tex/copyright.tex \
	tex/esther_book_be.tex
tex/esther_book_be.pdf: $(TEX_FILES_BE)
	cd tex && latexmk -xelatex -interaction=nonstopmode -halt-on-error esther_book_be.tex

esther_parallel_book_be.pdf: tex/esther_book_be.pdf
	cp tex/esther_book_be.pdf ./esther_parallel_book_be.pdf

TEX_FILES_AT := \
	tex/esther.tex \
	tex/intro_at.tex \
	tex/preamble_at.tex \
	tex/title_at.tex \
	tex/copyright_at.tex \
	tex/esther_at_book.tex
tex/esther_at_book.pdf: $(TEX_FILES_AT)
	cd tex && latexmk -xelatex -interaction=nonstopmode -halt-on-error esther_at_book.tex

esther_at_book.pdf: tex/esther_at_book.pdf
	cp tex/esther_at_book.pdf .

TEX_FILES_AT_BE := \
	tex/esther_be.tex \
	tex/intro_at.tex \
	tex/preamble_at.tex \
	tex/title_at.tex \
	tex/copyright_at.tex \
	tex/esther_at_be_book.tex
tex/esther_at_be_book.pdf: $(TEX_FILES_AT_BE)
	cd tex && latexmk -xelatex -interaction=nonstopmode -halt-on-error esther_at_be_book.tex

esther_at_be_book.pdf: tex/esther_at_be_book.pdf
	cp tex/esther_at_be_book.pdf .


pdf: esther_parallel_book.pdf esther_parallel_book_be.pdf esther_at_book.pdf esther_at_be_book.pdf

.PHONY: unpack json csv tex pdf all clean
clean:
	rm -rf build/*
	rm -f tex/*.aux tex/*.log tex/*.out tex/*.pdf
	rm -f tex/esther_book*.fls tex/esther_book*.xdv tex/esther_book*.fdb_latexmk
	rm -f tex/esther_at_book*.fls tex/esther_at_book*.xdv tex/esther_at_book*.fdb_latexmk
	rm -f tex/esther_at_be_book*.fls tex/esther_at_be_book*.xdv tex/esther_at_be_book*.fdb_latexmk
	rm -f tex/esther.tex tex/esther_be.tex tex/esther_parallel.tex tex/esther_parallel_be.tex
