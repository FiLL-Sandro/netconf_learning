ROOT := .
OUTPUT_DIR := ${ROOT}/out

all: outdir openyuma

outdir:
	if [ ! -d out ]; then mkdir -p out ; fi

clean-%:
	$(MAKE) -C $*-master clean

clean:
	PREFIX=$$(pwd)/out $(MAKE) -C OpenYuma-master $@
	$(MAKE) -C libxml2-master $@
	$(MAKE) -C libssh2-master $@
	$(MAKE) -C openssl-master $@

openyuma: libxml2 openssl libssh2
	DESTDIR=$$(pwd) PREFIX=/out $(MAKE) -C OpenYuma-master

openyuma_quick:
	DESTDIR=$$(pwd) PREFIX=/out $(MAKE) -C OpenYuma-master

libxml2:
	cd libxml2-master ; ./autogen.sh --prefix=$$(pwd)/../out --without-python
	$(MAKE) -C libxml2-master
	$(MAKE) -C libxml2-master install

libssh2:
	cd libssh2-master ; \
	  autoreconf -fi ; \
	  ./configure --prefix=$$(pwd)/../out --with-crypto=openssl \
	    --with-libssl-prefix=$$(pwd)/../out
	$(MAKE) -C libssh2-master
	$(MAKE) -C libssh2-master install

openssl:
	cd openssl-master ; ./Configure --prefix=$$(pwd)/../out
	$(MAKE) -C openssl-master
# 	$(MAKE) -C openssl-master test
	$(MAKE) -C openssl-master install

# DESTDIR := $$(pwd)
# PREFIX := /out

print-%:
	DESTDIR=${DESTDIR} PREFIX=${PREFIX} echo "$* == ${$*}"

# include /home/fill/Documents/ELTEX_proj/netconf_learning/OpenYuma-master/netconf/src/platform/platform.profile

