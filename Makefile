.PHONY: all test dist clean

VERSION ?= 0.1.0
PKGNAME ?= ravn-home-niri
TARBALL ?= $(PKGNAME)-$(VERSION).tar.gz

all: test

test:
	./tests/test_niri.sh

dist: clean
	mkdir -p build/$(PKGNAME)-$(VERSION)
	cp -a bin clavis environment.d niri share tests LICENSE Makefile README.md build/$(PKGNAME)-$(VERSION)/
	tar -czf $(TARBALL) -C build $(PKGNAME)-$(VERSION)
	rm -rf build
	@echo "Generado $(TARBALL): $$(ls -lh $(TARBALL) | awk '{print $$5}')"

clean:
	rm -rf build *.tar.gz
