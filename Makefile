ROOT := .
OUTPUT_DIR := ${ROOT}/out

all: outdir openyuma

outdir:
	if [ ! -d out ]; then mkdir -p out/lib ; fi
	cd out/lib ; \
	  if [ ! -e libncurses.so ] ; then \
	    ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 libncurses.so ; \
	  fi

clean-%:
	$(MAKE) -C $*-master clean

clean:
	PREFIX=$$(pwd)/out $(MAKE) -C OpenYuma-master $@
	$(MAKE) -C libxml2-master $@
	$(MAKE) -C libssh2-master $@
	$(MAKE) -C openssl-master $@
	
openyuma: libxml2 openssl libssh2 libz
	$(MAKE) openyuma_quick

openyuma_quick:
	DESTDIR=/. PREFIX=$$(pwd)/out $(MAKE) -C OpenYuma-master

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

libz:
	cd zlib-master ; \
	  prefix=${pwd}../out ./configure ; \
	  $(MAKE) test ; $(MAKE) install

openssl-make-link:
	cd ./out ; \
	  if [ ! -e ./lib/libssl.so.3 ] ; then \
	    ln -s ../lib64/libssl.so.3 ./lib/libssl.so.3 ; \
	  fi ; \
	  if [ ! -e ./lib/libssl.so ] ; then \
	    ln -s ./libssl.so.3 ./lib/libssl.so ; \
	  fi
	cd ./out ; \
	  if [ ! -e ./lib/libcrypto.so.3 ] ; then \
	    ln -s ../lib64/libcrypto.so.3 ./lib/libcrypto.so.3 ; \
	  fi ; \
	  if [ ! -e ./lib/libcrypto.so ] ; then \
	    ln -s ./libcrypto.so.3 ./lib/libcrypto.so ; \
	  fi

openssl:
	cd openssl-master ; ./Configure --prefix=$$(pwd)/../out
	$(MAKE) -C openssl-master
# 	$(MAKE) -C openssl-master test
	$(MAKE) -C openssl-master install
	$(MAKE) openssl-make-link

# DESTDIR := $$(pwd)
# PREFIX := /out

print-%:
	DESTDIR=${DESTDIR} PREFIX=${PREFIX} echo "$* == ${$*}"

# include /home/fill/Documents/ELTEX_proj/netconf_learning/OpenYuma-master/netconf/src/platform/platform.profile

