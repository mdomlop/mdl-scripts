NAME    = mdl-scripts
PREFIX  = /usr/local
DESTDIR =
SOURCEDIR = source

SH_FILES_IN := $(wildcard $(SOURCEDIR)/*.sh)
SCRIPTS := $(notdir $(wildcard $(SOURCEDIR)/*.sh))
INSTALLEDSCRIPTS := $(addprefix $(DESTDIR)$(PREFIX)/bin/,$(basename $(SCRIPTS)))

define PROCESS_SH
	head -n7 $(1) | tail -n6 | cut -c3-
endef

print:
	$(SCRIPTS)
	$(INSTALLEDSCRIPTS)

README.md: README.in README.aux
	cat $^ > $@

README.aux: $(SH_FILES_IN)
	$(foreach sh_file,$^,$(call PROCESS_SH,$(sh_file)) >> $@;)
	#for i in source/*.sh; do head -n7 $i | tail -n6 | cut -c3-; done >> $@


install: $(INSTALLEDSCRIPTS)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(NAME)/README

$(DESTDIR)$(PREFIX)/bin/%: $(SOURCEDIR)/%.sh
	install -Dm 755 $^ $@

uninstall:
	rm -f $(INSTALLEDSCRIPTS)

clean:
	rm -f README.aux
	rm -rf pkg
	rm -rf src
	rm -f $(NAME)-*.pkg.*

pkg_arch:
	makepkg -df PKGDEST=./ BUILDDIR=./
