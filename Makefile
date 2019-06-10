
.PHONY: clean slides

# Recursive wildcard from https://stackoverflow.com/a/18258352
#
# To find every .c file in src:
#   FILES := $(call rwildcard, ,src/ *.c)
# To find all the .c and .h files in src:
#   FILES := $(call rwildcard, src/, *.c *.h)
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

# Helper rule (so we don't need to care about the path)
slides: out/slides.pdf

# Regenerate the slides if any file changes
#
# Since pdflatex creates the output from the main input
# (e.g., slides.tex -> slides.pdf), replace .pdf in the
# output by .tex (also replaces the directory).
#
# As dumb as this seems, the toc only appears if pdflatex
# is run twice.
out/slides.pdf: $(call rwildcard, slides/, *.tex) | out/.mkdir
	pdflatex -halt-on-error -output-directory=out $(@:out/%.pdf=slides/%.tex)
	pdflatex -halt-on-error -output-directory=out $(@:out/%.pdf=slides/%.tex)

# Automatically creates a directory.
#
# This simply removes the prefix and the suffix using Make's
# substitution command.
%.mkdir:
	mkdir -p $(@D)

clean:
	rm -rf out/
