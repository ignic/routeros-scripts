# Makefile to generate data:
#  template scripts -> final scripts
#  markdown files -> html files

TEMPLATE = $(wildcard *.template.rsc)
CAPSMAN = $(TEMPLATE:.template.rsc=.capsman.rsc)
LOCAL = $(TEMPLATE:.template.rsc=.local.rsc)

MARKDOWN = $(wildcard *.md doc/*.md doc/mod/*.md)
HTML = $(MARKDOWN:.md=.html)

all: $(CAPSMAN) $(LOCAL) $(HTML)

%.html: %.md Makefile
	markdown $< | sed 's/href="\([-_\./[:alnum:]]*\)\.md"/href="\1.html"/g' > $@

%.local.rsc: %.template.rsc Makefile
	sed -e '/\/caps-man/d' -e 's|%TEMPL%|.local|' \
		-e '/^# !!/,/^# !!/c # !! Do not edit this file, it is generated from template!' \
		< $< > $@

%.capsman.rsc: %.template.rsc Makefile
	sed -e '/\/interface\/wireless/d' -e 's|%TEMPL%|.capsman|' \
		-e '/^# !!/,/^# !!/c # !! Do not edit this file, it is generated from template!' \
		< $< > $@

clean:
	rm -f $(HTML)
