# Somewhat overengineered Makefile. Damn I'm rusty with this stuff

SRCDIR = src
STATIC_FILES = index.html
SOURCE_FILES = \
	utils.iced \
	vec2.iced \
	jengine.iced \
	game.iced

OUTDIR = bin
OUTFILE = $(OUTDIR)/game.min.js
TEMPDIR = lib
TEMPFILE = $(TEMPDIR)/all.js

build: $(OUTFILE) $(addprefix $(OUTDIR)/, $(STATIC_FILES))

clean:
	rm -r $(OUTDIR)
	rm -r $(TEMPDIR)

$(addprefix $(OUTDIR)/, $(STATIC_FILES)): $(addprefix $(SRCDIR)/, $(STATIC_FILES))
	@mkdir -p $(OUTDIR)
	cp $(addprefix $(SRCDIR)/, $(STATIC_FILES)) $(addprefix $(OUTDIR)/, $(STATIC_FILES))

$(OUTFILE): $(TEMPFILE)
	@mkdir -p $(OUTDIR)
	uglifyjs $< > $@

$(TEMPFILE): $(addprefix $(SRCDIR)/, $(SOURCE_FILES))
	@mkdir -p $(TEMPDIR)
	iced -j $@ -c $(addprefix $(SRCDIR)/, $(SOURCE_FILES))

.PHONY: build clean
