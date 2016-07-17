default: cedar-14

cedar: dist/cedar/pixman-0.34.0-1.tar.gz dist/cedar/freetype-2.6-1.tar.gz dist/cedar/giflib-5.1.4-1.tar.gz dist/cedar/cairo-1.14.6-1.tar.gz

cedar-14: dist/cedar-14/pixman-0.34.0-1.tar.gz dist/cedar-14/freetype-2.6-1.tar.gz dist/cedar-14/giflib-5.1.4-1.tar.gz dist/cedar-14/pango-1.40.1-1.tar.gz dist/cedar-14/cairo-1.14.6-1.tar.gz dist/cedar-14/fontconfig-2.12.0-1.tar.gz dist/cedar-14/harfbuzz-1.2.7-1.tar.gz

dist/cedar/cairo-1.14.6-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/cairo-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv cairo-cedar.tar.gz $@

dist/cedar/freetype-2.6-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/freetype-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv freetype-cedar.tar.gz $@

dist/cedar/giflib-5.1.4-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/giflib-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv giflib-cedar.tar.gz $@

dist/cedar/pixman-0.34.0-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/pixman-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv pixman-cedar.tar.gz $@

dist/cedar-14/cairo-1.14.6-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/cairo-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv cairo-cedar-14.tar.gz $@

dist/cedar-14/fontconfig-2.12.0-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/fontconfig-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv fontconfig-cedar-14.tar.gz $@

dist/cedar-14/freetype-2.6-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/freetype-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv freetype-cedar-14.tar.gz $@

dist/cedar-14/giflib-5.1.4-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/giflib-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv giflib-cedar-14.tar.gz $@

dist/cedar-14/harfbuzz-1.2.7-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/harfbuzz-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv harfbuzz-cedar-14.tar.gz $@

dist/cedar-14/pango-1.40.1-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/pango-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv pango-cedar-14.tar.gz $@

dist/cedar-14/pixman-0.34.0-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/pixman-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv pixman-cedar-14.tar.gz $@

clean:
	rm -rf src/ cedar*/*.sh dist/ cairo-cedar*/*.tar.*
	-docker rm cairo-cedar
	-docker rm cairo-cedar-14

src/cairo.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/cairo-1.14.6.tar.xz -o $@

src/fontconfig.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.bz2 -o $@

src/freetype.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.bz2 -o $@

src/giflib.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL "http://downloads.sourceforge.net/project/giflib/giflib-5.1.4.tar.bz2" -o $@

src/harfbuzz.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.2.7.tar.bz2 -o $@

src/pango.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.1.tar.xz -o $@

src/pixman.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/pixman-0.34.0.tar.gz -o $@

.PHONY: cedar-stack

cedar-stack: cedar-stack/cedar.sh
	@docker pull nandub/$@ && \
		(docker images -q nandub/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t nandub/$@ $@

cedar-stack/cedar.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar.sh -o $@

.PHONY: cedar-14-stack

cedar-14-stack: cedar-14-stack/cedar-14.sh
	@docker pull nandub/$@ && \
		(docker images -q nandub/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t nandub/$@ $@

cedar-14-stack/cedar-14.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar-14.sh -o $@

.PHONY: cairo-cedar

cairo-cedar: cedar-stack cairo-cedar/pixman.tar.gz cairo-cedar/freetype.tar.bz2 cairo-cedar/giflib.tar.bz2 cairo-cedar/cairo.tar.xz
	docker build --rm -t nandub/$@ $@
	-docker rm $@
	docker run --name $@ nandub/$@ /bin/echo $@

cairo-cedar/cairo.tar.xz: src/cairo.tar.xz
	ln -f $< $@

cairo-cedar/freetype.tar.bz2: src/freetype.tar.bz2
	ln -f $< $@

cairo-cedar/giflib.tar.bz2: src/giflib.tar.bz2
	ln -f $< $@

cairo-cedar/pixman.tar.gz: src/pixman.tar.gz
	ln -f $< $@

.PHONY: cairo-cedar-14

cairo-cedar-14: cedar-14-stack cairo-cedar-14/pixman.tar.gz cairo-cedar-14/freetype.tar.bz2 cairo-cedar-14/giflib.tar.bz2 cairo-cedar-14/cairo.tar.xz cairo-cedar-14/pango.tar.xz cairo-cedar-14/fontconfig.tar.bz2 cairo-cedar-14/harfbuzz.tar.bz2
	docker build --rm -t nandub/$@ $@
	-docker rm $@
	docker run --name $@ nandub/$@ /bin/echo $@

cairo-cedar-14/cairo.tar.xz: src/cairo.tar.xz
	ln -f $< $@

cairo-cedar-14/fontconfig.tar.bz2: src/fontconfig.tar.bz2
	ln -f $< $@

cairo-cedar-14/freetype.tar.bz2: src/freetype.tar.bz2
	ln -f $< $@

cairo-cedar-14/giflib.tar.bz2: src/giflib.tar.bz2
	ln -f $< $@

cairo-cedar-14/harfbuzz.tar.bz2: src/harfbuzz.tar.bz2
	ln -f $< $@

cairo-cedar-14/pango.tar.xz: src/pango.tar.xz
	ln -f $< $@

cairo-cedar-14/pixman.tar.gz: src/pixman.tar.gz
	ln -f $< $@
