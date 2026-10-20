NAME := russell
VERSION := 3.3
RPM_TARGET ?= i686
TOPDIR := $(CURDIR)/rpmbuild
SOURCES := $(TOPDIR)/SOURCES
TARBALL := $(SOURCES)/$(NAME)-$(VERSION).tar.gz
SPEC := $(CURDIR)/$(NAME).spec

.PHONY: rpm srpm source clean FORCE

rpm: source
	rpmbuild --target $(RPM_TARGET) -ba --define "_topdir $(TOPDIR)" $(SPEC)

srpm: source
	rpmbuild --target $(RPM_TARGET) -bs --define "_topdir $(TOPDIR)" $(SPEC)

source: FORCE $(TARBALL)

FORCE:

$(TARBALL): FORCE
	mkdir -p $(SOURCES)
	git -C .. archive --format=tar --prefix=$(NAME)-$(VERSION)/ HEAD | gzip -n > $@

clean:
	rm -rf $(TOPDIR)
