Copyright (c) 2020-2020 Gatecoin Developers

Distributed under the MIT/X11 software license, see the accompanying
file COPYING or http://www.opensource.org/licenses/mit-license.php.
This product includes software developed by the OpenSSL Project for use in the [OpenSSL Toolkit](http://www.openssl.org/). This product includes
cryptographic software written by Eric Young ([eay@cryptsoft.com](mailto:eay@cryptsoft.com)), and UPnP software written by Thomas Bernard.


WINDOWS BUILD NOTES
===================

Commands:
-------
WLS:

	sudo apt-get install p7zip-full autoconf automake autopoint bash bison bzip2 cmake flex gettext git g++
	sudo apt-get install gperf intltool libffi-dev libtool libltdl-dev libssl-dev libxml-parser-perl make 
	sudo apt-get install openssl patch perl pkg-config python ruby scons sed unzip wget xz-utils

If WLS is 64 bits, run too:

	sudo apt-get install g++-multilib libc6-dev-i386
	
Then, in WLS as ROOT (Building dependencies):
	
	cd /mnt
	git clone https://github.com/mxe/mxe.git
	
	cd /mnt/mxe
	make MXE_TARGETS="i686-w64-mingw32.static" boost
	make MXE_TARGETS="i686-w64-mingw32.static" qttools
	make MXE_TARGETS="i686-w64-mingw32.static" openssl
	
	cd /mnt
	wget http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz
	tar zxvf db-5.3.28.tar.gz
	cd /mnt/db-5.3.28
	touch compile-db.sh
	chmod ugo+x compile-db.sh
	nano compile-db.sh

Then, in the editor, paste this:

	#!/bin/bash
	MXE_PATH=/mnt/mxe
	sed -i "s/WinIoCtl.h/winioctl.h/g" src/dbinc/win_db.h
	mkdir build_mxe
	cd build_mxe

	CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
	CXX=$MXE_PATH/usr/bin/i686-w64-mingw32.static-g++ \
	../dist/configure \
		--disable-replication \
		--enable-mingw \
		--enable-cxx \
		--host x86 \
		--prefix=$MXE_PATH/usr/i686-w64-mingw32.static

	make
	make install
	
Do CRTL+O to save and then, run it with:

	./compile-db.sh
	
Then, in WLS (Still with ROOT) (Building dependencies):

	cd /mnt
	wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
	tar zxvf miniupnpc-1.6.20120509.tar.gz
	cd /mnt/miniupnpc-1.6.20120509
	touch compile-m.sh
	chmod ugo+x compile-m.sh
	nano compile-m.sh
	
Then, in the editor, paste this:
	
	#!/bin/bash
	MXE_PATH=/mnt/mxe

	CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
	AR=$MXE_PATH/usr/bin/i686-w64-mingw32.static-ar \
	CFLAGS="-DSTATICLIB -I$MXE_PATH/usr/i686-w64-mingw32.static/include" \
	LDFLAGS="-L$MXE_PATH/usr/i686-w64-mingw32.static/lib" \
	make libminiupnpc.a

	mkdir $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
	cp *.h $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
	cp libminiupnpc.a $MXE_PATH/usr/i686-w64-mingw32.static/lib

Do CRTL+O to save and then, run it with:

	./compile-m.sh
	
Now, we begin building the wallet:

	export PATH=/mnt/mxe/usr/bin:$PATH
	
	cd /mnt
	git clone https://github.com/Gatecoin-GATE/Gatecoin.git
	
	cd /mnt/Gatecoin/src/leveldb
	TARGET_OS=NATIVE_WINDOWS make libleveldb.a libmemenv.a CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++
	
	cd /mnt/Gatecoin
	chmod ugo+x compile-msw-mxe.sh
	./compile-msw-mxe.sh

Then, the gatecoin-qt.exe is in /mnt/Gatecoin/release

If you want build the deamon(AS ROOT):
	
	export PATH=/mnt/mxe/usr/bin:$PATH

	cd /mnt
	git clone https://github.com/Gatecoin-GATE/Gatecoin.git

	cd /mnt/Gatecoin/src/leveldb
	TARGET_OS=NATIVE_WINDOWS make libleveldb.a libmemenv.a CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++

	cd /mnt/Gatecoin/src
	chmod ugo+x compile-msw-mxe-d.sh
	./compile-msw-mxe-d.sh
	
Then, the gatecoind.exe go to be in /mnt/Gatecoin/src

**If you get a error related to build.h, copy the build.h that is in src/obj/build.h to src

	
	
	



