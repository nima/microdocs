Microdocs := $(wildcard 0x*)

help:
	@echo "Microdocs Developer Help"
	@echo "    help:    Thist (make) target"
	@echo "    list:    List Microdocs"
	@echo "    all:     Compile all Microdocs"
	@echo "    install: Install Microdocs LaTeX class and BiBTeX files to ~/.texmf"

list:
	@for tex in 0x*/microdoc.tex; do \
		file=$$(dirname $$tex); \
		printf "$$file..."; \
		awk -F '[{}]' '$$0 ~ /theTitle/ { print $$4 }' $$tex; \
	done

prep: $(Microdocs:=/.prep)
0x%/.prep:
	@cd $(@D) && ln -sf ../Makefile.microdoc Makefile

all: prep $(Microdocs:=/.done)
	@echo "All microdocs have compiled successfully."
0x%/.done: 0x%/microdoc.tex
	@printf " * Microdoc $(@D)..."
	@cd $(@D) && $(MAKE) pub
	@#> /dev/null 2>&1
	@touch $@
	@echo "Done"

install: $(HOME)/.texmf/tex/latex/microdoc.cls $(HOME)/.texmf/bibtex/bib/autonomy.bib
	@echo "Installation completed successfully."
$(HOME)/.texmf/tex/latex/microdoc.cls: .texmf/tex/latex/microdoc.cls
	@mkdir -p $(@D)
	@cp -a $< $@
$(HOME)/.texmf/bibtex/bib/autonomy.bib: .texmf/bibtex/bib/autonomy.bib
	@mkdir -p $(@D)
	@cp -a $< $@

clean:
	@$(foreach MD,$(Microdocs),\
		cd $(MD) \
			&& ln -sf ../Makefile.microdoc Makefile \
			&& $(MAKE) clean \
			&& rm -f .done \
			&& cd ..; \
	)

.PHONY: all list prep clean help $(Microdocs)
