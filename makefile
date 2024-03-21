NAME    = mdl-scripts
PREFIX  = /usr
DESTDIR = 
SOURCEDIR = source

SCRIPTS := $(notdir $(wildcard $(SOURCEDIR)/*.sh))
INSTALLEDSCRIPTS := $(addprefix $(DESTDIR)$(PREFIX)/bin/,$(basename $(SCRIPTS)))

print:
	$(SCRIPTS)
	$(INSTALLEDSCRIPTS)

install: $(INSTALLEDSCRIPTS)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(NAME)/README

$(DESTDIR)$(PREFIX)/bin/%: $(SOURCEDIR)/%.sh
	install -Dm 755 $^ $@

uninstall:
	rm -f $(INSTALLEDSCRIPTS)

clean:
	rm -rf pkg
	rm -rf src
	rm -f $(NAME)-*.pkg.*

pkg_arch:
	makepkg -df PKGDEST=./ BUILDDIR=./
