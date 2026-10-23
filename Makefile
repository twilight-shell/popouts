PREFIX ?= /usr
QMLDIR ?= $(PREFIX)/lib/qt6/qml
DEST = $(DESTDIR)$(QMLDIR)/Twilight/Popouts

install:
	install -d $(DEST)
	cp -r Twilight/Popouts/. $(DEST)

uninstall:
	rm -rf $(DEST)

.PHONY: install uninstall
